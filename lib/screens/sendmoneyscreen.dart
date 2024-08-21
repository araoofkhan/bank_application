import 'package:bank_application/screens/ConfirmPaymentScreen.dart';
import 'package:bank_application/screens/DashBoardScreen.dart';
import 'package:flutter/material.dart';
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
    required this.bankLogo, required this.bankName,
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

  @override
  void initState() {
    super.initState();

    // Example initial value, update accordingly
    final String formattedAmount = formatAmount(balance); // Ensure formatAmount is implemented correctly
    _initialBalance = double.tryParse(formattedAmount.replaceAll(',', '')) ?? 0.0;
    _updatedBalance = _initialBalance;

    formattedInitialBalance = formatAmount(_initialBalance);
    formattedUpdatedBalance = formatAmount(_updatedBalance);

    _amountController = TextEditingController();
    _amountController.addListener(_updateBalance);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String formatInputAmount(String amount) {
    final sanitizedInput = amount.replaceAll(RegExp('[^0-9.]'), '');
    final enteredNumber = double.tryParse(sanitizedInput) ?? 0.0;
    final formatter = NumberFormat('#,###.##', 'en_US');
    return formatter.format(enteredNumber);
  }

  String formatAmount(double amount) {
    final formatter = NumberFormat('#,###.##', 'en_US');
    return formatter.format(amount);
  }

  void _updateBalance() {
    final enteredAmountString = _amountController.text;
    final sanitizedInput = enteredAmountString.replaceAll(RegExp('[^0-9.]'), '');
    final enteredAmount = double.tryParse(sanitizedInput) ?? 0.0;

    setState(() {
      _updatedBalance = sanitizedInput.isEmpty ? _initialBalance : _initialBalance - enteredAmount;
      formattedUpdatedBalance = formatAmount(_updatedBalance);

      final formattedInputAmount = formatInputAmount(enteredAmountString);
      _amountController.value = TextEditingValue(
        text: formattedInputAmount,
        selection: TextSelection.collapsed(offset: formattedInputAmount.length),
      );
    });
  }
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _handleNextButton() {
    final enteredAmountString = _amountController.text;
    final sanitizedInput = enteredAmountString.replaceAll(RegExp('[^0-9.]'), '');
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
      _dismissKeyboard(); // Hide the keyboard

      // Navigate to the ConfirmPaymentScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPaymentScreen(
            amount: enteredAmount, // Pass as double
            beneficiaryName: widget.beneficiaryName,
            bankLogo: widget.bankLogo,
            accountNumber: widget.accountNumber,
            bankName: widget.bankName,
          ),
        ),
      );
    }
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
                          Text(
                            'Available Balance Rs.$formattedUpdatedBalance',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            focusNode: _focusNode,
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
                          Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarycolor,
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                _handleNextButton();
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
