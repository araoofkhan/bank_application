import 'package:flutter/material.dart';
import 'DashBoard_SCREEN.dart';
import 'MoneyTransferScreen.dart';
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
      home: const MoneyTransferScreen(), // Use the corrected class name
    );
  }
}
