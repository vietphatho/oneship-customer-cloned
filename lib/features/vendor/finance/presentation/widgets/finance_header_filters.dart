import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_card.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/vendor/finance/enum.dart';

class VendorFinanceHeaderFilters extends StatelessWidget {
  const VendorFinanceHeaderFilters({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedFilter,
    required this.onDateFilterTap,
  });

  final DateTime startDate;
  final DateTime endDate;
  final VendorFinanceFilter selectedFilter;
  final VoidCallback onDateFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.mediumSpacing,
        AppDimensions.xSmallSpacing,
        AppDimensions.mediumSpacing,
        AppDimensions.xSmallSpacing,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _DateFilterButton(
            startDate: startDate,
            endDate: endDate,
            selectedFilter: selectedFilter,
            onTap: onDateFilterTap,
          );
        },
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.startDate,
    required this.endDate,
    required this.selectedFilter,
    required this.onTap,
  });

  final DateTime startDate;
  final DateTime endDate;
  final VendorFinanceFilter selectedFilter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${DateTimeUtils.formatDateFromDT(startDate)} - ${DateTimeUtils.formatDateFromDT(endDate)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.mediumRadius),
      child: PrimaryCard(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _HeaderSvgIcon(
                  asset: 'assets/icons/finance_calendar.svg',
                ),
                const SizedBox(width: AppDimensions.xSmallSpacing),
                Flexible(
                  child: PrimaryText(
                    _filterLabel(selectedFilter),
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelXSmall,
                    color: AppColors.blue950,
                  ),
                ),
              ],
            ),
            const Spacer(),
            PrimaryText(
              dateRange,
              maxLine: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.bodyXXSmall,
              color: AppColors.grey500,
            ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(VendorFinanceFilter filter) {
    return switch (filter) {
      VendorFinanceFilter.oneDay => 'last_24_hours'.tr(),
      VendorFinanceFilter.sevenDay => 'last_7_days'.tr(),
      VendorFinanceFilter.thirtyDay => 'last_30_days'.tr(),
      VendorFinanceFilter.selectDate => 'select_date'.tr(),
    };
  }
}

class _HeaderSvgIcon extends StatelessWidget {
  const _HeaderSvgIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: AppDimensions.smallIconSize,
      height: AppDimensions.smallIconSize,
      colorFilter: const ColorFilter.mode(AppColors.grey500, BlendMode.srcIn),
    );
  }
}
