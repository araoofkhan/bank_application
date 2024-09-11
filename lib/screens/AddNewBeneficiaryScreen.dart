import 'package:flutter/material.dart';
import 'package:bank_application/models/BankModel.dart';
import 'package:bank_application/BankRepository.dart';
import 'package:bank_application/resources/colors.dart';
import 'package:bank_application/screens/AccountNumberEntryScreen.dart';


import '../widgets/CustomAppBar.dart';
import 'DashBoardScreen.dart';

class AddNewBeneficiaryScreen extends StatefulWidget {
  @override
  _AddNewBeneficiaryScreenState createState() => _AddNewBeneficiaryScreenState();
}

class _AddNewBeneficiaryScreenState extends State<AddNewBeneficiaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BankRepository bankRepository = BankRepository();
  late List<BankModel> filteredBanks;

  @override
  void initState() {
    super.initState();
    filteredBanks = bankRepository.getBanks();
    _searchController.addListener(_filterBanks);
  }

  void _filterBanks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBanks = bankRepository.getBanks()
          .where((bank) => bank.bankName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Send Money"),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search Bank',
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),

            // Bank List Below this
            Expanded(
              child: ListView.builder(
                itemCount: filteredBanks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountNumberEntryScreen(bank: filteredBanks[index]),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset(
                                filteredBanks[index].bankLogo,
                                width: 50, // Fixed width for the logo
                                height: 50, // Fixed height for the logo
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  filteredBanks[index].bankName,
                                  style: TextStyle(
                                    color: AppColors.yellowcolor,
                                    fontSize: 20,
                                    fontFamily: 'CustomFont',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey, indent: 60.0), // Divider starting below the bank name
                        const SizedBox(height: 20.0), // Space between rows
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
