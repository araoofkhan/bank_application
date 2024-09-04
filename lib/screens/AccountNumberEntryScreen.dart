import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bank_application/resources/colors.dart';
import '../models/BankModel.dart';
import 'AddNickNameScreen.dart';
import 'DashBoardScreen.dart';


class AccountNumberEntryScreen extends StatefulWidget {
  final BankModel bank;

  const AccountNumberEntryScreen({required this.bank, Key? key}) : super(key: key);

  @override
  _AccountNumberEntryScreenState createState() => _AccountNumberEntryScreenState();
}

class _AccountNumberEntryScreenState extends State<AccountNumberEntryScreen> {
  final TextEditingController _accountNumberController = TextEditingController();

  void _onNextTapped() {
    if (_accountNumberController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Account number cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddNicknameScreen(
            bank: widget.bank,
            accountNumber: _accountNumberController.text,
          ),
        ),
      );
    }
  }

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
            fontSize: 20,
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
            color: AppColors.yellowcolor,
            onPressed: () {
              // Notification action
            },
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new_sharp),
            color: AppColors.yellowcolor,
            onPressed: () {
              // Power off action
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Beneficiary",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Image.asset(widget.bank.bankLogo, width: 50, height: 50),
                  const SizedBox(width: 10),
                  Text(
                    widget.bank.bankName,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  hintText: 'Enter Account Number',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,


                ),
                style: TextStyle(color: Colors.white,fontSize:20,fontFamily: 'CustomFont'),
               // keyboardType: TextInputType.number,
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: _onNextTapped,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                color: AppColors.yellowcolor,
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
