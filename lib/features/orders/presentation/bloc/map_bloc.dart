import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/resolve_order_detail_map_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/map_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/map_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';

@lazySingleton
class OrderDetailMapBloc
    extends Bloc<OrderDetailMapEvent, OrderDetailMapState> {
  OrderDetailMapBloc(this._resolveOrderDetailMapUseCase)
    : super(const OrderDetailMapState()) {
    on<OrderDetailMapResolvedEvent>(_onResolvedEvent);
    on<OrderDetailMapMarkerSelectedEvent>(_onMarkerSelectedEvent);
    on<OrderDetailMapMarkerDismissedEvent>(_onMarkerDismissedEvent);
  }

  final ResolveOrderDetailMapUseCase _resolveOrderDetailMapUseCase;

  FutureOr<void> _onResolvedEvent(
    OrderDetailMapResolvedEvent event,
    Emitter<OrderDetailMapState> emit,
  ) {
    final map = _resolveOrderDetailMapUseCase.call(
      orderDetail: event.orderDetail,
      shop: event.shop,
    );
    emit(state.copyWith(map: map, selectedMarker: null));
  }

  FutureOr<void> _onMarkerSelectedEvent(
    OrderDetailMapMarkerSelectedEvent event,
    Emitter<OrderDetailMapState> emit,
  ) {
    emit(
      state.copyWith(
        selectedMarker:
            state.selectedMarker == event.marker ? null : event.marker,
      ),
    );
  }

  FutureOr<void> _onMarkerDismissedEvent(
    OrderDetailMapMarkerDismissedEvent _,
    Emitter<OrderDetailMapState> emit,
  ) {
    emit(state.copyWith(selectedMarker: null));
  }

  void resolve({
    required OrderDetailEntity? orderDetail,
    required BriefShopEntity? shop,
  }) {
    add(OrderDetailMapResolvedEvent(orderDetail: orderDetail, shop: shop));
  }

  void selectMarker(OrderDetailMapMarkerType marker) {
    add(OrderDetailMapMarkerSelectedEvent(marker: marker));
  }

  void dismissMarker() {
    add(const OrderDetailMapMarkerDismissedEvent());
  }
}
