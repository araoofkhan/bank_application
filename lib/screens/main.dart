import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:bank_application/screens/DashBoardScreen.dart';

import 'package:bank_application/resources/colors.dart';
// Import the colors.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyB-ILkgjLQBjMb6NOui5T6bJZHpcwBJ3Ao',
        appId: '1:644421024324:android:7ed4a53c998c41a0f69a11',
        messagingSenderId: '644421024324',
        projectId: 'bank-application-9a107',
        storageBucket: 'bank-application-9a107.appspot.com',
      )
  );
  runApp(MyApp());


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
      home: DashBoardScreen() );
  }
}
