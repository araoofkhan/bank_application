import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bank_application/models/Beneficiary.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../resources/colors.dart';
import '../screens/sendmoneyscreen.dart';



class BeneficiaryList extends StatefulWidget {
  final String searchQuery;

  BeneficiaryList({required this.searchQuery});

  @override
  _BeneficiaryListState createState() => _BeneficiaryListState();
}

class _BeneficiaryListState extends State<BeneficiaryList> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Bank_Accounts');
  bool _isLoading = true;
  bool _isConnected = true;
  List<Map<String, dynamic>> _beneficiaries = [];
  List<Map<String, dynamic>> _filteredBeneficiaries = [];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Set<String> _starredBeneficiaries = {}; // To track starred beneficiaries


  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _checkInternetConnectivity();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }







  // Method to show the edit dialog for updating nickname
  void _showEditDialog(BuildContext context, Beneficiary beneficiary, String beneficiaryKey) {
    final TextEditingController nicknameController = TextEditingController(text: beneficiary.nickname);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Nickname'),
          content: TextField(
            controller: nicknameController,
            decoration: InputDecoration(labelText: 'Enter new nickname'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newNickname = nicknameController.text.trim();
                if (newNickname.isNotEmpty) {
                  _updateNickname(newNickname, beneficiaryKey);
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to update the nickname in Firebase
  void _updateNickname(String newNickname,String  beneficiaryKey) async {
    try {
      await _dbRef.child(beneficiaryKey).update({'nickname': newNickname});
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nickname updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh the list (assuming you have a method to refresh data)
      _fetchData(); // Call this method if available in your main widget to reload data
    } catch (error) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating nickname: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isConnected = true;
        _isLoading = true;
      });
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    // Cancel any existing listeners before starting a new one
    _dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        // Check if the snapshot contains data
        final Map<dynamic, dynamic> beneficiariesMap =
        event.snapshot.value as Map<dynamic, dynamic>;

        // Convert snapshot data to a list of maps containing beneficiary data
        final List<Map<String, dynamic>> beneficiariesList =
        beneficiariesMap.entries.map((entry) {
          final key = entry.key as String;
          final beneficiaryData = Map<String, dynamic>.from(entry.value as Map);
          return {'key': key, 'beneficiary': Beneficiary.fromJson(beneficiaryData)};
        }).toList();

        setState(() {
          _beneficiaries = beneficiariesList;
          _filterBeneficiaries(); // Assuming this filters or sorts your beneficiaries
          _isLoading = false; // Update loading state
        });
      } else {
        // No data found
        setState(() {
          _isLoading = false;
        });
      }
    }).onError((error) {
      // Handle errors and notify the user
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }


  void _filterBeneficiaries() {
    _filteredBeneficiaries = _beneficiaries
        .where((beneficiary) => beneficiary['beneficiary']
        .nickname
        .toLowerCase()
        .contains(widget.searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void didUpdateWidget(covariant BeneficiaryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _filterBeneficiaries();
    }
  }

  void _deleteBeneficiary(String beneficiaryKey) async {
    await _dbRef.child(beneficiaryKey).remove();
    // Refresh the list after deletion
    _fetchData();
  }
  void _showDeleteConfirmationDialog(String beneficiaryKey) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Beneficiary'),
          content: Text('Are you sure you want to delete this beneficiary? '),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),

            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteBeneficiary(beneficiaryKey); // Proceed with deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _toggleStar(String beneficiaryKey) {
    setState(() {
      if (_starredBeneficiaries.contains(beneficiaryKey)) {
        _starredBeneficiaries.remove(beneficiaryKey);
      } else {
        _starredBeneficiaries.add(beneficiaryKey);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _isConnected
        ? _buildBeneficiaryList()
        : Center(child: Text('No internet connection', style: TextStyle(color: Colors.white)));
  }

  Widget _buildBeneficiaryList() {
    return ListView.builder(
      itemCount: _filteredBeneficiaries.length,

      itemBuilder: (context, index) {
        final beneficiaryData = _filteredBeneficiaries[index];
        final beneficiaryKey = beneficiaryData['key'] as String;
        final beneficiary = beneficiaryData['beneficiary'] as Beneficiary;
        final isStarred = _starredBeneficiaries.contains(beneficiaryKey);

        //   bool isFavorite = beneficiary.favorite; // Replace with your actual favorite check logic


        return _buildBeneficiaryTile(beneficiary, beneficiaryKey, isStarred);
      },
    );
  }

  Widget _buildBeneficiaryTile(Beneficiary beneficiary, String beneficiaryKey, bool isStarred) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SendMoneyScreen(
              beneficiaryName: beneficiary.nickname,
              accountNumber: beneficiary.accountNumber,
              bankLogo: beneficiary.bankLogo,
              bankName: beneficiary.bankName,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        child: Stack(
          children: [
            ListTile(
              leading: Image.asset(
                beneficiary.bankLogo,
                width: 50,
                height: 50,
              ),
              title: Text(
                beneficiary.nickname.isEmpty ? beneficiary.bankName : beneficiary.nickname,
                style: TextStyle(color: AppColors.yellowcolor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (beneficiary.accountNumber.isNotEmpty)
                    Text('Account Number: ${beneficiary.accountNumber}', style: TextStyle(color: Colors.white, fontSize: 16)),
                  if (beneficiary.bankName.isNotEmpty)
                    Text('Bank Name: ${beneficiary.bankName}', style: TextStyle(color: Colors.white, fontSize: 16)),
                  if (beneficiary.nickname.isNotEmpty)
                    Text('Nickname: ${beneficiary.nickname}', style: TextStyle(color: Colors.white, fontSize: 16)),
                  Divider(color: Colors.white),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
            child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_border_sharp,
                      color: isStarred ? Colors.yellow : Colors.white,
                    ),
                    onPressed: () {
                      _toggleStar(beneficiaryKey); // Toggle the star state
                    },

                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showEditDialog(context, beneficiary, beneficiaryKey);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _showDeleteConfirmationDialog(beneficiaryKey);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
