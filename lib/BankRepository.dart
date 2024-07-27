
import 'package:bank_application/models/BankModel.dart';
import 'package:bank_application/models/Beneficiary.dart';

class BankRepository {
  // Static list of banks
  static final List<BankModel> banks = [
   BankModel(bankLogo: 'lib/resources/banklogo/meezan.png', bankName: 'Meezan Bank'),
    BankModel(bankLogo: 'lib/resources/banklogo/apna.png', bankName: 'APNA Microfinance'),
    BankModel(bankLogo: 'lib/resources/banklogo/albarka.png', bankName: 'Al Barka Bank'),
    BankModel(bankLogo: 'lib/resources/banklogo/allied.png', bankName:  'Allied Bank'),
    BankModel(bankLogo: 'lib/resources/banklogo/askari.png', bankName: 'Askari Bank'),
    BankModel(bankLogo: 'lib/resources/banklogo/bop.png', bankName: 'Bank of Punjab'),
    BankModel(bankLogo: 'lib/resources/banklogo/bok.png', bankName: 'Bank of Khyber'),
    BankModel(bankLogo: 'lib/resources/banklogo/bankislami.png', bankName: 'Bank Islami'),


    // Add more banks as needed
  ];

  // Method to get the list of banks
  List<BankModel> getBanks() {
    return banks;
  }
}
