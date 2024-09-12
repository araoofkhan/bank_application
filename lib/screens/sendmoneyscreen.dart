import 'package:bank_application/screens/ConfirmPaymentScreen.dart';
import 'package:bank_application/screens/DashBoardScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../resources/colors.dart';


class SendMoneyScreen extends StatefulWidget {
  final String beneficiaryName;
  final String accountNumber;
  final String bankLogo;
  final String bankName;

  SendMoneyScreen({
    required this.beneficiaryName,
    required this.accountNumber,
    required this.bankLogo,
    required this.bankName,
  });

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String _selectedPurpose = "Other";
  bool _isExpanded = false;
  late TextEditingController _amountController;
  double _updatedBalance = 0.0;
  double _initialBalance = 0.0;
  String formattedInitialBalance = '';
  String formattedUpdatedBalance = '';
  FocusNode _focusNode = FocusNode();

  final DatabaseReference _balanceRef = FirebaseDatabase.instance.ref().child('accountHolder/balance');


  @override
  void initState() {
    super.initState();

    // Initialize the TextEditingController
    _amountController = TextEditingController();
    // Add a listener to the controller to update balance when text changes
    _amountController.addListener(_updateBalance);

    // Initialize FocusNode to manage focus state
    _focusNode = FocusNode();

    // Ensure the focus is removed when the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.unfocus();
    });

    // Fetch initial balance data from Firebase
    _fetchBalanceFromFirebase();
  }




  @override
  void dispose() {
    // Dispose of controllers and focus nodes to avoid memory leaks
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  Future<void> _fetchBalanceFromFirebase() async {
    try {
      // Fetch the snapshot from Firebase
      final snapshot = await _balanceRef.get();

      // Check if the snapshot has data
      if (snapshot.exists) {
        // Directly parse the snapshot value to double
        _initialBalance = double.tryParse(snapshot.value.toString()) ?? 0.0;
        _updatedBalance = _initialBalance;

        // Update the state with formatted values for display
        setState(() {
          formattedInitialBalance = formatAmount(_initialBalance); // Format only for display
          formattedUpdatedBalance = formatAmount(_updatedBalance);
        });

        // Display success message
  /*      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Balance fetched successfully: $formattedInitialBalance'),
            backgroundColor: Colors.green,
          ),
        );*/
      } else {
        // Display message if no data found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No balance data found in Firebase.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching balance: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




  String formatInputAmount(String amount) {
    // Strip out all non-numeric characters except the decimal point.
    String sanitizedInput = amount.replaceAll(RegExp(r'[^0-9.]'), '');

    // Return immediately if the input is empty or a single dot.
    if (sanitizedInput.isEmpty || sanitizedInput == '.') {
      return sanitizedInput;
    }

    // Split input into the integer and decimal parts.
    List<String> parts = sanitizedInput.split('.');

    // Format the integer part with commas.
    parts[0] = NumberFormat('#,###').format(int.parse(parts[0]));

    // Rejoin the parts, limiting decimals to two if present.
    return parts.length > 1 ? '${parts[0]}.${parts[1]}' : parts[0];
  }




  void _updateBalance() {
    final enteredAmountString = _amountController.text;
    final sanitizedInput = enteredAmountString.replaceAll(RegExp(r'[^0-9.]'), '');
    final enteredAmount = double.tryParse(sanitizedInput) ?? 0.0;

    setState(() {
      _updatedBalance = sanitizedInput.isEmpty ? _initialBalance : _initialBalance - enteredAmount;
      formattedUpdatedBalance = formatAmount(_updatedBalance);

      // Apply formatting when necessary, but cautiously to avoid breaking the input flow.
      if (enteredAmountString != sanitizedInput && sanitizedInput.isNotEmpty) {
        final formattedInputAmount = formatInputAmount(sanitizedInput);
        _amountController.value = TextEditingValue(
          text: formattedInputAmount,
          selection: TextSelection.collapsed(offset: formattedInputAmount.length),
        );
      }
    });
  }



  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }
  void _handleNextButton() {
    // Get the amount entered by the user
    final enteredAmountString = _amountController.text;
    // Sanitize the input to allow only numbers and decimals
    final sanitizedInput = enteredAmountString.replaceAll(RegExp('[^0-9.]'), '');
    // Parse the sanitized input into a double
    final enteredAmount = double.tryParse(sanitizedInput) ?? 0.0;

    if (enteredAmount <= 0 || enteredAmountString.isEmpty) {
      // Show an alert dialog if the input is empty or amount is zero
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter a valid amount greater than zero.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (_updatedBalance <= 0) {
      // Show an alert dialog if the balance is insufficient
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Balance'),
            content: Text('You do not have enough balance for this transaction.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      _dismissKeyboard(); // Hide the keyboard before proceeding

      // Navigate to the ConfirmPaymentScreen with relevant data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPaymentScreen(
            amount: enteredAmount, // Pass the amount as double
            beneficiaryName: widget.beneficiaryName,
            bankLogo: widget.bankLogo,
            accountNumber: widget.accountNumber,
            bankName: widget.bankName,
          ),
        ),
      );
    }
  }

// Helper method to dismiss the keyboard
  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }



  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (isFocused) {
        if (!isFocused) {
          _focusNode.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primarycolor,
          title: const Text(
            'Send Money',
            style: TextStyle(color: AppColors.yellowcolor, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home, color: AppColors.yellowcolor),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashBoardScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.yellowcolor),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: AppColors.yellowcolor),
              onPressed: () {},
            ),
          ],
        ),
        body: GestureDetector(
          onTap: _dismissKeyboard,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Container(
                      color: Colors.black,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'To Account',
                            style: TextStyle(
                              color: AppColors.yellowcolor,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  widget.bankLogo,
                                  height: 40,
                                  width: 40,
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.beneficiaryName,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.accountNumber,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Available Balance Rs.$formattedUpdatedBalance',
                            style: TextStyle(
                              color: AppColors.greenwcolor,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            focusNode: _focusNode,
                            controller: _amountController,
                           keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allows digits and one decimal point
                            ],
                            style: TextStyle(color: Colors.white, fontSize: 19),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black,
                              hintText: 'Enter amount',
                              hintStyle: TextStyle(color: Colors.white, fontSize: 19),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Enter an amount between Rs.1 and Rs.1,000,000.",
                            style: TextStyle(color: AppColors.yellowcolor, fontSize: 17),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Purpose of Payment",
                            style: TextStyle(color: AppColors.yellowcolor, fontSize: 17),
                          ),
                          SizedBox(height: 8.0),
                          Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              key: GlobalKey(),
                              title: Text(
                                _selectedPurpose,
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                              initiallyExpanded: _isExpanded,
                              onExpansionChanged: (bool expanded) {
                                setState(() => _isExpanded = expanded);
                              },
                              backgroundColor: Colors.black,
                              children: <Widget>[
                                _buildExpandableItem('Other'),
                                _buildExpandableItem('Bills Payment'),
                                _buildExpandableItem('Loan Repayment'),
                                _buildExpandableItem('Gift'),
                              ],
                            ),
                          ),
                         // SizedBox(height: 20.0),
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarycolor,
                                padding: EdgeInsets.symmetric(vertical:15.0),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Set border radius to zero for no rounded edges
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                _handleNextButton();
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(color: AppColors.yellowcolor, fontSize: 22),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }




    Widget _buildExpandableItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        _dismissKeyboard;
        setState(() {

          _selectedPurpose = title;
          _isExpanded = false; // Collapse the ExpansionTile after selection
        });
      },
    );
  }
}
