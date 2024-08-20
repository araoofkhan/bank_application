import 'package:bank_application/resources/colors.dart';
import 'package:bank_application/screens/DashBoardScreen.dart';
import 'package:flutter/material.dart';

class ConfirmPaymentScreen extends StatelessWidget {
  final String amount;
  final String beneficiaryName;
  final String bankLogo;
  final String accountNumber;
  ConfirmPaymentScreen({
    required this.amount,
    required this.beneficiaryName,
    required this.bankLogo,
    required this.accountNumber,

  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.home,color: AppColors.yellowcolor,),
            onPressed: () {
              // Handle home button action
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications,color: AppColors.yellowcolor),
            onPressed: () {
              // Handle notifications button action
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new,color: AppColors.yellowcolor),
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
                  Image.asset('lib/resources/banklogo/meezan.png', // Update the image path accordingly
                    width: 40.0,
                    height: 40.0,
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(accountHolderName,style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,fontFamily:'CustomFont'),),
                      Text(accountHolderaccountNmber,style: TextStyle(fontSize:18,fontFamily:'CustomFont'),),
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
                  _buildRow('Account Number','$accountNumber'),
                  _buildRow('Account Title', '$beneficiaryName'),
                  _buildRow('Bank Name', 'bankName'),
                  _buildRow('Branch', ''),
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
                  _buildRow('Amount', formattedAmount),
                  _buildRow('Bank Charges', ''),
                  _buildRow('Total Amount', ''),
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle pay now action
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle floating action button press
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
