import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_state.freezed.dart';

@freezed
abstract class WalletState with _$WalletState {
  const factory WalletState({
    // Wallet attributes
    @Default(true) bool isLoading,
    String? error,
    @Default(0.0) double availableBalance,
    @Default(0.0) double totalWithdrawn,
    @Default(0.0) double lastWithdrawnAmount,
    @Default('') String lastWithdrawnDate,

    // Withdraw attributes
    @Default(1) int withdrawStep,
    @Default('') String withdrawAmount,
    @Default('') String withdrawPin,
    @Default(false) bool isWithdrawSubmitting,
    @Default(false) bool isWithdrawSuccess,
  }) = _WalletState;

  factory WalletState.initial() => const WalletState();
}
