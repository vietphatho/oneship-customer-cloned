import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/order_tracking/domain/use_cases/tracking_order_use_case.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_event.dart';
import 'package:oneship_customer/features/order_tracking/presentation/bloc/order_tracking_state.dart';

@lazySingleton
class OrderTrackingBloc extends Bloc<OrderTrackingEvent, OrderTrackingState> {
  OrderTrackingBloc(this._trackingOrderUseCase)
    : super(OrderTrackingInitState(trackingResult: Resource.loading())) {
    on<OrderTrackingSearchEvent>(_onSearchEvent);
  }

  final TrackingOrderUseCase _trackingOrderUseCase;

  FutureOr<void> _onSearchEvent(
    OrderTrackingSearchEvent event,
    Emitter<OrderTrackingState> emit,
  ) async {
    emit(OrderTrackingInitState(trackingResult: Resource.loading()));

    final response = await _trackingOrderUseCase.trackingOrder(
      event.trackingNumber,
    );

    emit(OrderTrackingInitState(trackingResult: response));
  }

  void search(String orderNumber) {
    add(OrderTrackingSearchEvent(orderNumber));
  }
}
