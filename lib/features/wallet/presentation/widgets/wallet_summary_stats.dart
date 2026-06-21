import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/core/utils/utils.dart';

class WalletSummaryStats extends StatelessWidget {
  final double totalWithdrawn;
  final double lastWithdrawnAmount;
  final String lastWithdrawnDate;

  const WalletSummaryStats({
    super.key,
    required this.totalWithdrawn,
    required this.lastWithdrawnAmount,
    required this.lastWithdrawnDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF7ED), // orange50
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(ImagePath.iconWalletNewSvg, width: 24, height: 24),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: PrimaryText('Tổng tiền đã rút', size: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                PrimaryText(Utils.formatCurrencyWithUnit(totalWithdrawn),
                    fontWeight: FontWeight.bold, size: 16),
                const PrimaryText('Tất cả thời gian', size: 12, color: AppColors.neutral4),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.neutral7),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF), // blue50
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(ImagePath.iconClockSvg, width: 24, height: 24),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: PrimaryText('Đã rút gần nhất', size: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                PrimaryText(Utils.formatCurrencyWithUnit(lastWithdrawnAmount),
                    fontWeight: FontWeight.bold, size: 16),
                PrimaryText(lastWithdrawnDate, size: 12, color: AppColors.neutral4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

