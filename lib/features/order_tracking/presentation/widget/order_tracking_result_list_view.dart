// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oneship_customer/core/base/base_import_components.dart';
// import 'package:oneship_customer/di/injection_container.dart';
// import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
// import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_bloc.dart';
// import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

// class OrderTrackingResultListView extends StatelessWidget {
//   const OrderTrackingResultListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final OrderTrackingBloc _orderTrackingBloc = getIt.get();

//     return BlocBuilder<OrderTrackingBloc, OrderTrackingState>(
//       bloc: _orderTrackingBloc,
//       builder: (context, state) {
//         final data = state.trackingResult.data;

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columns: const [
//               DataColumn(label: PrimaryText('Mã bưu gửi')),
//               DataColumn(label: PrimaryText('Trạng thái')),
//               DataColumn(label: PrimaryText('Ngày gửi')),
//               DataColumn(label: PrimaryText('Trọng lượng')),
//             ],
//             rows: data != null ? [_buildRowItem(data)] : [],
//           ),
//         );
//       },
//     );
//   }

//   DataRow _buildRowItem(OrderTrackingEntity order) {
//     return DataRow(
//       cells: [
//         DataCell(PrimaryText(order.trackingCode)),
//         DataCell(PrimaryText('')),
//         DataCell(PrimaryText('')),
//         DataCell(PrimaryText(order.weight.toString())),
//       ],
//     );
//   }
// }

// // class _OrderInfoItem extends StatelessWidget {
// //   const _OrderInfoItem({super.key, required this.order});

// //   final OrderTrackingEntity order;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(children: [PrimaryText("order_code")]);
// //   }
// // }
