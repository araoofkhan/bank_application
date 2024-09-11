// lib/widgets/CustomAppBar.dart
import 'package:flutter/material.dart';
import 'package:bank_application/resources/colors.dart'; // Update this import path as needed
import 'package:bank_application/screens/DashBoardScreen.dart'; // Update this import path as needed

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primarycolor,
      title: Text(
        title,
        style: const TextStyle(
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (route) => false, // This will remove all the previous routes
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
