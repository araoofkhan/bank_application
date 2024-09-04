import 'package:bank_application/resources/colors.dart';

import 'package:flutter/material.dart';
import 'package:bank_application/widgets/BeneficiaryList.dart';
import 'package:bank_application/screens/AddNewBeneficiaryScreen.dart';

import 'DashBoardScreen.dart';




class MoneyTransferScreen extends StatelessWidget {
  const MoneyTransferScreen({super.key, required String formattedAmount,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primarycolor,
        title: const Text(
          "Send Money",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CustomFont',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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
            icon: const Icon(Icons.notifications),
            color: Color(0xFFFFD400),
            onPressed: () {
              // Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new_sharp),
            color: Color(0xFFFFD400),
            onPressed: () {
              // Login action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        //padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Beneficiary',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            _buildRow(
              icon: Icons.compare_arrows_sharp,
              text: 'Own Account',
              iconColor: AppColors.yellowcolor,
              onTap: () {
                // Navigate to Own Account screen
                Navigator.push(context, MaterialPageRoute(builder: (context) => OwnAccountScreen()));
              },
            ),
            const SizedBox(height: 0.0),
            Divider(color: Colors.grey, indent: 50.0),
            _buildRow(
              icon: Icons.credit_card,
              text: 'Add New Beneficiary',
              iconColor: AppColors.yellowcolor,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>AddNewBeneficiaryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10.0),
           Divider(color: Colors.grey, indent: 50.0),
            // Beneficiary List
            Expanded(child: BeneficiaryList()),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({required IconData icon, required String text, required Color iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0), // Margin from left
        child: Row(
          children: [
            Icon(icon, size: 35, color: iconColor),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(color: AppColors.yellowcolor, fontSize: 18, fontFamily: 'CustomFont'),
            ),
          ],
        ),
      ),
    );
  }
}

class OwnAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Own Account'),
      ),
      body: Center(
        child: Text('Own Account Screen'),
      ),
    );
  }
}
