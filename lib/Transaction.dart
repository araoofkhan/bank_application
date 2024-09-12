class Transaction {
  final String transactionId;
  String beneficiaryaccountNumber;
  final String bankName;
  final String beneficiaryName;
  final double amount;
  final String date;

  // Constructor
  Transaction({
    required this.transactionId,

    required this.bankName,
    required this.beneficiaryName,
    required this.amount,
    required this.date, required  this.beneficiaryaccountNumber,
  });

  // Factory constructor
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'],
      beneficiaryaccountNumber: json['beneficiaryaccountNumber'],
      bankName: json['bankName'],
      beneficiaryName: json['beneficiaryName'],
      amount: json['amount'],
      date: json['date'],
    );
  }

  // Convert to map
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'beneficiaryaccountNumber': beneficiaryaccountNumber,
      'bankName': bankName,
      'beneficiaryName': beneficiaryName,
      'amount': amount,
      'date': date,
    };
  }
}
