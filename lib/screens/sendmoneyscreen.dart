import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../resources/colors.dart';
class SendMoneyScreen extends StatefulWidget {
  final String beneficiaryName;
  final String accountNumber;
  final String bankLogo;


  SendMoneyScreen({
    required this.beneficiaryName,
    required this.accountNumber,
    required this.bankLogo,


  });

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}
class _SendMoneyScreenState extends State<SendMoneyScreen> {
  String _selectedPurpose = "Other";
  bool _isExpanded = false;
  late TextEditingController _amountController = TextEditingController(); // Marked as final
  double _updatedBalance = 0.0;
  double _initialBalance = 0.0; // Store the initial balance as a double
  String formattedInitialBalance = ''; // Store the formatted initial balance as a string
  String formattedUpdatedBalance = ''; // Store the formatted updated balance as a string

  @override
  void initState() {
    super.initState();


    // Assume formattedAmount is a globally available variable or method
    String formattedAmount = formatAmount(50000.00); // Example initial value
    _initialBalance = double.tryParse(formattedAmount.replaceAll(',', '')) ?? 0.0;
    _updatedBalance = _initialBalance;

    // Format the initial balance
    formattedInitialBalance = formatAmount(_initialBalance);
    formattedUpdatedBalance = formatAmount(_updatedBalance);

    _amountController = TextEditingController();
    // Add listener to the amount controller
    _amountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String formatAmount(double amount) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '');
    return currencyFormat.format(amount);
  }

  String formatInputAmount(String input) {
    // Remove non-numeric characters except for the decimal point
    final sanitizedInput = input.replaceAll(RegExp('[^0-9.]'), '');

    // Parse sanitized input as a double
    final enteredNumber = double.tryParse(sanitizedInput) ?? 0.0;

    // Format the sanitized number with commas
    final formatter = NumberFormat('#,###.##', 'en_US');
    final formattedNumber = formatter.format(enteredNumber);

    return formattedNumber;
  }

  void _updateBalance() {
    final enteredAmountString = _amountController.text;
    final sanitizedInput = enteredAmountString.replaceAll(RegExp('[^0-9.]'), '');
    final enteredAmount = double.tryParse(sanitizedInput) ?? 0.0;

    setState(() {
      if (sanitizedInput.isEmpty) {
        _updatedBalance = _initialBalance;
      } else {
        _updatedBalance = _initialBalance - enteredAmount;
      }

      // Format the updated balance after calculation
      formattedUpdatedBalance = formatAmount(_updatedBalance);

      // Format the text field input and update it with the formatted value
      final formattedInputAmount = formatInputAmount(enteredAmountString);
      _amountController.value = TextEditingValue(
        text: formattedInputAmount,
        selection: TextSelection.collapsed(offset: formattedInputAmount.length),
      );
    });
  }




  void _dismissKeyboard() {
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  }

  void _handleNextButton() {
    if (_updatedBalance < 0) {
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
      // Add your "Next" button logic here if balance is sufficient
      print('Proceed to next step');
      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: const Text(
          'Send Money',
          style: TextStyle(color: AppColors.yellowcolor, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: AppColors.yellowcolor),
            onPressed: () {},
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
    onTap: _dismissKeyboard, // Dismiss keyboard on tap outside TextField
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
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.accountNumber,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                  Text('Available Balance Rs.$formattedUpdatedBalance',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 16.0),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
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
                      SizedBox(height: 20.0),
                      Spacer(), // Spacer to push the "Next" button to the bottom
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primarycolor,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: (){
                            _handleNextButton();

                       // Add your "Next" button logic here
                          },

                            child: Text(
                            'Next',
                            style: TextStyle(color: AppColors.yellowcolor, fontSize: 18),
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
    )
    );
  }

  Widget _buildExpandableItem(String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        setState(() {
          _selectedPurpose = title;
          _isExpanded = false; // Collapse the ExpansionTile after selection
        });
      },
    );
  }
}
