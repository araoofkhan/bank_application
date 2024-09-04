import 'package:bank_application/models/BankModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 import 'package:bank_application/resources/colors.dart';
// Example usage in your screen
import 'package:flutter/material.dart';
import 'package:bank_application/screens/CustomAppBar.dart';

import 'package:bank_application/screens/DashBoardScreen.dart';

import 'BeneficiarySuccessfullyAddedScreen.dart';
import 'ToastUtil.dart'; // For AddNewBeneficiaryScreen


class AddNicknameScreen extends StatefulWidget {
  final BankModel bank;
  final String accountNumber;

  AddNicknameScreen({required this.bank, required this.accountNumber, });

  @override
  _AddNicknameScreenState createState() => _AddNicknameScreenState();
}

class _AddNicknameScreenState extends State<AddNicknameScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref().child('Bank_Accounts');


  void _saveToFirebase() async {
    // Check if nickname is empty
    if (_nicknameController.text.isEmpty) {
      ToastUtil.showToast(
        context: context,
        message: "Nickname cannot be empty",
      );
      return;
    }

    try {
      // Query Firebase to check if account number already exists
      final querySnapshot = await _dbRef.orderByChild('account_number').equalTo(widget.accountNumber).get();

      if (querySnapshot.exists) {
        // Account number already exists
        ToastUtil.showToast(
          context: context,
          message: "Account number already exists",
        );
        return;;
      }

      // Proceed to save new account details
      await _dbRef.push().set({
        'bank_name': widget.bank.bankName,
        'bank_logo': widget.bank.bankLogo,
        'account_number': widget.accountNumber,
        'nickname': _nicknameController.text,
        // Add any other fields as needed
      });

      print('Beneficiary added successfully');
      ToastUtil.showToast(
        context: context,
        message: "Beneficiary added successfully",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BeneficiarySuccessfullyAddedScreen(
            bankModel: widget.bank,
            nickname: _nicknameController.text,
            account_number: widget.accountNumber,
          ),
        ),
      );
    } catch (error) {
      print('Failed to add beneficiary: $error');
      ToastUtil.showToast(
        context: context,
        message: "Failed to save Beneficiary",
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Send Money"),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Add Beneficiary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.grey[300],
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    widget.bank.bankLogo,
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.bank.bankName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'CustomFont',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Confirm following beneficiary details",
                  style: TextStyle(
                    color: AppColors.yellowcolor,
                    fontSize: 18,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Account Number:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.accountNumber,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Account Title:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Account Title Here", // Replace with actual account title
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Bank Name:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.bank.bankName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Text(
                          "Branch:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Branch Name Here", // Replace with actual branch name
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _nicknameController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'CustomFont',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Nickname',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'CustomFont',
                          ),
                          filled: false,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                     // color: AppColors.yellowcolor,
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate back to the previous screen
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowcolor, // Match the container color
                                padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Square corners
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'CustomFont',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Space between buttons
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveToFirebase, // Call the method to save details
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellowcolor, // Match the container color
                                padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero, // Square corners
                                ),
                              ),
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'CustomFont',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
