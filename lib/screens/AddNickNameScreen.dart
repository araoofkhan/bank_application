import 'package:bank_application/models/BankModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 import 'package:bank_application/resources/colors.dart';

import 'package:bank_application/screens/DashBoardScreen.dart';



import '../models/Beneficiary.dart';
import 'BeneficiarySuccessfullyAddedScreen.dart'; // For AddNewBeneficiaryScreen


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


  void _saveToFirebase() {

    if (_nicknameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Nickname cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      return;
    }

    _dbRef.push().set({
      'bank_name': widget.bank.bankName,
      'bank_logo': widget.bank.bankLogo,
      'account_number': widget.accountNumber,
      'nickname': _nicknameController.text,
      //'account_title':
        //  "Account Title Here", // Replace with actual account title
      //'branch_name': "Branch Name Here", // Replace with actual branch name

    }).then((_) {
      print('Beneficiary added successfully');
      Fluttertoast.showToast(
        msg: "Account details saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BeneficiarySuccessfullyAddedScreen(
            bankModel: widget.bank,
            nickname: _nicknameController.text, // Pass the nickname here
          ),
        ),
      );

    }

      ).catchError((error) {
      print('Failed to add beneficiary: $error');
      Fluttertoast.showToast(
        msg: "Error saving details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: Text(
          "Send Money",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CustomFont',
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            color: AppColors.yellowcolor,
            onPressed: () {
              onTap:
              () {
                print('Home icon pressed');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashBoardScreen(),
                  ),
                );
              };
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new_sharp),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
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
