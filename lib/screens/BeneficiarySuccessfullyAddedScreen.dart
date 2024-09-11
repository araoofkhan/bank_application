import 'package:flutter/material.dart';

import '../models/BankModel.dart';
import '../resources/colors.dart';
import 'DashBoardScreen.dart';
import 'MoneyTransferScreen.dart';
import 'SendMoneyScreen.dart'; // Adjust the import path



class BeneficiarySuccessfullyAddedScreen extends StatelessWidget {
  final BankModel bankModel;
  final String nickname;
  final String beneficiaryaccountnumber;


  const BeneficiarySuccessfullyAddedScreen({
    Key? key,
    required this.bankModel, required  this.nickname, required this.beneficiaryaccountnumber,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Retrieve screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: const Text(
          "Send Money",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CustomFont',
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            color: AppColors.yellowcolor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashBoardScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new_sharp),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black, // Set the background color to black
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, size: 120, color: Colors.green),
                    SizedBox(height: screenHeight * 0.02), // Adjusts according to screen height
                    const Text(
                      'Beneficiary Added Successfully',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.15, // 15% of screen width
                        maxHeight: screenHeight * 0.08, // 8% of screen height
                      ),
                      child: Image.asset(
                        bankModel.bankLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      bankModel.bankName,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'You have successfully added ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      nickname, // Display the nickname
                      style: TextStyle(
                        color: AppColors.yellowcolor, // Set the text color to yellow
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' as a beneficiary.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Spacer to push buttons to the bottom
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // 5% of screen width
                vertical: screenHeight * 0.02, // 2% of screen height
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SendMoneyScreen(
                                beneficiaryName: nickname, // Assuming nickname is passed
                                accountNumber:beneficiaryaccountnumber, // Ensure these values are available
                                bankLogo: bankModel.bankLogo, // Ensure these values are available
                                bankName:bankModel.bankName, // Ensure these values are available
                              ),));
                        // Handle Pay Now button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Button background color
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // Vertical padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Set edges to not be rounded
                        ),
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold) // Set text color to white
                      ),
                    ),
                  ),
                  const SizedBox(width: 0), // Space between the buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MoneyTransferScreen()));
                        // Handle OK button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowcolor, // Button background color
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02, // Vertical padding
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Set edges to not be rounded
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold) , // Set text color to white
                      ),
                    ),
                  ),
                ],
              ),
            )



          ],
        ),
      ),
    );
  }
}
