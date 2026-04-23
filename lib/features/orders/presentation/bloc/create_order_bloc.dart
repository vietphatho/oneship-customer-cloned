import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:oneship_customer/core/base/models/province.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/core/base/models/ward.dart';
import 'package:oneship_customer/features/orders/data/enum.dart';
import 'package:oneship_customer/features/orders/data/models/request/calculate_delivery_fee_request.dart';
import 'package:oneship_customer/features/orders/data/models/response/get_routing_to_shop_response.dart';
import 'package:oneship_customer/features/orders/domain/entities/calculated_delivery_fee_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/routing_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_shops_entity.dart';

@lazySingleton
class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  CreateOrderBloc(this._repository)
    : super(
        CreateOrderRequestChangedState(
          request: CreateOrderRequestEntity.empty(),
          draftRequest: CreateOrderRequestEntity.empty(),
          shopInfo: const ShopEntity(),
          routingToShopResource: Resource.loading(),
        ),
      ) {
    on<CreateOrderInitShopEvent>(_onInitEvent);
    on<CreateOrderChangeRequestEvent>(_onRequestChangedEvent);
    on<CreateOrderChangePickUpTimeEvent>(_onPickUpDateChangedEvent);
    on<CreateOrderChangeCustomerInfoEvent>(_onCustomerInfoChangedEvent);
    on<CreateOrderChangeOrderInfoEvent>(_onOrderInfoChangedEvent);
    on<CreateOrderChangeAcceptTermsEvent>(_onChangedAcceptTerms);
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
            pickupSession: event.pickUpSession,
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
          customerName: event.customerName,
          phone: event.phoneNumber,
          province: Province(
            name: event.province?.name ?? "",
            code: event.province?.code ?? 0,
          ),
          ward: Ward(
            name: event.ward?.name ?? "",
            code: event.ward?.code ?? 0,
            provinceCode: event.province?.code ?? 0,
          ),
          fullAddress: event.address,
          isNewAddress: event.isNewAddress ?? false,
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
            weight: event.weight?.toDouble(),
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

  FutureOr<void> _onChangedAcceptTerms(
    CreateOrderChangeAcceptTermsEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      CreateOrderRequestChangedState(
        request: state.request,
        draftRequest: state.draftRequest,
        shopInfo: state.shopInfo,
        routingToShopResource: state.routingToShopResource,
        step: state.step,
        acceptTerms: event.accept,
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
      // deliveryFee: response.data?.deliveryFee,
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

    GetRoutingToShopResponse? data = response.data;
    emit(
      CreateOrderGetRoutingToShopState(
        request: state.request.copyWith(
          router: data != null ? RoutingEntity.from(data) : null,
        ),
        draftRequest: state.draftRequest.copyWith(
          router: data != null ? RoutingEntity.from(data) : null,
        ),
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
    final response = await _repository.createOrder(state.request.toDto());
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

  void setShop(ShopEntity shop) {
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
        pickupSession: draftRequest.detail?.pickupSession,
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
      customerName: customerName,
      phone: phoneNumber,
      province: draftReq.province,
      ward: draftReq.ward,
      fullAddress: address,
      isNewAddress: draftReq.isNewAddress,
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
    String? externalOrderId,
    String? orderSource,
  }) {
    var currentReq = state.request;
    var draftReq = state.draftRequest;

    final newReq = currentReq.copyWith(
      externalOrderId: externalOrderId,
      codAmount: codAmount,
      serviceCode: draftReq.serviceCode,
      detail: currentReq.detail?.copyWith(
        weight: weight.toDouble(),
        height: height,
        width: width,
        length: length,
        note: note,
        orderSource: orderSource,
      ),
    );
    add(
      CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.confirmation),
    );

    final calculateFeeRequest = CalculateDeliveryFeeRequest(
      shopId: state.shopInfo.shopId,
      distance: state.routingToShopResource.data?.distance,
      serviceCode: newReq.serviceCode?.requestValue,
      weight: newReq.detail?.weight?.toInt(),
    );
    add(CreateOrderCalculateFeeEvent(calculateFeeRequest));
  }

  void changePickUpDate({DateTime? date, OrderPickUpSession? session}) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangePickUpTimeEvent(
        pickUpDate: date ?? draftRequest.detail?.pickupDate,
        pickUpSession: session ?? draftRequest.detail?.pickupSession,
      ),
    );
  }

  void changeCustomerInfo({
    String? name,
    String? phoneNumber,
    String? address,
    bool? isNewAddress,
    String? destinationRefId,
    Province? province,
    Ward? ward,
  }) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangeCustomerInfoEvent(
        customerName: name ?? draftRequest.customerName,
        phoneNumber: phoneNumber ?? draftRequest.phone,
        address: address ?? draftRequest.fullAddress,
        isNewAddress: isNewAddress ?? draftRequest.isNewAddress,
        province: province ?? draftRequest.province,
        ward: province != null ? null : (ward ?? draftRequest.ward),
      ),
    );

    final shopCoordinates = state.shopInfo.shopCoordinates?.latLong;
    if (destinationRefId != null && shopCoordinates != null) {
      add(
        CreateOrderGetRoutingToShopEvent(
          shopCoor: shopCoordinates,
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
        weight: weight ?? draftRequest.detail?.weight?.toInt(),
        length: length ?? draftRequest.detail?.length,
        width: width ?? draftRequest.detail?.width,
        height: height ?? draftRequest.detail?.height,
        note: note ?? draftRequest.detail?.note,
        deliveryServiceType: deliveryServiceType ?? draftRequest.serviceCode,
      ),
    );
  }

  void changePayer(Payer payer) {
    final changed = state.request.copyWith(payer: payer);
    add(
      CreateOrderChangeRequestEvent(
        changed,
        step: CreateOrderStep.confirmation,
      ),
    );
  }

  void changeAcceptTerms(bool accept) {
    add(CreateOrderChangeAcceptTermsEvent(accept));
  }

  void createOrder() {
    add(CreateOrderCreateEvent());
  }
}
