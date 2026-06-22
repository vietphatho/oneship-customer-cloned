import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oneship_customer/core/base/models/resource.dart';
import 'package:oneship_customer/features/barcode_scanner/domain/use_cases/update_google_sheet_use_case.dart';
import 'package:oneship_customer/features/barcode_scanner/presentation/bloc/barcode_scanner_event.dart';
import 'package:oneship_customer/features/barcode_scanner/presentation/bloc/barcode_scanner_state.dart';

@lazySingleton
class BarcodeScannerBloc
    extends Bloc<BarcodeScannerEvent, BarcodeScannerState> {
  BarcodeScannerBloc(this._updateGoogleSheetUseCase)
    : super(
        BarcodeScannerState(updateGoogleSheetResource: Resource.loading()),
      ) {
    on<BarcodeScannerStartedEvent>(_onStarted);
    on<BarcodeScannerDetectedEvent>(_onDetected);
    on<BarcodeScannerResumedEvent>(_onResumed);
  }

  static const Duration _duplicateCooldown = Duration(seconds: 3);

  final UpdateGoogleSheetUseCase _updateGoogleSheetUseCase;

  String? _lastAcceptedScanCode;
  DateTime? _lastAcceptedScanAt;
  bool _isUpdateInFlight = false;

  FutureOr<void> _onStarted(
    BarcodeScannerStartedEvent event,
    Emitter<BarcodeScannerState> emit,
  ) {
    _isUpdateInFlight = false;
    _lastAcceptedScanCode = null;
    _lastAcceptedScanAt = null;
    emit(
      state.copyWith(
        shopId: event.shopId,
        isUpdateRunning: false,
        updateGoogleSheetResource: Resource.loading(),
      ),
    );
  }

  FutureOr<void> _onDetected(
    BarcodeScannerDetectedEvent event,
    Emitter<BarcodeScannerState> emit,
  ) async {
    final shopId = state.shopId;
    if (shopId == null || shopId.isEmpty) {
      _isUpdateInFlight = false;
      emit(
        state.copyWith(
          isUpdateRunning: false,
          updateGoogleSheetResource: Resource.error(
            'scan_patient_code.no_shop_selected',
            0,
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isUpdateRunning: true,
        lastScannedCode: event.code,
        updateGoogleSheetResource: Resource.loading(),
      ),
    );

    final response = await _updateGoogleSheetUseCase.call(
      medicalRecordCode: event.code,
      shopId: shopId,
    );

    _lastAcceptedScanAt = DateTime.now();
    _isUpdateInFlight = false;
    emit(
      state.copyWith(
        isUpdateRunning: false,
        updateGoogleSheetResource: response,
      ),
    );
  }

  FutureOr<void> _onResumed(
    BarcodeScannerResumedEvent event,
    Emitter<BarcodeScannerState> emit,
  ) {
    _isUpdateInFlight = false;
    emit(state.copyWith(isUpdateRunning: false));
  }

  void startScanning({required String? shopId}) {
    add(BarcodeScannerStartedEvent(shopId: shopId));
  }

  void onBarcodeDetected(String code) {
    final trimmedCode = code.trim();
    if (trimmedCode.isEmpty || _isUpdateInFlight) return;

    final now = DateTime.now();
    final isDuplicateInCooldown =
        _lastAcceptedScanCode == trimmedCode &&
        _lastAcceptedScanAt != null &&
        now.difference(_lastAcceptedScanAt!) < _duplicateCooldown;

    if (isDuplicateInCooldown) return;

    _isUpdateInFlight = true;
    _lastAcceptedScanCode = trimmedCode;
    _lastAcceptedScanAt = now;
    add(BarcodeScannerDetectedEvent(trimmedCode));
  }

  void resumeScanning() {
    add(const BarcodeScannerResumedEvent());
  }
}
