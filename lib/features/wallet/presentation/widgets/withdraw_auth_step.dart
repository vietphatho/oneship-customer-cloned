import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawAuthStep extends StatelessWidget {
  WithdrawAuthStep({super.key});

  final _walletBloc = getIt<WalletBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PrimaryText(
            'Xác thực giao dịch',
            fontWeight: FontWeight.bold,
            size: 20,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const PrimaryText(
            'Nhập mã PIN để xác nhận rút tiền',
            color: AppColors.neutral3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // PIN Dots
          BlocBuilder<WalletBloc, WalletState>(
            bloc: _walletBloc,
            buildWhen: (previous, current) => previous.withdrawPin != current.withdrawPin,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: index < state.withdrawPin.length ? AppColors.secondary : AppColors.neutral7,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),
          
          TextButton(
            onPressed: () {},
            child: const PrimaryText('Quên mã PIN?', color: AppColors.primary),
          ),
          
          const SizedBox(height: 16),
          
          // Number Pad
          _buildNumberPad(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 64), // Spacer
            _buildNumberButton('0'),
            SizedBox(
              width: 64,
              height: 64,
              child: IconButton(
                onPressed: () => _walletBloc.add(WithdrawPinBackspace()),
                icon: const Icon(Icons.backspace_outlined, size: 28, color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextButton(
        onPressed: () => _walletBloc.add(WithdrawPinEntered(number)),
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          foregroundColor: AppColors.secondary,
        ),
        child: PrimaryText(
          number,
          size: 28,
          fontWeight: FontWeight.normal,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
