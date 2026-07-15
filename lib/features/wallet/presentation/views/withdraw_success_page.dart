import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/navigation/route_name.dart';
import 'package:go_router/go_router.dart';
import 'package:oneship_customer/features/auth/data/enum.dart';
import 'package:oneship_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:oneship_customer/features/shop_master/data/enum.dart';
import 'package:oneship_customer/features/shop_master/presentation/bloc/shop_master_bloc.dart';
import 'package:oneship_customer/features/vendor/master/data/vendor_navigation_item.dart';
import 'package:oneship_customer/features/vendor/master/presentation/bloc/vendor_master_bloc.dart';
import 'package:oneship_customer/di/injection_container.dart';

class WithdrawSuccessPage extends StatelessWidget {
  const WithdrawSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PrimaryAppBar(
        title: 'Số dư',
        titleColor: AppColors.secondary,
        leading: BackButton(
          onPressed: () {
            _goToMaster(context, shopTab: BottomNavigationItem.home);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Success Icon
            Container(
              margin: const EdgeInsets.only(top: 16),
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),

            const PrimaryText(
              'Rút tiền thành công!',
              color: Colors.green,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
            const SizedBox(height: 8),
            const PrimaryText(
              'Bạn đã rút thành công',
              color: AppColors.neutral3,
            ),
            const SizedBox(height: 12),
            const PrimaryText(
              '1.000.000đ',
              fontWeight: FontWeight.bold,
              size: 32,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 32),

            // Details Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailRow('Số tiền rút', '1.000.000đ'),
                  const SizedBox(height: 12),
                  _buildDetailRow('Phí giao dịch', 'Miễn phí'),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.neutral7),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'Số tiền nhận',
                    '1.000.000đ',
                    valueColor: AppColors.primary,
                    valueFontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 24),

                  // Bank Account
                  const PrimaryText(
                    'Tài khoản nhận tiền',
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.account_balance,
                            color: AppColors.info,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrimaryText(
                                'Vietcombank',
                                fontWeight: FontWeight.bold,
                                size: 14,
                              ),
                              PrimaryText(
                                '1234 5678 9012 3456',
                                size: 12,
                                color: AppColors.neutral3,
                              ),
                              PrimaryText(
                                'NGUYỄN VĂN AN',
                                size: 12,
                                color: AppColors.neutral3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildDetailRow('Thời gian', '11/05/2024 - 10:15:30'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            PrimaryButton.filled(
              label: 'Đóng',
              onPressed: () {
                _goToMaster(context, shopTab: BottomNavigationItem.wallet);
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const PrimaryText(
                'Xem lịch sử giao dịch',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _goToMaster(
    BuildContext context, {
    required BottomNavigationItem shopTab,
  }) {
    final userRole = getIt<AuthBloc>().userProfile.userRole;

    if (userRole == UserRole.vendor.value) {
      final vendorTab = shopTab == BottomNavigationItem.home
          ? VendorNavigationItem.home
          : VendorNavigationItem.finance;
      getIt<VendorMasterBloc>().changeTab(vendorTab);
      context.go(RouteName.vendorMasterPage);
      return;
    }

    getIt<ShopMasterBloc>().changeTab(shopTab);
    context.go(RouteName.shopMasterPage);
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color valueColor = AppColors.secondary,
    FontWeight valueFontWeight = FontWeight.normal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrimaryText(label, color: AppColors.neutral3, size: 14),
        PrimaryText(
          value,
          color: valueColor,
          fontWeight: valueFontWeight,
          size: 14,
        ),
      ],
    );
  }
}
