import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/entities/order_tracking_entity.dart';
import 'package:oneship_customer/features/order_tracking/domain/use_cases/tracking_order_use_case.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_event.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

@lazySingleton
class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  OrderTrackingBloc(this._trackingOrderUseCase)
    : super(OrderTrackingState(trackingResult: Resource.loading())) {
    on<OrderTrackingSearchEvent>(_onSearchEvent);
    on<OrderTrackingResetDataEvent>(_onResetDataEvent);
  }

  final TrackingOrderUseCase _trackingOrderUseCase;

  FutureOr<void> _onSearchEvent(
    OrderTrackingSearchEvent event,
    Emitter<OrderTrackingState> emit,
  ) async {
    emit(
      state.copyWith(
        trackingResult: Resource.loading(data: state.trackingResult?.data),
      ),
    );

    final response = await _trackingOrderUseCase.trackingOrder(
      event.trackingNumber,
    );

    emit(state.copyWith(trackingResult: response));
  }

  FutureOr<void> _onResetDataEvent(
    OrderTrackingResetDataEvent event,
    Emitter<OrderTrackingState> emit,
  ) {
    emit(
      state.copyWith(trackingResult: Resource.success(OrderTrackingEntity())),
    );
  }

  void search(String orderNumber) {
    add(OrderTrackingSearchEvent(orderNumber));
  }

  void resetData() {
    add(OrderTrackingResetDataEvent());
  }
}
