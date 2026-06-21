abstract class WalletEvent {}

class FetchWalletDataEvent extends WalletEvent {}

class WithdrawAmountChanged extends WalletEvent {
  final String amount;
  WithdrawAmountChanged(this.amount);
}

class WithdrawNextStep extends WalletEvent {}

class WithdrawPinEntered extends WalletEvent {
  final String pin;
  WithdrawPinEntered(this.pin);
}

class WithdrawPinBackspace extends WalletEvent {}

class WithdrawSubmit extends WalletEvent {}

class WithdrawReset extends WalletEvent {}
