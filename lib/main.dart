import 'package:bank_application/screens/DashBoardScreen.dart';
import 'package:bank_application/screens/MoneyTransferScreen.dart';
import 'package:flutter/material.dart';


import 'resources/colors.dart'; // Import the colors.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primarycolor,
        fontFamily: 'CustomFont', // Apply custom font globally

        useMaterial3: true,
      ),
      home:  DashBoardScreen(), // Use the corrected class name
    );
  }
}
