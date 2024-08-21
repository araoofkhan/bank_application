import 'dart:ui';

import 'package:bank_application/resources/colors.dart';
import 'package:bank_application/screens/sendmoneyscreen.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'DashBoardScreen.dart';
import 'PaymentConfirmationScreen.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final double amount;
  final String beneficiaryName;
  final String bankLogo;
  final String accountNumber;
  final String bankName;

  ConfirmPaymentScreen({
    required this.amount,
    required this.beneficiaryName,
    required this.bankLogo,
    required this.accountNumber,
    required this.bankName,
  });

  double bankCharges() {
    double charges = 0.0;

  //  double numericAmount = double.tryParse(amount) ?? 0.0; // Convert amount to double

    if (amount > 50000) {
      charges = 0.002 * amount;

    } else {
    charges=0;
    }

    return charges;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money',style: TextStyle(color:AppColors.yellowcolor),),
        backgroundColor: Colors.purple,

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
            icon: Icon(Icons.notifications, color: AppColors.yellowcolor),
            onPressed: () {
              // Handle notifications button action
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new, color: AppColors.yellowcolor),
            onPressed: () {
              // Handle power off button action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From Account',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'lib/resources/banklogo/meezan.png', // Use bankLogo to dynamically load the image
                    width: 40.0,
                    height: 40.0,
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountHolderName, // Replace with actual global or passed value
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Text(
                        accountHolderaccountNmber, // Replace with actual global or passed value
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'To',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Account Number', accountNumber,Colors.white),
                  _buildRow('Account Title', beneficiaryName,Colors.white),
                  _buildRow('Bank Name', bankName,Colors.white),
                  _buildRow('Branch', '',Colors.white), // Add branch info if available
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Transfer Detail',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Amount', amount.toStringAsFixed(2),Colors.white), // Display the amount with 2 decimal places
                  _buildRow('Bank Charges', bankCharges().toStringAsFixed(2),AppColors.yellowcolor), // Display the bank charges with 2 decimal places
                  _buildRow('Total Amount', (amount + bankCharges()).toStringAsFixed(2),Colors.white), // Display total amount (sum of amount and bank charges)

                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle cancel action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) =>   SendMoneyScreen(beneficiaryName: beneficiaryName,
                              accountNumber: accountNumber, bankLogo: bankLogo, bankName: bankName)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text('Cancel', style: TextStyle(color: Colors.black,)),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>   PaymentConfirmationScreen(nickname: beneficiaryName,
                                  accountNumber: accountNumber, bankLogo: bankLogo, bankName: bankName, amount: amount)));


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: Text('Pay Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value,Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: textColor,fontSize: 17),
          ),
          Text(
            value,
            style: TextStyle(color: textColor,fontSize: 17),
          ),
        ],
      ),
    );
  }
}
