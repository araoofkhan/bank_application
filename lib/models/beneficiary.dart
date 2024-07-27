import 'package:firebase_database/firebase_database.dart';

class Beneficiary {
  final String accountNumber;
  //final String accountTitle;
  final String bankLogo;
  final String bankName;
  //final String branchName;
  final String nickname;

  Beneficiary({
    required this.accountNumber,
    //required this.accountTitle,
    required this.bankLogo,
    required this.bankName,
   // required this.branchName,
    required this.nickname,
  });

  factory Beneficiary.fromJson(Map<dynamic, dynamic> json) {
    return Beneficiary(
      accountNumber: json['account_number'] ?? '',
   //  accountTitle: json['account_title'] ?? '',
      bankLogo: json['bank_logo'] ?? '',
      bankName: json['bank_name'] ?? '',
    //  branchName: json['branch_name'] ?? '',
      nickname: json['nickname'] ?? '',
    );
  }
}
