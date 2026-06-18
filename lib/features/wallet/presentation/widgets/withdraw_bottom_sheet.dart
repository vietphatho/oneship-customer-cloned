import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'withdraw_amount_step.dart';
import 'withdraw_confirm_step.dart';
import 'withdraw_auth_step.dart';

class WithdrawBottomSheet extends StatelessWidget {
  const WithdrawBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final walletBloc = getIt<WalletBloc>();

    return BlocListener<WalletBloc, WalletState>(
      bloc: walletBloc,
      listenWhen: (previous, current) => previous.isWithdrawSuccess != current.isWithdrawSuccess,
      listener: (context, state) {
        if (state.isWithdrawSuccess) {
          context.pop();
          context.push(RouteName.withdrawSuccessPage);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.neutral9,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle and header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.neutral6,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24), // Balance the row
                        const PrimaryText(
                          'Rút tiền',
                          size: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                        InkWell(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.close, color: AppColors.neutral3, size: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Stepper
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: Colors.white,
                child: BlocBuilder<WalletBloc, WalletState>(
                  bloc: walletBloc,
                  buildWhen: (previous, current) => previous.withdrawStep != current.withdrawStep,
                  builder: (context, state) {
                    final currentStep = state.withdrawStep;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStep('1', 'Nhập số tiền', isActive: currentStep == 1, isCompleted: currentStep > 1),
                        Expanded(child: Container(height: 1, margin: const EdgeInsets.only(top: 12, left: 8, right: 8), color: currentStep > 1 ? const Color(0xFF22C55E) : AppColors.neutral6)),
                        _buildStep('2', 'Xác nhận', isActive: currentStep == 2, isCompleted: currentStep > 2),
                        Expanded(child: Container(height: 1, margin: const EdgeInsets.only(top: 12, left: 8, right: 8), color: currentStep > 2 ? const Color(0xFF22C55E) : AppColors.neutral6)),
                        _buildStep('3', 'Hoàn tất', isActive: currentStep == 3, isCompleted: false),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Content
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: SingleChildScrollView(
                    child: BlocBuilder<WalletBloc, WalletState>(
                      bloc: walletBloc,
                      buildWhen: (previous, current) => previous.withdrawStep != current.withdrawStep,
                      builder: (context, state) {
                        switch (state.withdrawStep) {
                          case 1:
                            return const WithdrawAmountStep();
                          case 2:
                            return WithdrawConfirmStep();
                          case 3:
                            return WithdrawAuthStep();
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, {bool isActive = false, bool isCompleted = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF22C55E) : (isActive ? AppColors.primary : AppColors.neutral7),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : PrimaryText(
                  number,
                  color: isActive ? Colors.white : AppColors.neutral4,
                  size: 12,
                  fontWeight: FontWeight.bold,
                ),
        ),
        const SizedBox(height: 8),
        PrimaryText(
          title,
          size: 12,
          color: isCompleted ? const Color(0xFF22C55E) : (isActive ? AppColors.primary : AppColors.neutral4),
          fontWeight: isActive || isCompleted ? FontWeight.bold : FontWeight.normal,
        ),
      ],
    );
  }
}
