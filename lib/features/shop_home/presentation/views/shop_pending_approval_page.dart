import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/constants/image_path.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class ShopPendingApprovalPage extends StatelessWidget {
  const ShopPendingApprovalPage({super.key});

  static const String _hotline = Constants.tpSwitchBoard;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.getSize(context);
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen: (previous, current) =>
          previous.createShopResource != current.createShopResource,
      builder: (context, state) {
        final shopName = state.createShopResource.data?.shopName ?? '';

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.mediumSpacing,
                AppDimensions.xxxLargeSpacing,
                AppDimensions.mediumSpacing,
                AppDimensions.xxxLargeSpacing,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      size.height -
                      MediaQuery.of(context).padding.vertical -
                      AppDimensions.xxxLargeSpacing * 2,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(ImagePath.logo, width: size.width * 0.48),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        PrimaryText(
                          shopName.isEmpty ? 'Tên shop' : shopName,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        PrimaryText(
                          'đang chờ phê duyệt',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            height: 1.25,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xLargeSpacing),
                        PrimaryText(
                          'Cửa hàng của bạn đang được đội ngũ OneShip xem xét. Quá trình thường mất 1-2 ngày làm việc. Nếu cần hỗ trợ ngay, hãy liên hệ trực tiếp với chúng tôi.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            height: 1.35,
                            color: Colors.black,
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        SizedBox(
                          width: size.width * 0.66,
                          height: size.width * 0.42,
                          child: Image.asset(
                            ImagePath.shopPendingApproval,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (_, __, ___) => const Icon(
                                  Icons.local_shipping_outlined,
                                  size: 120,
                                  color: AppColors.primary,
                                ),
                          ),
                        ),
                        AppSpacing.vertical(AppDimensions.xxxLargeSpacing),
                        _SupportCard(
                          hotline: _hotline,
                          onCopy: () {
                            Clipboard.setData(const ClipboardData(text: _hotline));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Đã sao chép hotline OneShip'),
                              ),
                            );
                          },
                        ),
                        AppSpacing.vertical(AppDimensions.largeSpacing),
                        PrimaryText(
                          'Thứ Hai - Thứ Sáu : 8:00 - 17:30',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.hotline, required this.onCopy});

  final String hotline;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.largeSpacing,
        vertical: AppDimensions.mediumSpacing,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.smallBorderRadius,
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        children: [
          PrimaryText(
            'Liên hệ hỗ trợ',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.vertical(AppDimensions.mediumSpacing),
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.phone, color: Colors.white, size: 22),
              ),
              AppSpacing.horizontal(AppDimensions.smallSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryText(
                      'Hotline OneShip',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    PrimaryText(
                      hotline,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: onCopy,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.smallBorderRadius,
                  ),
                ),
                icon: const Icon(Icons.copy, size: 18),
                label: PrimaryText(
                  'Sao chép',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
