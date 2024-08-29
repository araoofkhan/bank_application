import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // For formatting numbers

class AccountInfo {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('Account_Info');

  Future<Map<String, dynamic>> fetchAccountInfo() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return {
        'accountHolderName': data['accountHolderName'] ?? 'Unknown',
        'accountHolderAccountNumber': data['accountHolderAccountNumber'] ?? 'Unknown',
        'balance': data['balance'] ?? 0.0,
      };
    } else {
      throw Exception('Account info not found');
    }
  }

  String formatAmount(double amount) {
    final NumberFormat formatter = NumberFormat('#,##0.00');
    return formatter.format(amount);
  }
}
