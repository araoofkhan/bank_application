import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bank_application/models/Beneficiary.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../screens/sendmoneyscreen.dart';

class BeneficiaryList extends StatefulWidget {
  @override
  _BeneficiaryListState createState() => _BeneficiaryListState();

}

class _BeneficiaryListState extends State<BeneficiaryList> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Bank_Accounts');
  bool _isLoading = true;
  bool _isConnected = true;

  List<Map<String, dynamic>> _beneficiaries = [];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
    super
        .dispose();
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
    _dbRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> beneficiariesMap = event.snapshot.value as Map<dynamic, dynamic>;

        final List<Map<String, dynamic>> beneficiariesList = beneficiariesMap.entries.map((entry) {
          final key = entry.key as String;
          final beneficiaryData = Map<String, dynamic>.from(entry.value as Map);
          return {'key': key, 'beneficiary': Beneficiary.fromJson(beneficiaryData)};
        }).toList();

        setState(() {
          _beneficiaries = beneficiariesList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }).onError((error) {
      setState(() {
        _isLoading = false;
      });
    });
  }
/*
  void _deleteBeneficiary(String key) {
    _dbRef.child(key).remove().then((_) {
      setState(() {
        _beneficiaries.removeWhere((element) => element['key'] == key);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Beneficiary deleted')),
      );
    });
  }*/


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _isConnected
            ? _buildBeneficiaryList()
            : Center(child: Text('No internet connection', style: TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildBeneficiaryList() {
    return ListView.builder(
      itemCount: _beneficiaries.length,
      itemBuilder: (context, index) {
        final beneficiaryData = _beneficiaries[index];
        final beneficiaryKey = beneficiaryData['key'] as String;
        final beneficiary = beneficiaryData['beneficiary'] as Beneficiary;

        return GestureDetector(
          onTap: () {
          /*  ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Tapped on ${beneficiary.nickname.isEmpty ? beneficiary.bankName : beneficiary.nickname}'),
              ),
            );*/

            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => SendMoneyScreen(
              beneficiaryName: beneficiary.nickname,
              accountNumber: beneficiary.accountNumber,
              bankLogo: beneficiary.bankLogo,
              availableBalance: 25000, // Pass the balance (example value)
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
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (beneficiary.accountNumber.isNotEmpty)
                        Text('Account Number: ${beneficiary.accountNumber}', style: TextStyle(color: Colors.white)),
                      if (beneficiary.bankName.isNotEmpty)
                        Text('Bank Name: ${beneficiary.bankName}', style: TextStyle(color: Colors.white)),
                      if (beneficiary.nickname.isNotEmpty)
                        Text('Nickname: ${beneficiary.nickname}', style: TextStyle(color: Colors.white)),
                      Divider(color: Colors.white),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.star, color: Colors.white),
                        onPressed: () {
                          // Implement favorite action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // Implement edit action
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




      },
    );
  }
}
