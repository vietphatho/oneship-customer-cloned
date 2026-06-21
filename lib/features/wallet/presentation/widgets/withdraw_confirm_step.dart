import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawConfirmStep extends StatelessWidget {
  WithdrawConfirmStep({super.key});

  final _walletBloc = getIt<WalletBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PrimaryText('Thông tin rút tiền', fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          
          // Summary Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral7),
            ),
            child: BlocBuilder<WalletBloc, WalletState>(
              bloc: _walletBloc,
              buildWhen: (previous, current) => previous.withdrawAmount != current.withdrawAmount,
              builder: (context, state) {
                final amountDisplay = state.withdrawAmount.isEmpty ? '0đ' : '${state.withdrawAmount}đ';
                return Column(
                  children: [
                    _buildInfoRow('Số tiền rút', amountDisplay),
                    const SizedBox(height: 12),
                    _buildInfoRow('Phí giao dịch', 'Miễn phí'),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: AppColors.neutral7),
                    const SizedBox(height: 12),
                    _buildInfoRow('Số tiền nhận', amountDisplay, valueColor: AppColors.primary, valueFontWeight: FontWeight.bold),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          
          // Bank Account
          const PrimaryText('Tài khoản nhận tiền', fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral7),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.account_balance, color: AppColors.info),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText('Vietcombank', fontWeight: FontWeight.bold),
                      PrimaryText('1234 5678 9012 3456', size: 12, color: AppColors.neutral3),
                      PrimaryText('NGUYỄN VĂN AN', size: 12, color: AppColors.neutral3),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const PrimaryText(
                        'Thay đổi',
                        color: AppColors.neutral3,
                        size: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Confirm Button
          PrimaryButton.filled(
            label: 'Xác nhận rút tiền',
            onPressed: () => _walletBloc.add(WithdrawNextStep()),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color valueColor = AppColors.secondary, FontWeight valueFontWeight = FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(label, color: AppColors.neutral3, size: 14),
        PrimaryText(value, color: valueColor, fontWeight: valueFontWeight, size: 14),
      ],
    );
  }
}
