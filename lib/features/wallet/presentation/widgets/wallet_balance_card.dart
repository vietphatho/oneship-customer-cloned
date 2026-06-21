import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneship_customer/core/utils/utils.dart';
import 'package:oneship_customer/features/wallet/presentation/widgets/withdraw_bottom_sheet.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:oneship_customer/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:oneship_customer/di/injection_container.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEA580C), Color(0xFFF97316)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PrimaryText(
                  'Tổng số dư khả dụng',
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(height: 8),
                PrimaryText(
                  Utils.formatCurrencyWithUnit(balance),
                  color: Colors.white,
                  size: 32,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    getIt<WalletBloc>().add(WithdrawReset());
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const WithdrawBottomSheet(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    ImagePath.walletWithdrawIcon,
                    width: 20,
                    height: 20,
                  ),
                  label: const PrimaryText(
                    'Rút tiền',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            ImagePath.walletBalanceIcon,
            width: 170,
            height: 170,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
