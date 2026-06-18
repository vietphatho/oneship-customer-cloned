abstract class BarcodeScannerEvent {
  const BarcodeScannerEvent();
}

class BarcodeScannerStartedEvent extends BarcodeScannerEvent {
  const BarcodeScannerStartedEvent({required this.shopId});

  final String? shopId;
}

class BarcodeScannerDetectedEvent extends BarcodeScannerEvent {
  const BarcodeScannerDetectedEvent(this.code);

  final String code;
}

class BarcodeScannerResumedEvent extends BarcodeScannerEvent {
  const BarcodeScannerResumedEvent();
}
