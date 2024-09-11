import 'package:bank_application/resources/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bank_application/screens/MoneyTransferScreen.dart';
import 'package:bank_application/widgets/CustomBottomAppBar.dart';

import 'SoundTestScreen.dart';


// Global function to format currency


// Global variables for account information
double balance = 0.0;
String formattedAmount = '';
String accountHolderName = '';
String accountHolderAccountNumber = '';
String branchname = '';

String formatAmount(double amount) {
  final formatter = NumberFormat('##,###.##', 'en_US');
  return formatter.format(amount);
}



class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccountHolderInfo();
  }

  Future<void> _fetchAccountHolderInfo() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('accountHolder');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      setState(() {
        balance = double.parse(snapshot.child('balance').value.toString());
        accountHolderName = snapshot.child('name').value.toString();
        accountHolderAccountNumber = snapshot.child('accountNumber').value.toString();
        branchname = snapshot.child('branch').value.toString(); // Fetching branch info
        formattedAmount = formatAmount(balance);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('No account holder data found');
    }
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (popInvokedCallback) {
          // This callback is triggered when the back button is pressed
          popInvokedCallback; // Return false to prevent back navigation
        },
   child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: const Text(
          "MEEZAN BANK",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CustomFont',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Handle notification icon press
              print('Notification icon pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new_sharp),
            onPressed: () {
              // Handle login icon press
              print('Login icon pressed');
            },
            color:AppColors.yellowcolor
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Background color for the body
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(0.0), // Add padding inside the container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 10.0), // Margin for the container
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(5.0, 10.0, 8.0, 8.0),
              width: double.infinity, // Full width of the screen
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hide Balance',
                    style: TextStyle(
                      color: AppColors.primarycolor,
                      fontFamily: 'CustomFont',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Text(
                      accountHolderName,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'CustomFont',
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0), // Add spacing between texts
                  Center(
                    child: Text(
                      formattedAmount,
                      style: const TextStyle(
                        color: AppColors.primarycolor,
                        fontFamily: 'CustomFont',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0), // Add spacing between texts
                  Center(
                    child: Text(
                      accountHolderAccountNumber,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'CustomFont',
                        fontSize: 15,
                      ),
                    ),
                  ),
                   Center(
                    child: Text(
                      branchname,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'CustomFont',
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0), // Add some space before the new row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.primarycolor, // Background color for Text 1
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text(
                              'Share account Info',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CustomFont',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0), // Space between Texts
                      Expanded(
                        child: Container(
                          color: AppColors.primarycolor, // Background color for Text 2
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                            child: Text(
                              'View Statement',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CustomFont',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0), // Add margin only from top
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MoneyTransferScreen(),
                                        ),
                                      );
                                      print('Send Money tapped');
                                    },
                                    child: Image.asset('lib/resources/icons/moneytransfer.png', width: 50, height: 50), // Adjust size as needed
                                  ),
                                 // const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Money transfer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'CustomFont',
                                    ), // Adjust size as needed
                                  ),
                                  const SizedBox(height: 10), // Space between text and next image

                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap for "Send Money" image
                                      print('Debit Card Tapped');
                                    },
                                    child:
                                  Image.asset('lib/resources/icons/creditcard.png', width: 50, height: 50),
                                  ),
                              //    const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Debit Card',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                  const SizedBox(height: 10), // Space between text and next image

                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap for "Send Money" image
                                      print('Donations Tapped');
                                    },
                                    child:
                                    Image.asset('lib/resources/icons/donations.png', width: 50, height: 50),
                                  ),


                                //  const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Zakat & Sadqat',
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
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10.0), // Add margin only from top
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap for "Send Money" image
                                      print('Bills Tapped');
                                    },
                                    child:
                                    Image.asset('lib/resources/icons/bill.png', width: 50, height: 50),
                                  ), // Adjust size as needed
                               //   const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Bills & Top up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                  const SizedBox(height: 10), // Space between text and next image
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap for "Send Money" image
                                      print('Raast Tapped');
                                    },
                                    child:
                                    Image.asset('lib/resources/icons/raast.png', width: 50, height: 50,color: Colors.white),
                                  ),
                               //   const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Raast Payments',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'CustomFont',
                                    ),
                                  ),
                                  const SizedBox(height: 10), // Space between text and next image
                                  GestureDetector(
                                    onTap: () {
                                      // Handle the tap for "Send Money" image
                                      print('Setting Tapped');
                                    },
                                    child:
                                    Image.asset('lib/resources/icons/settings.png', width: 50, height: 50),
                                  ),
                               //   const SizedBox(height: 10), // Space between image and text
                                  const Text(
                                    'Settings',
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
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30.0), // Add margin only from top
                    child: Column(
                      children: [

                        GestureDetector(
                          onTap: () {
                            // Handle the tap for "Send Money" image
                            print('Feed Back Tapped');
                          },
                          child:
                          Image.asset('lib/resources/icons/feedback.png', width: 60, height: 60),
                        ),


                      //  const SizedBox(height: 10),
                        const Text(
                          'Feed Back',
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
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(), // Add the CustomBottomAppBar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for barcode scanner
        },
        backgroundColor: AppColors.primarycolor,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 45), // Background color for the scanner icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ));
  }
}
