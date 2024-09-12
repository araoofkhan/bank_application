import 'package:firebase_database/firebase_database.dart';
import 'package:bank_application/Transaction.dart' as app_transaction;

class TransactionService {
  final DatabaseReference _transactionsRef = FirebaseDatabase.instance.ref().child('TransactionHistory');

  Future<void> saveTransaction(String beneficiaryaccountnumber, app_transaction.Transaction transaction) async {
    try {
      final accountRef = _transactionsRef.child(beneficiaryaccountnumber);
      final transactionRef = accountRef.child(transaction.transactionId);

      // Save transaction to Firebase
      await transactionRef.set(transaction.toJson());

      // Verify data was written successfully
      final DatabaseEvent event = await transactionRef.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        print('Transaction saved and verified successfully.');
      } else {
        print('Transaction saved but verification failed.');
      }
    } catch (e) {
      print('Failed to save transaction: $e');
    }
  }
}
