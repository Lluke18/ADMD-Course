
class BankAccount{
  late final String accountNumber;
  final String holderName;
  double balance = 0.0;
  final String? bankBranch;
  bool isInit = false;  

  BankAccount({required this.holderName, this.balance = 0.0, this.bankBranch });

  void initializeAccount(String number){
    accountNumber = number;
    isInit = true;
  }
  
  bool checkInit(){
    return isInit;
  }

}