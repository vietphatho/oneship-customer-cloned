// // ignore_for_file: constant_identifier_names

// import 'package:geolocator/geolocator.dart';
// import 'package:oneship_mobile/core/base/base_import_components.dart';

// class OwnerType {
//   static const USER = 'user';
//   static const SHIPPER = 'shipper';
//   static const SHIPPER_CONSIGNMENT = 'shipper-consignment';
//   static const SHIPPER_COD = 'shipper-cod';
//   static const SHOP = 'shop';
// }

// class DocumentType {
//   static const PASSPORT = 'passport';
//   static const NATIONAL_ID = 'national_id';
//   static const DRIVING_LICENSE = 'driving_license';
//   static const VISA = 'visa';
//   static const OTHER = 'other';
// }

// class UserRelationship {
//   static const PARENT = 'parent';
//   static const BROTHER = 'brother';
//   static const SISTER = 'sister';
//   static const YOUNGER_SIBLING = 'younger_sibling';
//   static const SPOUSE = 'spouse';
//   static const CHILD = 'child';
//   static const FRIEND = 'friend';
//   static const OTHER = 'other';

//   static const Map<String, String> _relationshipNames = {
//     PARENT: "Bố/Mẹ",
//     BROTHER: "Anh ruột",
//     SISTER: "Chị ruột",
//     YOUNGER_SIBLING: "Em ruột",
//     SPOUSE: "Vợ/Chồng",
//     CHILD: "Con",
//     FRIEND: "Bạn bè",
//     OTHER: "Khác",
//   };

//   static Map<String, String> get relationshipNames => _relationshipNames;
// }

// class Gender {
//   static const MALE = 'male';
//   static const FEMALE = 'female';
//   static const OTHER = 'other';

//   static const Map<String, String> _mapType = {
//     MALE: "Nam",
//     FEMALE: "Nữ",
//     OTHER: "Khác",
//   };

//   static Map<String, String> get mapType => _mapType;
// }

// enum DeliveryReasonEnum { cancel, postpone }

// extension DeliveryReasonEnumExt on DeliveryReasonEnum {
//   static const mapName = {
//     DeliveryReasonEnum.cancel: "cancel",
//     DeliveryReasonEnum.postpone: "delayed",
//   };
//   String get reasonName => mapName[this]!;
// }

// // ====================== ORDER RELATED CONSTANTS ======================

// class PaymentStatus {
//   static const PENDING = 'pending';
//   static const PAID = 'paid';
//   static const FAILED = 'failed';
//   static const REFUNDED = 'refunded';
// }

// class PaymentMethod {
//   static const CASH = 'cash';
//   static const CARD = 'card';
//   static const BANK_TRANSFER = 'bank_transfer';
//   static const E_WALLET = 'e_wallet';
// }

// class PackageType {
//   static const ENVELOPE = 'envelope';
//   static const SMALL_BOX = 'small_box';
//   static const MEDIUM_BOX = 'medium_box';
//   static const LARGE_BOX = 'large_box';
//   static const EXTRA_LARGE = 'extra_large';
//   static const FRAGILE = 'fragile';
//   static const LIQUID = 'liquid';
//   static const DOCUMENT = 'document';
//   static const ELECTRONICS = 'electronics';
//   static const FOOD = 'food';
//   static const CLOTHING = 'clothing';
//   static const OTHER = 'other';
// }

// class Payer {
//   static const SENDER = 'sender';
//   static const RECEIVER = 'receiver';
// }

// class OrderSortField {
//   static const CREATED_AT = 'createdAt';
//   static const UPDATED_AT = 'updatedAt';
//   static const ORDER_NUMBER = 'orderNumber';
//   static const TOTAL_AMOUNT = 'totalAmount';
//   static const STATUS = 'status';
//   static const CUSTOMER_NAME = 'customerName';
//   static const DELIVERY_FEE = 'deliveryFee';
// }

// class SortOrder {
//   static const ASC = 'ASC';
//   static const DESC = 'DESC';
// }

// class OrderHistoryEventType {
//   static const STATUS_CHANGED = 'STATUS_CHANGED';
//   static const ADDRESS_CHANGED = 'ADDRESS_CHANGED';
//   static const UPDATED = 'UPDATED';
//   static const DELETED = 'DELETED';
//   static const OTHER = 'OTHER';
// }

