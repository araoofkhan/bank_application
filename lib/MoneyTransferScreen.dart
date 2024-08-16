import 'package:bank_application/resources/colors.dart';
import 'package:flutter/material.dart';

class MoneyTransferScreen extends StatelessWidget {
  const MoneyTransferScreen({super.key});

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
            icon: const Icon(Icons.home),
            color: Color(0xFFFFD400),
            onPressed: () {
              // Handle home icon press
              print('Home icon pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            color: Color(0xFFFFD400),
            onPressed: () {
              // Handle login icon press
              print('Login icon pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Color(0xFFFFD400),
            onPressed: () {
              // Handle notification icon press
              print('Notification icon pressed');
            },
          ),
        ],
      ),
      body: Center(
        child: const Text(
          'Money Transfer Screen Content',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'CustomFont',
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
