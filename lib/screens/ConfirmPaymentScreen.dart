import 'dart:math';
import 'dart:ui';

import 'package:bank_application/resources/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../TransactionService.dart';
import '../widgets/CustomAppBar.dart';
import 'DashBoardScreen.dart';
import 'PaymentConfirmationScreen.dart';
import 'SendMoneyScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_platform_interface/firebase_database_platform_interface.dart' as firebase_transaction;
import 'package:bank_application/Transaction.dart' as app_transaction;



final DatabaseReference _balanceRef = FirebaseDatabase.instance
    .ref()
    .child('accountHolder')
    .child('balance');

class ConfirmPaymentScreen extends StatefulWidget {
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

  @override
  _ConfirmPaymentScreenState createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final String formattedDate = DateFormat('dd-MM-yyyy – HH:mm').format(DateTime.now());

late double totalAmount;
  late final String transactionId;

  @override
  void initState() {
    super.initState();
    transactionId = _generateTransactionId();
  }

  String _generateTransactionId() {
    var rng = Random();
    return List.generate(7, (_) => rng.nextInt(10)).join();
  }
// Method to create and save the transaction
  Future<void> _createAndSaveTransaction() async {
    // Calculate the total amount with charges
    double charges = _calculateBankCharges();
    double totalAmount = widget.amount + charges;

    // Generate transactionId and formatted date
    final String transactionId = _generateTransactionId();
    final String formattedDate = DateFormat('dd-MM-yyyy – HH:mm').format(DateTime.now());

    // Create the transaction object
    final transaction = app_transaction.Transaction(
      transactionId: transactionId,
      beneficiaryaccountNumber: widget.accountNumber,
      bankName: widget.bankName,
      beneficiaryName: widget.beneficiaryName,
      amount: totalAmount, // Convert to string with 2 decimal points
      date: formattedDate,
    );

    print('Transaction ID: ${transaction.transactionId}');

    // Save the transaction to Firebase
    final transactionService = TransactionService();
    await transactionService.saveTransaction(widget.accountNumber, transaction);
  }

  void _onSendMoneyPressed() async {
    print("_updateBalance called");

    // Update balance before transaction
    _updateBalance();

    // Wait for the transaction to be created and saved
    await _createAndSaveTransaction();

    // Proceed with navigation or further actions
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(
          beneficiaryname: widget.beneficiaryName,
          transactionid: transactionId,
          date: formattedDate,
          accountNumber: widget.accountNumber,
          bankLogo: widget.bankLogo,
          bankName: widget.bankName,
          amount: widget.amount,
        ),
      ),
    );
  }


  Future<void> _updateBalance() async {
    print('Initiating balance update...');
    try {
      // Verify if the reference is correct
      print('Reference path: ${_balanceRef.path}');

      // Fetch the current balance
      final snapshot = await _balanceRef.get();
      print('Snapshot fetched: ${snapshot.value}');

      if (snapshot.exists) {
        // Parse and log the current balance
        double currentBalance = double.tryParse(snapshot.value.toString()) ?? 0.0;
        print('Current balance is: $currentBalance');

        // Calculate charges and new balance
        double charges = _calculateBankCharges();
        print('Bank charges calculated: $charges');
        double newBalance = currentBalance - widget.amount - charges;
        print('Calculated new balance: $newBalance');

        // Update the balance in Firebase
        await _balanceRef.set(newBalance);
        print('Balance successfully updated to: $newBalance');
      } else {
        // Log error if the balance data is missing
        print('Error: Balance snapshot does not exist.');
        _showErrorDialog(context, 'Error', 'Unable to fetch balance.');
      }
    } catch (e) {
      // Log the specific error for further inspection
      print('Exception occurred: $e');
      _showErrorDialog(context, 'Error', 'An error occurred while updating balance.');
    }
  }




  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to calculate bank charges
  double _calculateBankCharges() {
    return widget.amount > 50000 ? 0.002 * widget.amount : 0.0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Send Money"),
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
                    'lib/resources/banklogo/meezan.png', // Path to the image asset in the project
                    width: 40.0,                       // Width of the image
                    height: 40.0,                      // Height of the image
                  ),

                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountHolderName, // Replace with actual account holder name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CustomFont',
                        ),
                      ),
                      Text(
                        accountHolderAccountNumber, // Replace with actual account holder account number
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
                  _buildRow('Account Number', widget.accountNumber, Colors.white),
                  _buildRow('Account Title', widget.beneficiaryName, Colors.white),
                  _buildRow('Bank Name', widget.bankName, Colors.white),
                  _buildRow('Branch', '', Colors.white), // Add branch info if available
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
                  _buildRow('Amount', widget.amount.toStringAsFixed(2), Colors.white),
                  _buildRow('Bank Charges', _calculateBankCharges().toStringAsFixed(2), AppColors.yellowcolor),
                  _buildRow('Total Amount', (widget.amount + _calculateBankCharges()).toStringAsFixed(2), Colors.white),
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
          builder: (context) =>
                SendMoneyScreen(
                  beneficiaryName: widget.beneficiaryName,
                  accountNumber: widget.accountNumber,
                  bankLogo: widget.bankLogo,
                  bankName: widget.bankName,
                ),
        ),
      );
        },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical:10),
                      backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Set border radius to zero for no rounded edges
                        )
                    ),
                    child: Text('Cancel', style: TextStyle(color: Colors.black,fontSize: 20)),
                  ),
                ),
                //SizedBox(width: 8.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _onSendMoneyPressed();

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical:10),
                      backgroundColor: Colors.amber,
                        shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Set border radius to zero for no rounded edges
                    )
                    ),
                    child: Text('Pay Now',
                    style: TextStyle(color: Colors.black,fontSize:20),
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: textColor, fontSize: 17),
          ),
          Text(
            value,
            style: TextStyle(color: textColor, fontSize: 17),
          ),
        ],
      ),
    );
  }
}