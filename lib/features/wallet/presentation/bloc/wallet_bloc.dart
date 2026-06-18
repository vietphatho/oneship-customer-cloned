import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

@lazySingleton
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  static const int _pinLength = 5;

  WalletBloc() : super(WalletState.initial()) {
    on<FetchWalletDataEvent>(_onFetchWalletData);
    on<WithdrawAmountChanged>(_onAmountChanged);
    on<WithdrawNextStep>(_onNextStep);
    on<WithdrawPinEntered>(_onPinEntered);
    on<WithdrawPinBackspace>(_onPinBackspace);
    on<WithdrawSubmit>(_onSubmit);
    on<WithdrawReset>(_onReset);
  }

  Future<void> _onFetchWalletData(
      FetchWalletDataEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Giả lập API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data
      emit(state.copyWith(
        isLoading: false,
        availableBalance: 2560000,
        totalWithdrawn: 5860000,
        lastWithdrawnAmount: 1200000,
        lastWithdrawnDate: '10/05/2024 - 15:30',
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onAmountChanged(WithdrawAmountChanged event, Emitter<WalletState> emit) {
    emit(state.copyWith(withdrawAmount: event.amount));
  }

  void _onNextStep(WithdrawNextStep event, Emitter<WalletState> emit) {
    if (state.withdrawStep < 3) {
      emit(state.copyWith(withdrawStep: state.withdrawStep + 1));
    }
  }

  void _onPinEntered(WithdrawPinEntered event, Emitter<WalletState> emit) {
    if (state.withdrawPin.length < _pinLength) {
      final newPin = state.withdrawPin + event.pin;
      emit(state.copyWith(withdrawPin: newPin));
      
      if (newPin.length == _pinLength) {
        add(WithdrawSubmit());
      }
    }
  }

  void _onPinBackspace(WithdrawPinBackspace event, Emitter<WalletState> emit) {
    if (state.withdrawPin.isNotEmpty) {
      emit(state.copyWith(withdrawPin: state.withdrawPin.substring(0, state.withdrawPin.length - 1)));
    }
  }

  Future<void> _onSubmit(WithdrawSubmit event, Emitter<WalletState> emit) async {
    emit(state.copyWith(isWithdrawSubmitting: true, error: null));
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(state.copyWith(isWithdrawSubmitting: false, isWithdrawSuccess: true));
  }

  void _onReset(WithdrawReset event, Emitter<WalletState> emit) {
    emit(state.copyWith(
      withdrawStep: 1,
      withdrawAmount: '',
      withdrawPin: '',
      isWithdrawSubmitting: false,
      isWithdrawSuccess: false,
      error: null,
    ));
  }
}
