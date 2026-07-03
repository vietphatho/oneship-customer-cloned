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
import 'package:oneship_customer/features/orders/domain/entities/create_order_request_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/order_detail_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/routing_entity.dart';
import 'package:oneship_customer/features/orders/domain/entities/selected_product_entity.dart';
import 'package:oneship_customer/features/orders/domain/repositories/orders_repository.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/update_ord_use_case.dart';
import 'package:oneship_customer/features/orders/domain/use_cases/validate_create_order_info_use_case.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_event.dart';
import 'package:oneship_customer/features/orders/presentation/bloc/create_order_state.dart';
import 'package:oneship_customer/features/shop_home/data/enum.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/get_brief_shops_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/order_option_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shipping_service_config_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/shop_vendor_entity.dart';
import 'package:oneship_customer/features/shop_home/domain/entities/surcharge_entity.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_bloc.dart';
import 'package:oneship_customer/features/shop_home/presentation/bloc/shop_state.dart';

@lazySingleton
class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  // final AddProductToOrderUseCase _addProductToOrderUseCase;
  // final UpdateProductQuantityUseCase _updateProductQuantityUseCase;
  static const int hospitalDefaultWeight = 100;
  static const PackageSize hospitalDefaultPackageSize = PackageSize.small;

  final ValidateCreateOrderInfoUseCase _validateCreateOrderInfoUseCase;
  final UpdateOrdUseCase _updateOrdUseCase;
  final ShopBloc _shopBloc;
  CalculateDeliveryFeeRequest? _lastFeeCalculationRequest;

  CreateOrderBloc(
    this._repository,
    // this._addProductToOrderUseCase,
    // this._updateProductQuantityUseCase,
    this._validateCreateOrderInfoUseCase,
    this._updateOrdUseCase,
    this._shopBloc,
  ) : super(CreateOrderState.initial()) {
    on<CreateOrderInitShopEvent>(_onInitEvent);
    on<CreateOrderSyncVisibleSurchargesEvent>(_onSyncVisibleSurchargesEvent);
    on<CreateOrderToggleCommodityTypeEvent>(_onToggleCommodityTypeEvent);
    on<CreateOrderToggleHandlingTypeEvent>(_onToggleHandlingTypeEvent);
    on<CreateOrderChangeRequestEvent>(_onRequestChangedEvent);
    on<CreateOrderCompleteHospitalFormEvent>(_onCompleteHospitalFormEvent);
    on<CreateOrderExternalInfoChangedEvent>(_onExternalInfoChangedEvent);
    on<CreateOrderChangePickUpTimeEvent>(_onPickUpDateChangedEvent);
    on<CreateOrderChangeCustomerInfoEvent>(_onCustomerInfoChangedEvent);
    on<CreateOrderChangeOrderInfoEvent>(_onOrderInfoChangedEvent);
    on<CreateOrderChangeAcceptTermsEvent>(_onChangedAcceptTerms);
    on<CreateOrderToggleSurchargeEvent>(_onToggleSurchargeEvent);
    on<CreateOrderUpdateSurchargeValueEvent>(_onUpdateSurchargeValueEvent);
    on<CreateOrderSurchargeValidationChangedEvent>(
      _onSurchargeValidationChangedEvent,
    );
    on<CreateOrderCalculateFeeEvent>(_onCalculateDeliveryFeeEvent);
    on<CreateOrderGetRoutingToShopEvent>(_onGetRoutingEvent);
    on<CreateOrderCreateEvent>(_onCreateOrderEvent);
    // on<CreateOrderChangeProductEvent>(_onProductChangedEvent);
    on<CreateOrderErrorEvent>(_onErrorEvent);
    on<UpdateOrderInitEvent>(_onInitUpdateOrdEvent);
  }

  final OrdersRepository _repository;

  FutureOr<void> _onInitEvent(
    CreateOrderInitShopEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    // Preserve existing request data, only inject shopId if not already set
    final shopId = state.request.shopId ?? event.shop.shopId;
    final externalType = _externalTypeForShop(event.shop.shopType);
    var request = state.request.copyWith(
      shopId: shopId,
      externalId: event.shop.shopType == ShopType.market
          ? state.request.externalId
          : null,
      externalType: externalType,
    );
    var draftRequest = state.draftRequest.copyWith(
      shopId: shopId,
      externalId: event.shop.shopType == ShopType.market
          ? state.draftRequest.externalId
          : null,
      externalType: externalType,
    );
    if (event.shop.shopType == ShopType.hospital) {
      request = _applyHospitalDefaults(request);
      draftRequest = _applyHospitalDefaults(draftRequest);
    }

    emit(
      state.copyWith(
        shopInfo: event.shop,
        request: request,
        draftRequest: draftRequest,
        errorMessage: null,
      ),
    );
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onSyncVisibleSurchargesEvent(
    CreateOrderSyncVisibleSurchargesEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final availableCodes = _visibleSurcharges
        .map((surcharge) => surcharge.code)
        .toSet();
    final nextState = state.copyWith(
      selectedSurchargeCodes: state.selectedSurchargeCodes
          .where(availableCodes.contains)
          .toList(),
      surchargeInputValues: Map.fromEntries(
        state.surchargeInputValues.entries.where(
          (entry) => availableCodes.contains(entry.key),
        ),
      ),
      surchargeValidationErrors: const {},
    );
    emit(_applySurchargePayload(nextState));
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onToggleCommodityTypeEvent(
    CreateOrderToggleCommodityTypeEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final detail = state.draftRequest.detail ?? const DetailEntity();
    final commodityType = _toggleCode(
      codes: detail.commodityType,
      code: event.code,
      isSelected: event.isSelected,
    );

    final nextDetail = detail.copyWith(commodityType: commodityType);

    emit(
      state.copyWith(
        request: state.request.copyWith(detail: nextDetail),
        draftRequest: state.draftRequest.copyWith(detail: nextDetail),
        errorMessage: null,
      ),
    );
  }

  FutureOr<void> _onToggleHandlingTypeEvent(
    CreateOrderToggleHandlingTypeEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final detail = state.draftRequest.detail ?? const DetailEntity();
    final handlingType = _toggleCode(
      codes: detail.handlingType,
      code: event.code,
      isSelected: event.isSelected,
    );

    final nextDetail = detail.copyWith(handlingType: handlingType);

    emit(
      state.copyWith(
        request: state.request.copyWith(detail: nextDetail),
        draftRequest: state.draftRequest.copyWith(detail: nextDetail),
        errorMessage: null,
      ),
    );
  }

  List<String> _toggleCode({
    required List<String> codes,
    required String code,
    required bool isSelected,
  }) {
    final nextCodes = [...codes];
    if (isSelected) {
      if (!nextCodes.contains(code)) {
        nextCodes.add(code);
      }
    } else {
      nextCodes.remove(code);
    }
    return nextCodes;
  }

  FutureOr<void> _onRequestChangedEvent(
    CreateOrderChangeRequestEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        request: event.request,
        draftRequest: event.request,
        step: event.step,
        errorMessage: null,
      ),
    );
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onCompleteHospitalFormEvent(
    CreateOrderCompleteHospitalFormEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        request: event.request,
        draftRequest: event.request,
        surchargeValidationErrors: const {},
        step: CreateOrderStep.confirmation,
        errorMessage: null,
      ),
    );
    _lastFeeCalculationRequest = null;
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onExternalInfoChangedEvent(
    CreateOrderExternalInfoChangedEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        request: state.request.copyWith(
          externalId: event.externalId,
          externalType: event.externalType,
        ),
        draftRequest: state.draftRequest.copyWith(
          externalId: event.externalId,
          externalType: event.externalType,
        ),
        errorMessage: null,
      ),
    );
  }

  FutureOr<void> _onPickUpDateChangedEvent(
    CreateOrderChangePickUpTimeEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        draftRequest: state.draftRequest.copyWith(
          detail: state.draftRequest.detail?.copyWith(
            pickupDate: event.pickUpDate,
            pickupSession: event.pickUpSession,
          ),
        ),
        errorMessage: null,
      ),
    );
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onCustomerInfoChangedEvent(
    CreateOrderChangeCustomerInfoEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final previousDraft = state.draftRequest;
    final hasLocationChanged =
        event.province != previousDraft.province ||
        event.ward != previousDraft.ward ||
        event.address != previousDraft.fullAddress;

    emit(
      state.copyWith(
        request: hasLocationChanged
            ? state.request.copyWith(router: null)
            : state.request,
        draftRequest: previousDraft.copyWith(
          customerName: event.customerName,
          phone: event.phoneNumber,
          province: event.province,
          ward: event.ward,
          fullAddress: event.address,
          isNewAddress: event.isNewAddress ?? false,
          router: hasLocationChanged ? null : previousDraft.router,
        ),
        routingToShopResource: hasLocationChanged
            ? Resource.loading()
            : state.routingToShopResource,
        errorMessage: null,
      ),
    );
    if (hasLocationChanged) {
      _syncDeliveryFeeCalculation(emit);
    }
  }

  FutureOr<void> _onOrderInfoChangedEvent(
    CreateOrderChangeOrderInfoEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        draftRequest: state.draftRequest.copyWith(
          codAmount: event.cod,
          packageSize: event.packageSize,
          detail: state.draftRequest.detail?.copyWith(
            weight: event.weight?.toDouble(),
            width: event.width,
            length: event.length,
            height: event.height,
            note: event.note,
          ),
          serviceConfig: event.serviceConfig,
        ),
        errorMessage: null,
      ),
    );

    if (event.serviceConfig != null || event.weight != null) {
      _syncDeliveryFeeCalculation(emit);
    }
  }

  FutureOr<void> _onCalculateDeliveryFeeEvent(
    CreateOrderCalculateFeeEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(
      state.copyWith(
        calculatedFeeResource: Resource.loading(
          data: state.calculatedFeeResource?.data,
        ),
        errorMessage: null,
      ),
    );
    final response = await _repository.calculateDeliveryFee(event.request);

    emit(state.copyWith(calculatedFeeResource: response));
  }

  FutureOr<void> _onGetRoutingEvent(
    CreateOrderGetRoutingToShopEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    emit(
      state.copyWith(
        request: state.request.copyWith(router: null),
        draftRequest: state.draftRequest.copyWith(router: null),
        routingToShopResource: Resource.loading(),
      ),
    );
    _syncDeliveryFeeCalculation(emit);
    final response = await _repository.getRoutingToShop(
      shopCoordinates: event.shopCoor,
      destinationRefId: event.destinationRefId,
    );

    GetRoutingToShopResponse? data = response.data;
    emit(
      state.copyWith(
        request: state.request.copyWith(
          router: data != null ? RoutingEntity.from(data) : null,
        ),
        draftRequest: state.draftRequest.copyWith(
          router: data != null ? RoutingEntity.from(data) : null,
        ),
        routingToShopResource: response,
      ),
    );
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onCreateOrderEvent(
    CreateOrderCreateEvent event,
    Emitter<CreateOrderState> emit,
  ) async {
    // Capture before emit changes state
    final updateOrdId = state.updateOrdId;
    final currentRequest = state.request;

    emit(
      state.copyWith(
        createOrderResource: Resource.loading(),
        request: currentRequest,
        updateOrdId: updateOrdId,
        errorMessage: null,
      ),
    );

    late final Resource response;
    if (updateOrdId == null) {
      response = await _repository.createOrder(currentRequest.toDto());
    } else {
      // Strip system-managed fields that server rejects on update
      // and filter products with invalid productId (empty string)
      final cleanRequest = currentRequest.copyWith(
        paymentStatus: null,
        paymentMethod: null,
        status: null,
        orderNumber: null,
        selectedProducts: currentRequest.selectedProducts
            .where((p) => p.id.isNotEmpty)
            .toList(),
      );
      response = await _updateOrdUseCase.call(
        ordId: updateOrdId,
        request: cleanRequest,
      );
    }

    emit(
      state.copyWith(createOrderResource: response, updateOrdId: updateOrdId),
    );
  }

  void changeMarketVendor(ShopVendorEntity? vendor) {
    if (!_isMarketOrder) return;

    final externalId = vendor?.userId.trim();
    final normalizedExternalId = externalId?.isNotEmpty == true
        ? externalId
        : null;
    add(
      CreateOrderExternalInfoChangedEvent(
        externalId: normalizedExternalId,
        externalType: ExternalType.vendor,
      ),
    );
  }

  // FutureOr<void> _onProductChangedEvent(
  //   CreateOrderChangeProductEvent event,
  //   Emitter<CreateOrderState> emit,
  // ) {
  //   // var products =
  //   //     event.products.map((e) => SelectedProductEntity).toList();
  //   emit(
  //     CreateOrderProductChangedState(
  //       request: state.request.copyWith(selectedProducts: event.products),
  //       draftRequest: state.draftRequest.copyWith(selectedProducts: event.products),
  //       shopInfo: state.shopInfo,
  //       routingToShopResource: state.routingToShopResource,
  //       productEntitySelected: event.products,
  //       updateOrdId: state.updateOrdId,
  //     ),
  //   );
  // }

  FutureOr<void> _onChangedAcceptTerms(
    CreateOrderChangeAcceptTermsEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(state.copyWith(acceptTerms: event.accept, errorMessage: null));
  }

  FutureOr<void> _onToggleSurchargeEvent(
    CreateOrderToggleSurchargeEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final selectedCodes = [...state.selectedSurchargeCodes];
    final inputValues = Map<String, int>.from(state.surchargeInputValues);
    var errors = Map<String, String>.from(state.surchargeValidationErrors);

    if (event.isSelected) {
      if (!selectedCodes.contains(event.code)) {
        selectedCodes.add(event.code);
      }
    } else {
      selectedCodes.remove(event.code);
      inputValues.remove(event.code);
      errors.remove(event.code);
    }
    errors = _buildSurchargeValidationErrors(
      selectedCodes: selectedCodes,
      inputValues: inputValues,
    );

    emit(
      _applySurchargePayload(
        state.copyWith(
          selectedSurchargeCodes: selectedCodes,
          surchargeInputValues: inputValues,
          surchargeValidationErrors: errors,
          errorMessage: null,
        ),
      ),
    );
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onUpdateSurchargeValueEvent(
    CreateOrderUpdateSurchargeValueEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    final inputValues = Map<String, int>.from(state.surchargeInputValues);
    if (event.value == null) {
      inputValues.remove(event.code);
    } else {
      inputValues[event.code] = event.value!;
    }

    final nextState = state.copyWith(
      surchargeInputValues: inputValues,
      surchargeValidationErrors: _buildSurchargeValidationErrors(
        inputValues: inputValues,
        selectedCodes: state.selectedSurchargeCodes,
      ),
      errorMessage: null,
    );
    emit(_applySurchargePayload(nextState));
    _syncDeliveryFeeCalculation(emit);
  }

  FutureOr<void> _onSurchargeValidationChangedEvent(
    CreateOrderSurchargeValidationChangedEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(state.copyWith(surchargeValidationErrors: event.errors));
  }

  FutureOr<void> _onErrorEvent(
    CreateOrderErrorEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(state.copyWith(errorMessage: event.message));
  }

  FutureOr<void> _onInitUpdateOrdEvent(
    UpdateOrderInitEvent event,
    Emitter<CreateOrderState> emit,
  ) {
    emit(
      state.copyWith(
        request: event.request,
        draftRequest: event.request,
        selectedSurchargeCodes: event.request.surchargeCodes,
        surchargeInputValues: event.request.surchargeValues,
        updateOrdId: event.ordId,
        errorMessage: null,
      ),
    );
  }

  void _error(String message) {
    add(CreateOrderErrorEvent(message));
  }

  CreateOrderState _applySurchargePayload(CreateOrderState source) {
    return source.copyWith(
      request: source.request.copyWith(
        surchargeCodes: source.selectedSurchargeCodes,
        surchargeValues: _selectedSurchargeValues(source),
      ),
      draftRequest: source.draftRequest.copyWith(
        surchargeCodes: source.selectedSurchargeCodes,
        surchargeValues: _selectedSurchargeValues(source),
      ),
    );
  }

  Map<String, String> _buildSurchargeValidationErrors({
    required List<String> selectedCodes,
    required Map<String, int> inputValues,
  }) {
    final errors = <String, String>{};
    for (final code in selectedCodes) {
      final surcharge = _findSurcharge(code);
      if (surcharge == null || !surcharge.requiresValue) continue;

      final value = inputValues[code];
      if (value == null) {
        errors[code] = "validate.text_required";
      } else if (!surcharge.isValidValue(value)) {
        errors[code] = "invalid_surcharge_value";
      }
    }
    return errors;
  }

  void _syncDeliveryFeeCalculation(Emitter<CreateOrderState> emit) {
    final request = _feeCalculationRequest();
    if (state.canCalculateFee != (request != null)) {
      emit(state.copyWith(canCalculateFee: request != null));
    }
    if (request == null) {
      _lastFeeCalculationRequest = null;
      if (state.calculatedFeeResource != null) {
        emit(state.copyWith(calculatedFeeResource: null));
      }
      return;
    }

    if (request == _lastFeeCalculationRequest) return;
    _lastFeeCalculationRequest = request;
    add(CreateOrderCalculateFeeEvent(request));
  }

  List<SurchargeEntity> get _visibleSurcharges =>
      _shopBloc.state.visibleSurcharges;

  SurchargeEntity? _findSurcharge(String code) {
    for (final surcharge in _visibleSurcharges) {
      if (surcharge.code == code) return surcharge;
    }
    return null;
  }

  Map<String, int> _selectedSurchargeValues([CreateOrderState? source]) {
    final current = source ?? state;
    final values = <String, int>{};
    for (final surcharge in _visibleSurcharges) {
      if (!current.selectedSurchargeCodes.contains(surcharge.code)) continue;
      if (!surcharge.requiresValue) continue;
      final value = current.surchargeInputValues[surcharge.code];
      if (value != null) values[surcharge.code] = value;
    }
    return values;
  }

  bool hasInvalidSelectedSurcharges([CreateOrderState? source]) {
    final current = source ?? state;
    for (final surcharge in _visibleSurcharges) {
      if (!current.selectedSurchargeCodes.contains(surcharge.code)) continue;
      if (!surcharge.requiresValue) continue;
      if (!surcharge.isValidValue(
        current.surchargeInputValues[surcharge.code],
      )) {
        return true;
      }
    }
    return false;
  }

  void syncVisibleSurcharges() {
    add(const CreateOrderSyncVisibleSurchargesEvent());
  }

  CalculateDeliveryFeeRequest? _feeCalculationRequest() {
    final draftRequest = _applyHospitalDefaultsIfNeeded(state.draftRequest);
    final shopId = state.shopInfo.shopId ?? draftRequest.shopId;
    final distance =
        state.routingToShopResource.data?.distance ??
        draftRequest.router?.distance;
    final serviceCode = draftRequest.serviceConfig?.serviceCode;
    final weight = draftRequest.detail?.weight?.toInt();
    final provinceCode = draftRequest.province?.code;
    final wardCode = draftRequest.ward?.code;

    if (shopId == null || shopId.isEmpty) return null;
    if (distance == null || distance <= 0) return null;
    if (serviceCode == null || serviceCode.isEmpty) return null;
    if (weight == null || weight <= 0) return null;
    if (hasInvalidSelectedSurcharges()) return null;
    if (provinceCode == null) return null;
    if (wardCode == null) return null;

    return CalculateDeliveryFeeRequest(
      shopId: shopId,
      distance: distance,
      serviceCode: serviceCode,
      weight: weight,
      provinceCode: provinceCode,
      wardCode: wardCode,
      surcharges: state.selectedSurchargeCodes,
      surchargesValues: _selectedSurchargeValues(),
    );
  }

  // void addProductToOrder(Map<String, ProductEntity> selectedMap) async {
  //   final newProduct = await _addProductToOrderUseCase.call(
  //     currentProduct: state.productEntitySelected,
  //     selectedMap: selectedMap,
  //   );

  //   add(CreateOrderChangeProductEvent(newProduct));
  // }

  // void updateProductQuantity(
  //   String sku,
  //   CreateOrderProductAction actionType,
  // ) async {
  //   final newProduct = await _updateProductQuantityUseCase.call(
  //     currentProduct: state.productEntitySelected,
  //     sku: sku,
  //     actionType: actionType,
  //   );

  //   add(CreateOrderChangeProductEvent(newProduct));
  // }

  void init() {
    final shopId = state.shopInfo.shopId ?? state.request.shopId;
    if (shopId == null || shopId.isEmpty) return;
  }

  void setShop(BriefShopEntity shop) {
    add(CreateOrderInitShopEvent(shop));
  }

  void toggleSurcharge(String code, bool isSelected) {
    add(CreateOrderToggleSurchargeEvent(code: code, isSelected: isSelected));
  }

  void updateSurchargeValue(String code, int? value) {
    add(CreateOrderUpdateSurchargeValueEvent(code: code, value: value));
  }

  void toggleCommodityType(String code, bool isSelected) {
    add(
      CreateOrderToggleCommodityTypeEvent(code: code, isSelected: isSelected),
    );
  }

  void toggleHandlingType(String code, bool isSelected) {
    add(CreateOrderToggleHandlingTypeEvent(code: code, isSelected: isSelected));
  }

  String selectedCommodityTypeNames() {
    final detail = state.draftRequest.detail;
    return _shopBloc.state.commodityTypes.displayNamesForCodes(
      detail?.commodityType ?? const [],
    );
  }

  String selectedHandlingTypeNames() {
    final detail = state.draftRequest.detail;
    return _shopBloc.state.handlingTypes.displayNamesForCodes(
      detail?.handlingType ?? const [],
    );
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
    PackageSize? packageSize,
    String? note,
    String? externalId,
    String? orderSource,
    required List<SelectedProductEntity> selectedProducts,
  }) {
    var currentReq = state.request;
    var draftReq = state.draftRequest;

    final newReq = currentReq.copyWith(
      externalId: _isMarketOrder ? externalId : null,
      externalType: _externalTypeForCurrentShop(),
      codAmount: codAmount,
      serviceConfig: draftReq.serviceConfig,
      packageSize: packageSize ?? draftReq.packageSize,
      surchargeCodes: state.selectedSurchargeCodes,
      surchargeValues: _selectedSurchargeValues(),
      detail: currentReq.detail?.copyWith(
        weight: weight.toDouble(),
        height: height,
        width: width,
        length: length,
        note: note,
        orderSource: orderSource,
      ),
      selectedProducts: selectedProducts,
    );
    add(
      CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.confirmation),
    );
  }

  void completeCreateOrderForm({
    required String customerName,
    required String phoneNumber,
    required String address,
    int codAmount = 0,
    required int weight,
    int? height = 0,
    int? width = 0,
    int? length = 0,
    PackageSize? packageSize,
    String? note,
    required List<SelectedProductEntity> selectedProducts,
  }) {
    final currentReq = state.request;
    final draftReq = state.draftRequest;
    final newReq = currentReq.copyWith(
      customerName: customerName,
      phone: phoneNumber,
      province: draftReq.province,
      ward: draftReq.ward,
      fullAddress: address,
      isNewAddress: draftReq.isNewAddress,
      codAmount: codAmount,
      serviceConfig: draftReq.serviceConfig,
      packageSize: packageSize ?? draftReq.packageSize,
      surchargeCodes: state.selectedSurchargeCodes,
      surchargeValues: _selectedSurchargeValues(),
      detail: currentReq.detail?.copyWith(
        weight: weight.toDouble(),
        height: height,
        width: width,
        length: length,
        note: note,
      ),
      selectedProducts: selectedProducts,
    );

    add(
      CreateOrderChangeRequestEvent(newReq, step: CreateOrderStep.confirmation),
    );
  }

  void completeHospitalCreateOrderForm({
    required String customerName,
    required String phoneNumber,
    required String address,
    required String medicalRecordCode,
    required String prescriptionNumber,
    String? delegateName,
    String? delegatePhone,
    String? note,
  }) {
    final currentReq = state.request;
    final draftReq = state.draftRequest;
    final hospitalMetadata = HospitalMetadataEntity.forToday(
      medicalRecordCode: medicalRecordCode,
      prescriptionNumber: prescriptionNumber,
      delegateName: delegateName,
      delegatePhone: delegatePhone,
    );
    final newReq = currentReq.copyWith(
      customerName: customerName,
      phone: phoneNumber,
      province: draftReq.province,
      ward: draftReq.ward,
      fullAddress: address,
      isNewAddress: draftReq.isNewAddress,
      codAmount: 0,
      serviceConfig: draftReq.serviceConfig,
      packageSize: hospitalDefaultPackageSize,
      surchargeCodes: state.selectedSurchargeCodes,
      surchargeValues: _selectedSurchargeValues(),
      detail: (currentReq.detail ?? const DetailEntity()).copyWith(
        weight: hospitalDefaultWeight.toDouble(),
        commodityType: const [],
        handlingType: const [],
        note: note,
      ),
      selectedProducts: const [],
      hospitalMetadata: hospitalMetadata.copyWith(
        prescriptionDate:
            currentReq.hospitalMetadata?.prescriptionDate ??
            hospitalMetadata.prescriptionDate,
      ),
    );

    add(CreateOrderCompleteHospitalFormEvent(newReq));
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
    PackageSize? packageSize,
    String? note,
    ShippingServiceConfigEntity? serviceConfig,
  }) {
    var draftRequest = state.draftRequest;
    add(
      CreateOrderChangeOrderInfoEvent(
        cod: cod ?? draftRequest.codAmount,
        weight: weight ?? draftRequest.detail?.weight?.toInt(),
        length: length ?? draftRequest.detail?.length,
        width: width ?? draftRequest.detail?.width,
        height: height ?? draftRequest.detail?.height,
        packageSize: packageSize ?? draftRequest.packageSize,
        note: note ?? draftRequest.detail?.note,
        serviceConfig: serviceConfig ?? draftRequest.serviceConfig,
      ),
    );
  }

  void selectDefaultShippingServiceIfNeeded(
    List<ShippingServiceConfigEntity> services, {
    bool force = false,
  }) {
    if (services.isEmpty) return;
    if (!force && state.draftRequest.serviceConfig != null) return;
    if (force &&
        state.draftRequest.serviceConfig?.serviceCode ==
            services.first.serviceCode) {
      return;
    }

    changeOrderInfo(serviceConfig: services.first);
  }

  void applyHospitalCreateOrderDefaults() {
    if (!_isHospitalOrder) return;
    final hasDefaults =
        state.draftRequest.detail?.weight?.toInt() == hospitalDefaultWeight &&
        state.draftRequest.packageSize == hospitalDefaultPackageSize;
    if (hasDefaults) return;

    changeOrderInfo(
      weight: hospitalDefaultWeight,
      packageSize: hospitalDefaultPackageSize,
    );
  }

  bool get _isHospitalOrder {
    return state.shopInfo.shopType == ShopType.hospital ||
        _shopBloc.state.currentShop?.shopType == ShopType.hospital;
  }

  bool get _isMarketOrder {
    return state.shopInfo.shopType == ShopType.market ||
        _shopBloc.state.currentShop?.shopType == ShopType.market;
  }

  ExternalType? _externalTypeForShop(ShopType shopType) {
    switch (shopType) {
      case ShopType.market:
        return ExternalType.vendor;
      case ShopType.hospital:
        return ExternalType.hospital;
      case ShopType.df:
        return null;
    }
  }

  ExternalType? _externalTypeForCurrentShop() {
    return _externalTypeForShop(
      _shopBloc.state.currentShop?.shopType ?? state.shopInfo.shopType,
    );
  }

  CreateOrderRequestEntity _applyHospitalDefaultsIfNeeded(
    CreateOrderRequestEntity request,
  ) {
    if (!_isHospitalOrder) return request;
    return _applyHospitalDefaults(request);
  }

  CreateOrderRequestEntity _applyHospitalDefaults(
    CreateOrderRequestEntity request,
  ) {
    return request.copyWith(
      packageSize: hospitalDefaultPackageSize,
      detail: (request.detail ?? const DetailEntity()).copyWith(
        weight: hospitalDefaultWeight.toDouble(),
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
    final surchargeErrors = _buildSurchargeValidationErrors(
      selectedCodes: state.selectedSurchargeCodes,
      inputValues: state.surchargeInputValues,
    );
    if (surchargeErrors.isNotEmpty) {
      add(CreateOrderSurchargeValidationChangedEvent(surchargeErrors));
      _error("invalid_surcharge_value");
      return;
    }

    final validatedResult = _validateCreateOrderInfoUseCase
        .validateConfirmInfoStep(
          request: state.request,
          acceptTerms: state.acceptTerms,
          isHospitalOrder: state.shopInfo.shopType == ShopType.hospital,
        );

    if (validatedResult != null) {
      _error(validatedResult);
      return;
    }

    add(CreateOrderCreateEvent());
  }

  void initUpdateOrdData(
    OrderDetailEntity ord, {
    List<ShippingServiceConfigEntity> shippingServices = const [],
  }) {
    var request = CreateOrderRequestEntity.fromResponseModel(
      ord,
      shippingServices: shippingServices,
    );
    add(UpdateOrderInitEvent(ordId: ord.id ?? "", request: request));
  }
}
