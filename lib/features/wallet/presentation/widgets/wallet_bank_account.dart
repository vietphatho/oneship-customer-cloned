import 'package:oneship_customer/core/base/base_import_components.dart';

class WalletBankAccount extends StatelessWidget {
  const WalletBankAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  color: const Color(0xFFEFF6FF), // blue50
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
      ],
    );
  }
}

