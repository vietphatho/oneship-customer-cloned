import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';

enum ShopStatusEnum {
  active,
  pending,
  inactive;

  Color get bgColor {
    switch (this) {
      case ShopStatusEnum.active:
        return const Color(0xFFE8F5E9);
      case ShopStatusEnum.pending:
        return const Color(0xFFFFF3E0);
      case ShopStatusEnum.inactive:
        return const Color(0xFFEEEEEE);
    }
  }

  Color get textColor {
    switch (this) {
      case ShopStatusEnum.active:
        return const Color(0xFF2E7D32);
      case ShopStatusEnum.pending:
        return const Color(0xFFE65100);
      case ShopStatusEnum.inactive:
        return AppColors.neutral4;
    }
  }

  String get label {
    switch (this) {
      case ShopStatusEnum.active:
        return 'shop_management.status_active'.tr();
      case ShopStatusEnum.pending:
        return 'shop_management.status_pending'.tr();
      case ShopStatusEnum.inactive:
        return 'shop_management.status_inactive'.tr();
    }
  }

  static ShopStatusEnum fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return ShopStatusEnum.active;
      case 'pending':
        return ShopStatusEnum.pending;
      default:
        return ShopStatusEnum.inactive;
    }
  }
}

class ShopStatusBadge extends StatelessWidget {
  final ShopStatus status;

  const ShopStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final statusEnum = ShopStatusEnum.fromString(status.rawValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: statusEnum.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: PrimaryText(
        statusEnum.label,
        style: AppTextStyles.labelXSmall,
        color: statusEnum.textColor,
      ),
    );
  }
}
