import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/management/data/models/response/get_shops_response.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';

@lazySingleton
class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  CreateOrderBloc(this._repository)
    : super(
        CreateOrderRequestChangedState(
          request: CreateOrderEntity.empty(),
          draftRequest: CreateOrderEntity.empty(),
          shopInfo: const ShopInfo(),
          routingToShopResource: Resource.loading(),
        ),
      ) {
    on<CreateOrderInitShopEvent>(_onInitEvent);
    on<CreateOrderChangeRequestEvent>(_onRequestChangedEvent);
    on<CreateOrderChangePickUpTimeEvent>(_onPickUpDateChangedEvent);
    on<CreateOrderChangeCustomerInfoEvent>(_onCustomerInfoChangedEvent);
    on<CreateOrderChangeOrderInfoEvent>(_onOrderInfoChangedEvent);
    on<CreateOrderCalculateFeeEvent>(_onCalculateDeliveryFeeEvent);
    on<CreateOrderGetRoutingToShopEvent>(_onGetRoutingEvent);
    on<CreateOrderCreateEvent>(_onCreateOrderEvent);
  }

  final OrdersRepository _repository;

  FutureOr<void> _onInitEvent(
    CreateOrderInitShopEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderRequestChangedState(
        shopInfo: event.shop,
        request: state.request.copyWith(shopId: event.shop.shopId),
        draftRequest: state.draftRequest.copyWith(shopId: event.shop.shopId),
        step: state.step,
        routingToShopResource: state.routingToShopResource,
      ),
    );
  }

  FutureOr<void> _onRequestChangedEvent(
    CreateOrderChangeRequestEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderRequestChangedState(
        shopInfo: state.shopInfo,
        request: event.request,
        draftRequest: event.request,
        step: event.step,
        routingToShopResource: state.routingToShopResource,
      ),
    );
  }

  FutureOr<void> _onPickUpDateChangedEvent(
    CreateOrderChangePickUpTimeEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderPickUpTimeChangedState(
        shopInfo: state.shopInfo,
        request: state.request,
        routingToShopResource: state.routingToShopResource,
        pickUpDate: event.pickUpDate,
        draftRequest: state.draftRequest.copyWith(
          detail: state.draftRequest.detail?.copyWith(
            pickupDate: event.pickUpDate,
            pickUpSession: event.pickUpSession,
          ),
        ),
      ),
    );
  }

  FutureOr<void> _onCustomerInfoChangedEvent(
    CreateOrderChangeCustomerInfoEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderCustomerInfoChangedState(
        shopInfo: state.shopInfo,
        request: state.request,
        routingToShopResource: state.routingToShopResource,
        draftRequest: state.draftRequest.copyWith(
          recipientName: event.customerName,
          recipientPhone: event.phoneNumber,
          provinceName: event.province?.name,
          provinceCode: event.province?.code,
          wardName: event.ward?.name,
          wardCode: event.ward?.code,
          fullAddress: event.address,
        ),
      ),
    );
  }

  FutureOr<void> _onOrderInfoChangedEvent(
    CreateOrderChangeOrderInfoEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderInfoChangedState(
        shopInfo: state.shopInfo,
        request: state.request,
        routingToShopResource: state.routingToShopResource,
        draftRequest: state.draftRequest.copyWith(
          codAmount: event.cod,
          detail: state.draftRequest.detail?.copyWith(
            weight: event.weight,
            width: event.width,
            length: event.length,
            height: event.height,
            note: event.note,
          ),
          serviceCode: event.deliveryServiceType,
        ),
      ),
    );
  }

  FutureOr<void> _onCalculateDeliveryFeeEvent(
    CreateOrderCalculateFeeEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(
      CreateOrderCalculatedFeeState(
        Resource.loading(),
        shopInfo: state.shopInfo,
        request: state.request,
        draftRequest: state.draftRequest,
        routingToShopResource: state.routingToShopResource,
      ),
    );
    final response = await _repository.calculateDeliveryFee(event.request);
    final entity = response.parse<CalculatedDeliveryFeeEntity>(
      (e) => CalculatedDeliveryFeeEntity.from(e),
    );

    var newReq = state.request.copyWith(
      deliveryFee: response.data?.deliveryFee,
    );
    emit(
      CreateOrderCalculatedFeeState(
        entity,
        shopInfo: state.shopInfo,
        request: newReq,
        draftRequest: newReq,
        routingToShopResource: state.routingToShopResource,
      ),
    );
  }

  FutureOr<void> _onGetRoutingEvent(
    CreateOrderGetRoutingToShopEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(
      CreateOrderGetRoutingToShopState(
        request: state.request,
        draftRequest: state.draftRequest,
        shopInfo: state.shopInfo,
        routingToShopResource: Resource.loading(),
      ),
    );
    final response = await _repository.getRoutingToShop(
      shopCoordinates: event.shopCoor,
      destinationRefId: event.destinationRefId,
    );
    emit(
      CreateOrderGetRoutingToShopState(
        request: state.request,
        draftRequest: state.draftRequest,
        shopInfo: state.shopInfo,
        routingToShopResource: response,
      ),
    );
  }

  FutureOr<void> _onCreateOrderEvent(
    CreateOrderCreateEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(
      CreateOrderCreatedState(
        Resource.loading(),
        shopInfo: state.shopInfo,
        request: state.request,
        draftRequest: state.draftRequest,
        routingToShopResource: state.routingToShopResource,
      ),
    );
    final response = await _repository.createOrder(state.request.toModel());
    emit(
      CreateOrderCreatedState(
        response,
        shopInfo: state.shopInfo,
        request: state.request,
        draftRequest: state.draftRequest,
        routingToShopResource: state.routingToShopResource,
      ),
    );
  }

  void setShop(ShopInfo shop) {
    add(CreateOrderInitShopEvent(shop));
  }

  void backToStep(CreateOrderStep step) {
    add(CreateOrderChangeRequestEvent(state.request, step: step));
  }

  void completeDateStep() {
    var currentReq = state.request;
    var draftRequest = state.draftRequest;

    final newReq = currentReq.copyWith(
      detail: currentReq.detail?.copyWith(
        pickupDate: draftRequest.detail?.pickupDate,
        pickUpSession: draftRequest.detail?.pickUpSession,
      ),
    );
    add(
      CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.receiverInfo),
    );
  }

  void completeCustomerInfoStep({
    required String customerName,
    required String phoneNumber,
    required String address,
  }) {
    var currentReq = state.request;
    var draftReq = state.draftRequest;

    final newReq = currentReq.copyWith(
      recipientName: customerName,
      recipientPhone: phoneNumber,
      provinceName: draftReq.provinceName,
      provinceCode: draftReq.provinceCode,
      wardName: draftReq.wardName,
      wardCode: draftReq.wardCode,
      fullAddress: address,
      detail: currentReq.detail?.copyWith(),
    );
    add(CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.orderInfo));
  }

  void completeOrderInfoStep({
    int codAmount = 0,
    required int weight,
    int? height = 0,
    int? width = 0,
    int? length = 0,
    String? note,
  }) {
    var currentReq = state.request;
    var draftReq = state.draftRequest;

    final newReq = currentReq.copyWith(
      codAmount: codAmount,
      serviceCode: draftReq.serviceCode,
      detail: currentReq.detail?.copyWith(
        weight: weight,
        height: height,
        width: width,
        length: length,
        note: note,
      ),
    );
    add(
      CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.confirmation),
    );

    final calculateFeeRequest = CalculateDeliveryFeeRequest(
      shopId: state.shopInfo.shopId,
      distance: state.routingToShopResource.data?.distance,
      serviceCode: newReq.serviceCode.requestValue,
      weight: newReq.detail?.weight,
    );
    add(CreateOrderCalculateFeeEvent(calculateFeeRequest));
  }

  void changePickUpDate({DateTime? date, OrderPickUpSession? session}) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangePickUpTimeEvent(
        pickUpDate: date ?? draftRequest.detail?.pickupDate,
        pickUpSession: session ?? draftRequest.detail?.pickUpSession,
      ),
    );
  }

  void changeCustomerInfo({
    String? name,
    String? phoneNumber,
    String? address,
    String? destinationRefId,
    Province? province,
    Ward? ward,
  }) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangeCustomerInfoEvent(
        customerName: name ?? draftRequest.recipientName,
        phoneNumber: phoneNumber ?? draftRequest.recipientPhone,
        address: address ?? draftRequest.fullAddress,
        province: province ?? draftRequest.province,
        ward: province != null ? null : (ward ?? draftRequest.ward),
      ),
    );

    if (destinationRefId != null) {
      add(
        CreateOrderGetRoutingToShopEvent(
          shopCoor: state.shopInfo.shopCoordinates!.latLong,
          destinationRefId: destinationRefId,
        ),
      );
    }
  }

  void changeOrderInfo({
    int? cod,
    int? weight,
    int? length,
    int? width,
    int? height,
    String? note,
    DeliveryServiceType? deliveryServiceType,
  }) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangeOrderInfoEvent(
        cod: cod ?? draftRequest.codAmount,
        weight: weight ?? draftRequest.detail?.weight,
        length: length ?? draftRequest.detail?.length,
        width: width ?? draftRequest.detail?.width,
        height: height ?? draftRequest.detail?.height,
        note: note ?? draftRequest.detail?.note,
        deliveryServiceType: deliveryServiceType ?? draftRequest.serviceCode,
      ),
    );
  }

  void createOrder() {
    add(CreateOrderCreateEvent());
  }
}
