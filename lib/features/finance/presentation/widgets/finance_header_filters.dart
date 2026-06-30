import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_avatar.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/core/utils/string_utils.dart';
import 'package:oneship_customer/di/injection_container.dart';
import 'package:oneship_customer/features/finance/enum.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

class FinanceHeaderFilters extends StatelessWidget {
  const FinanceHeaderFilters({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedFilter,
    required this.onShopTap,
    required this.onDateTap,
    required this.onFilterTap,
  });

  final DateTime startDate;
  final DateTime endDate;
  final FinanceFilter selectedFilter;
  final VoidCallback onShopTap;
  final VoidCallback onDateTap;
  final ValueChanged<FinanceFilter> onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _HeaderFilterCard(
                  onTap: onShopTap,
                  child: const _ShopFilterContent(),
                ),
              ),
              const SizedBox(width: AppDimensions.xSmallSpacing),
              Expanded(
                child: Column(
                  children: [
                    _HeaderFilterCard(
                      onTap: onDateTap,
                      height: 34,
                      child: Row(
                        children: [
                          const _HeaderSvgIcon(
                            asset: 'assets/icons/finance_calendar.svg',
                          ),
                          const SizedBox(width: AppDimensions.xSmallSpacing),
                          Expanded(
                            child: Text(
                              '${DateTimeUtils.formatDateFromDT(startDate)} - ${DateTimeUtils.formatDateFromDT(endDate)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyXXSmall,
                            ),
                          ),
                          const _HeaderSvgIcon(
                            asset: 'assets/icons/finance_chevron_down.svg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    _QuickFilterBar(
                      selectedFilter: selectedFilter,
                      onFilterTap: onFilterTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShopFilterContent extends StatelessWidget {
  const _ShopFilterContent();

  @override
  Widget build(BuildContext context) {
    final shopBloc = getIt.get<ShopBloc>();

    return BlocBuilder<ShopBloc, ShopState>(
      bloc: shopBloc,
      buildWhen: (previous, current) =>
          previous.currentShop != current.currentShop,
      builder: (context, state) {
        final shopName = state.currentShop?.shopName ?? 'your_shop'.tr();
        final shopLogo = state.currentShop?.shopLogo;
        final hasShopLogo = shopLogo?.isNotEmpty == true;

        return Row(
          children: [
            PrimaryAvatar(
              url: hasShopLogo ? StringUtils.getImgUrl(shopLogo) : null,
              showStatusIndicator: false,
            ),
            const SizedBox(width: AppDimensions.xSmallSpacing),
            Expanded(
              child: Text(
                shopName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickFilterBar extends StatelessWidget {
  const _QuickFilterBar({
    required this.selectedFilter,
    required this.onFilterTap,
  });

  final FinanceFilter selectedFilter;
  final ValueChanged<FinanceFilter> onFilterTap;

  @override
  Widget build(BuildContext context) {
    const filters = [
      FinanceFilter.oneDay,
      FinanceFilter.sevenDay,
      FinanceFilter.thirtyDay,
    ];

    return Container(
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: filters.map((filter) {
          final selected = selectedFilter == filter;
          return Expanded(
            child: InkWell(
              onTap: () => onFilterTap(filter),
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(38),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _filterLabel(filter),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.blue950,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _filterLabel(FinanceFilter filter) {
    return switch (filter) {
      FinanceFilter.oneDay => 'last_24_hours'.tr(),
      FinanceFilter.sevenDay => 'last_7_days'.tr(),
      FinanceFilter.thirtyDay => 'last_30_days'.tr(),
      FinanceFilter.selectDate => 'select_date'.tr(),
    };
  }
}

class _HeaderFilterCard extends StatelessWidget {
  const _HeaderFilterCard({
    required this.onTap,
    required this.child,
    this.height = 72,
  });

  final VoidCallback onTap;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.xSmallSpacing,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _HeaderSvgIcon extends StatelessWidget {
  const _HeaderSvgIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 18,
      height: 18,
      colorFilter: const ColorFilter.mode(AppColors.grey600, BlendMode.srcIn),
    );
  }
}
