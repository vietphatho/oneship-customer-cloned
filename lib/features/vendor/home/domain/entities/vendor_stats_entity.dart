import 'package:oneship_customer/features/vendor/home/data/models/response/vendor_stats_response.dart';
import 'package:oneship_customer/features/vendor/finance/domain/entities/finance_entity.dart';

class VendorStats {
  const VendorStats({
    required this.orderCount,
    required this.totalDeliveryFeeAmount,
    required this.totalCodAmount,
    required this.deliveredCount,
    required this.returnedCount,
    required this.successRate,
    required this.dailyStats,
  });

  final int orderCount;
  final double totalDeliveryFeeAmount;
  final double totalCodAmount;
  final int deliveredCount;
  final int returnedCount;
  final double successRate;
  final List<DailyVendorStat> dailyStats;

  factory VendorStats.fromDto(VendorStatsResponse dto) {
    return VendorStats(
      orderCount: dto.orderCount ?? 0,
      totalDeliveryFeeAmount: dto.totalDeliveryFeeAmount ?? 0,
      totalCodAmount: dto.totalCodAmount ?? 0,
      deliveredCount: dto.deliveredCount ?? 0,
      returnedCount: dto.returnedCount ?? 0,
      successRate: dto.successRate ?? 0,
      dailyStats: dto.dailyStats?.map(DailyVendorStat.fromDto).toList() ?? [],
    );
  }

  factory VendorStats.fromFinanceSummary(
    VendorFinanceEntity entity, {
    required DateTime date,
  }) {
    final deliveredCount = entity.orderCount ?? 0;
    final returnedCount = entity.returnedOrderCount ?? 0;
    final orderCount = deliveredCount + returnedCount;
    final successRate = orderCount == 0
        ? 0.0
        : (deliveredCount / orderCount) * 100;

    return VendorStats(
      orderCount: orderCount,
      totalDeliveryFeeAmount: (entity.deliveryFee ?? 0).toDouble(),
      totalCodAmount: (entity.codCollected ?? 0).toDouble(),
      deliveredCount: deliveredCount,
      returnedCount: returnedCount,
      successRate: successRate,
      dailyStats: [
        DailyVendorStat(
          statDate: date,
          orderCount: orderCount,
          totalDeliveryFeeAmount: (entity.deliveryFee ?? 0).toDouble(),
          totalCodAmount: (entity.codCollected ?? 0).toDouble(),
          deliveredCount: deliveredCount,
          returnedCount: returnedCount,
          successRate: successRate,
        ),
      ],
    );
  }

  bool get isEmpty =>
      orderCount == 0 &&
      totalDeliveryFeeAmount == 0 &&
      totalCodAmount == 0 &&
      deliveredCount == 0 &&
      returnedCount == 0 &&
      successRate == 0 &&
      dailyStats.isEmpty;
}

class DailyVendorStat {
  const DailyVendorStat({
    required this.statDate,
    required this.orderCount,
    required this.totalDeliveryFeeAmount,
    required this.totalCodAmount,
    required this.deliveredCount,
    required this.returnedCount,
    required this.successRate,
  });

  final DateTime statDate;
  final int orderCount;
  final double totalDeliveryFeeAmount;
  final double totalCodAmount;
  final int deliveredCount;
  final int returnedCount;
  final double successRate;

  factory DailyVendorStat.fromDto(DailyVendorStatResponse dto) {
    return DailyVendorStat(
      statDate: dto.statDate ?? DateTime.fromMillisecondsSinceEpoch(0),
      orderCount: dto.orderCount ?? 0,
      totalDeliveryFeeAmount: dto.totalDeliveryFeeAmount ?? 0,
      totalCodAmount: dto.totalCodAmount ?? 0,
      deliveredCount: dto.deliveredCount ?? 0,
      returnedCount: dto.returnedCount ?? 0,
      successRate: dto.successRate ?? 0,
    );
  }
}
