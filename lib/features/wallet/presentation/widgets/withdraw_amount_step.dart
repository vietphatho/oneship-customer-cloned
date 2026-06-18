import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawAmountStep extends StatefulWidget {
  const WithdrawAmountStep({super.key});

  @override
  State<WithdrawAmountStep> createState() => _WithdrawAmountStepState();
}

class _WithdrawAmountStepState extends State<WithdrawAmountStep> {
  final _amountController = TextEditingController();
  final _walletBloc = getIt<WalletBloc>();

  @override
  void initState() {
    super.initState();
    _amountController.text = _walletBloc.state.withdrawAmount;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountSelected(String amount) {
    _amountController.text = amount;
    _walletBloc.add(WithdrawAmountChanged(amount));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PrimaryText('Nhập số tiền muốn rút', fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          // Input field
          PrimaryTextField(
            controller: _amountController,
            hintText: 'Nhập số tiền',
            keyboardType: TextInputType.number,
            onChanged: (val) => _walletBloc.add(WithdrawAmountChanged(val)),
            suffixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: PrimaryText('đ', size: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          
          // Quick select amounts
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickAmount('100.000đ'),
              _buildQuickAmount('200.000đ'),
              _buildQuickAmount('500.000đ'),
              _buildQuickAmount('1.000.000đ'),
            ],
          ),
          const SizedBox(height: 16),
          
          // Available balance
          RichText(
            text: const TextSpan(
              text: 'Số dư khả dụng: ',
              style: TextStyle(color: AppColors.neutral3, fontSize: 14),
              children: [
                TextSpan(
                  text: '2.560.000đ',
                  style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Continue button
          BlocBuilder<WalletBloc, WalletState>(
            bloc: _walletBloc,
            buildWhen: (previous, current) => previous.withdrawAmount != current.withdrawAmount,
            builder: (context, state) {
              return PrimaryButton.filled(
                label: 'Tiếp tục',
                onPressed: state.withdrawAmount.isNotEmpty
                    ? () => _walletBloc.add(WithdrawNextStep())
                    : null,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuickAmount(String amount) {
    return InkWell(
      onTap: () => _onAmountSelected(amount.replaceAll('đ', '').replaceAll('.', '')),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.neutral6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: PrimaryText(amount),
      ),
    );
  }
}