// class OrderServiceCode {
//   static const HOA_TOC = 'HT';
//   static const GIAO_NHANH = 'GN';
// }

// class ActivePackageStatus {
//   static const IDLE = 'idle';
//   static const ASSIGNED = 'assigned';
//   static const PICKUP_PENDING = 'pickup_pending';
//   static const READY_TO_DELIVER = 'ready_to_deliver';
//   static const IN_TRANSIT = 'in_transit';
// }

// class UserStatus {
//   static const ACTIVE = 'active';
//   static const INACTIVE = 'inactive';
//   static const PENDING = 'pending';
// }

// /// [TrackingMode.idle] theo dõi vị trí tương đối ở chế độ chờ
// ///
// /// [TrackingMode.navigation] theo dõi vị trí chính xác nhất
// ///
// enum TrackingMode { idle, navigation }

// extension TrackingModeX on TrackingMode {
//   static final _mapAndroidLocationSettings = {
//     TrackingMode.navigation: AndroidSettings(
//       accuracy: LocationAccuracy.bestForNavigation,
//       intervalDuration: const Duration(seconds: 1),
//       // distanceFilter: 1,
//     ),
//     TrackingMode.idle: AndroidSettings(
//       accuracy: LocationAccuracy.medium,
//       intervalDuration: const Duration(seconds: 10),
//       distanceFilter: 10,
//     ),
//   };

//   static final _mapAppleLocationSettings = {
//     TrackingMode.navigation: AppleSettings(
//       accuracy: LocationAccuracy.bestForNavigation,
//       // distanceFilter: 1,
//       pauseLocationUpdatesAutomatically: false,
//       activityType: ActivityType.automotiveNavigation,
//       showBackgroundLocationIndicator: true,
//     ),
//     TrackingMode.idle: AppleSettings(
//       accuracy: LocationAccuracy.medium,
//       distanceFilter: 10,
//       pauseLocationUpdatesAutomatically: false,
//       activityType: ActivityType.automotiveNavigation,
//       showBackgroundLocationIndicator: true,
//     ),
//   };

//   static final _mapAndroidBackgroundLocationSettings = {
//     TrackingMode.navigation: AndroidSettings(
//       accuracy: LocationAccuracy.bestForNavigation,
//       intervalDuration: const Duration(seconds: 1),
//       // distanceFilter: 1,
//     ),
//     TrackingMode.idle: AndroidSettings(
//       accuracy: LocationAccuracy.medium,
//       intervalDuration: const Duration(seconds: 10),
//       distanceFilter: 10,
//     ),
//   };

//   static final _mapAppleBackgroundLocationSettings = {
//     TrackingMode.navigation: AppleSettings(
//       accuracy: LocationAccuracy.bestForNavigation,
//       // distanceFilter: 1,
//       pauseLocationUpdatesAutomatically: false,
//       activityType: ActivityType.automotiveNavigation,
//       showBackgroundLocationIndicator: true,
//     ),
//     TrackingMode.idle: AppleSettings(
//       accuracy: LocationAccuracy.medium,
//       distanceFilter: 10,
//       pauseLocationUpdatesAutomatically: false,
//       activityType: ActivityType.automotiveNavigation,
//       showBackgroundLocationIndicator: false,
//     ),
//   };

//   LocationSettings get androidLocationSettings =>
//       _mapAndroidLocationSettings[this]!;
//   LocationSettings get appleLocationSettings =>
//       _mapAppleLocationSettings[this]!;
//   LocationSettings get androidBackgroundLocationSettings =>
//       _mapAndroidBackgroundLocationSettings[this]!;
//   LocationSettings get appleBackgroundLocationSettings =>
//       _mapAppleBackgroundLocationSettings[this]!;
// }

// extension ThemeModeExt on ThemeMode {
//   static const _rawIconData = {
//     ThemeMode.system: Icons.brightness_auto,
//     ThemeMode.light: Icons.wb_sunny,
//     ThemeMode.dark: Icons.nights_stay,
//   };

//   IconData get icon => _rawIconData[this]!;
// }

// /// [NavigationType.delivery] luồng thông thường, đến shop lấy hàng và đi giao hàng
// ///
// /// [NavigationType.returnToHub] luồng đi trả hàng về kho
// ///
// enum NavigationType { delivery, returnToHub }
