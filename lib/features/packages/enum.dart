import 'package:oneship_customer/core/base/base_import_components.dart';

enum PackageStatus {
  all,
  assigned,
  pickedUp,
  arrivedAtShop,
  removeOrdersPending,
  confirmedQuantity,
  confirmedPickup,
  inTransit,
  completed,
  dropped,
  merged,
  unknown,
}

extension PackageStatusX on PackageStatus {
  static const _mapName = {
    PackageStatus.all: 'all',
    PackageStatus.assigned: 'assigned',
    PackageStatus.pickedUp: 'picked_up',
    PackageStatus.arrivedAtShop: 'arrived_at_shop',
    PackageStatus.removeOrdersPending: 'remove_orders_pending',
    PackageStatus.confirmedQuantity: 'confirmed_quantity',
    PackageStatus.confirmedPickup: 'confirmed_pickup',
    PackageStatus.inTransit: 'in_transit',
    PackageStatus.completed: 'completed',
    PackageStatus.dropped: 'dropped',
    PackageStatus.merged: 'merged',
    PackageStatus.unknown: 'unknown',
  };

  String get name => _mapName[this]!;

  static const _mapColor = {
    PackageStatus.all: AppColors.secondary,
    PackageStatus.assigned: AppColors.secondary,
    PackageStatus.pickedUp: AppColors.secondary,
    PackageStatus.arrivedAtShop: AppColors.secondary,
    PackageStatus.removeOrdersPending: AppColors.secondary,
    PackageStatus.confirmedQuantity: AppColors.secondary,
    PackageStatus.confirmedPickup: AppColors.secondary,
    PackageStatus.inTransit: AppColors.secondary,
    PackageStatus.completed: AppColors.success,
    PackageStatus.dropped: AppColors.red500,
    PackageStatus.merged: AppColors.secondary,
    PackageStatus.unknown: AppColors.neutral5,
  };

  Color get color => _mapColor[this]!;
}
