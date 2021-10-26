class ContractState {
  ContractState(this.balance, this.lastDeposit, this.lastWithdraw);

  int balance;
  int lastDeposit;
  int lastWithdraw;

  @override
  String toString() {
    return ''' Contract state 
  balance: $balance, 
  last deposit: $lastDeposit, 
  last withdraw: $lastWithdraw''';
  }
}
