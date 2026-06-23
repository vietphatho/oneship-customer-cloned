import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/components/primary_animated_pressable_widget.dart';
import 'package:oneship_customer/core/utils/date_time_utils.dart';
import 'package:oneship_customer/features/finance/domain/entities/settlement_periods_entity.dart';
import 'package:oneship_customer/features/finance/enum.dart';

class FinancePeriodCard extends StatelessWidget {
  const FinancePeriodCard({
    super.key,
    required this.periodEntity,
    required this.onTap,
  });

  final PeriodEntity periodEntity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        periodEntity.periodStatus.getStatusColor() ?? AppColors.primary;
    return PrimaryAnimatedPressableWidget(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    periodEntity.periodCode ?? '--',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusText(periodEntity.status),
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateTimeUtils.formatterString(periodEntity.startedAt)} - ${DateTimeUtils.formatterString(periodEntity.endedAt)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              _periodTypeText(periodEntity.periodType),
              style: const TextStyle(fontSize: 12, color: AppColors.grey600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 17,
                  color: AppColors.grey600,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    _endText(periodEntity.endedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onTap,
                  child: Text('view_details'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _PeriodTimeline(period: periodEntity),
          ],
        ),
      ),
    );
  }

  String _statusText(String? status) {
    return switch (status?.toLowerCase()) {
      'open' => 'status_open'.tr(),
      'locked' => 'status_locked'.tr(),
      'approved' => 'status_approved'.tr(),
      'cancelled' => 'status_cancelled'.tr(),
      null || '' => '--',
      _ => status!,
    };
  }

  String _periodTypeText(String? type) {
    return switch (type?.toLowerCase()) {
      'daily' => 'by_day'.tr(),
      'weekly' => 'by_week'.tr(),
      'monthly' => 'by_month'.tr(),
      null || '' => '--',
      _ => type!,
    };
  }

  String _endText(String? rawDate) {
    final endDate = DateTime.tryParse(rawDate ?? '');
    if (endDate == null) return 'no_end_date'.tr();
    final days = endDate.difference(DateTime.now()).inDays;
    if (days < 0) return 'ended'.tr();
    if (days == 0) return 'ends_today'.tr();
    return 'ends_in_days'.tr(namedArgs: {'count': '$days'});
  }
}

class _PeriodTimeline extends StatelessWidget {
  const _PeriodTimeline({required this.period});

  final PeriodEntity period;

  @override
  Widget build(BuildContext context) {
    final currentStep = switch (period.periodStatus) {
      PeriodStatus.open => 1,
      PeriodStatus.approved => 2,
      PeriodStatus.locked => 3,
      PeriodStatus.cancelled || PeriodStatus.all => 1,
    };
    final steps = [
      'timeline_ongoing'.tr(),
      'timeline_approved'.tr(),
      'timeline_locked'.tr(),
      'timeline_paid'.tr(),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 520,
        child: Row(
          children: List.generate(steps.length, (index) {
            final step = index + 1;
            final active = step <= currentStep;
            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      if (index > 0)
                        Expanded(
                          child: Container(
                            height: 1,
                            color:
                                active ? AppColors.primary : AppColors.grey200,
                          ),
                        ),
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              active ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                active ? AppColors.primary : AppColors.grey300,
                          ),
                        ),
                        child: Text(
                          '$step',
                          style: TextStyle(
                            fontSize: 11,
                            color: active ? Colors.white : AppColors.grey500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (index < steps.length - 1)
                        Expanded(
                          child: Container(
                            height: 1,
                            color:
                                step < currentStep
                                    ? AppColors.primary
                                    : AppColors.grey200,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _stepDate(index),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  String _stepDate(int index) {
    return switch (index) {
      0 =>
        '${DateTimeUtils.formatterString(period.startedAt)} - ${DateTimeUtils.formatterString(period.endedAt)}',
      1 => DateTimeUtils.formatterString(period.approvedAt),
      2 => DateTimeUtils.formatterString(period.lockedAt),
      _ => '--',
    };
  }
}
