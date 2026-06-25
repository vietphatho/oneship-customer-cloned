abstract class VendorProfileEvent {
  const VendorProfileEvent();
}

class VendorProfileInitEvent extends VendorProfileEvent {
  const VendorProfileInitEvent({this.forceRefresh = false});

  final bool forceRefresh;
}

class VendorProfileClearedEvent extends VendorProfileEvent {
  const VendorProfileClearedEvent();
}
