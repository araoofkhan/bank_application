import 'package:bank_application/resources/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.grey[100],
      shape: const CircularNotchedRectangle(),
      height: 80,
      notchMargin: 12.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBottomNavigationItem('lib/resources/icons/gifts.png', "Gifts"),
                buildBottomNavigationItem('lib/resources/icons/locate.png', "Locate"),
                buildBottomNavigationItem('lib/resources/icons/discounts.png', "Discounts"),

              ],
            ),
          ),
          const SizedBox(width:50), // Space for the barcode scanner icon
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                buildBottomNavigationItem('lib/resources/icons/qibla.png', "Qibla"),
                buildBottomNavigationItem('lib/resources/icons/contact.png', "Contact"),
                buildBottomNavigationItem('lib/resources/icons/faqs.png', "FAQS"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationItem(String assetPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetPath,
          color: AppColors.primarycolor,
          width: 30, // Adjust size as needed
          height: 30,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
