import 'package:flutter/material.dart';
import '../resources/colors.dart';

class SendMoneyScreen extends StatelessWidget {
  final String beneficiaryName;
  final String accountNumber;
  final String bankLogo;
  final double availableBalance;

  SendMoneyScreen({
    required this.beneficiaryName,
    required this.accountNumber,
    required this.bankLogo,
    required this.availableBalance,
  });

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
      body: Container(
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
                    bankLogo,
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beneficiaryName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        accountNumber,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Available Balance Rs.$availableBalance',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
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

            // Expandable list
            _PurposeOfPaymentDropdown(),
          ],
        ),
      ),
    );
  }
}

class _PurposeOfPaymentDropdown extends StatefulWidget {
  @override
  __PurposeOfPaymentDropdownState createState() => __PurposeOfPaymentDropdownState();
}

class __PurposeOfPaymentDropdownState extends State<_PurposeOfPaymentDropdown> {
  String _selectedPurpose = 'Other'; // Default option is set to 'Other'

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPurposeOfPaymentSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedPurpose,
              style: TextStyle(color: AppColors.yellowcolor, fontSize: 17),
            ),
            Icon(Icons.arrow_drop_down, color: AppColors.yellowcolor),
          ],
        ),
      ),
    );
  }

  void _showPurposeOfPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Salary', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _updatePurpose('Salary');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Loan Payment', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _updatePurpose('Loan Payment');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Gift', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _updatePurpose('Gift');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Utility Bill', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _updatePurpose('Utility Bill');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Other', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _updatePurpose('Other');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updatePurpose(String purpose) {
    setState(() {
      _selectedPurpose = purpose;
    });
  }
}
