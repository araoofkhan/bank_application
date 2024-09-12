import 'package:firebase_database/firebase_database.dart';

class Beneficiary {
  final String accountNumber;
  final String bankLogo;
  final String bankName;
  final String nickname;
  final bool favorite;

  Beneficiary({
    required this.accountNumber,
    required this.bankLogo,
    required this.bankName,
    required this.nickname,
    this.favorite = false,
  });

  factory Beneficiary.fromJson(Map<dynamic, dynamic> json) {
    return Beneficiary(
      accountNumber: json['account_number'] ?? '',
      bankLogo: json['bank_logo'] ?? '',
      bankName: json['bank_name'] ?? '',
      nickname: json['nickname'] ?? '',
      favorite: json['favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_logo': bankLogo,
      'bank_name': bankName,
      'nickname': nickname,
      'favorite': favorite,


    };
  }
}
