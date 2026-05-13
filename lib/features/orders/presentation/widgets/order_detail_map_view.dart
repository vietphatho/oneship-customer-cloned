import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:oneship_customer/core/base/base_import_components.dart';
import 'package:oneship_customer/core/base/models/base_coordinates.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class OrderDetailMapView extends StatefulWidget {
  const OrderDetailMapView({
    super.key,
    required this.shopCoordinates,
    required this.deliveryCoordinates,
    this.shopAddress,
    this.deliveryAddress,
  });

  final BaseCoordinates? shopCoordinates;
  final BaseCoordinates? deliveryCoordinates;
  final String? shopAddress;
  final String? deliveryAddress;

  @override
  State<OrderDetailMapView> createState() => _OrderDetailMapViewState();
}

class _OrderDetailMapViewState extends State<OrderDetailMapView> {
  VietmapController? _mapController;
  bool _isAnimatingCamera = false;
  _SelectedMarkerInfo? _selectedMarkerInfo;

  LatLng? get _shopLatLng => _toLatLng(widget.shopCoordinates);

  LatLng? get _deliveryLatLng => _toLatLng(widget.deliveryCoordinates);

  @override
  Widget build(BuildContext context) {
    final initialTarget = _initialTarget;
    if (initialTarget == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: AppDimensions.smallBorderRadius,
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          children: [
            VietmapGL(
              styleString: Constants.vietmapUrl,
              logoEnabled: false,
              initialCameraPosition: CameraPosition(
                target: initialTarget,
                zoom: _initialZoom,
              ),
              compassEnabled: false,
              myLocationEnabled: false,
              trackCameraPosition: true,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: (controller) {
                setState(() {
                  _mapController = controller;
                });
              },
            ),
            if (_mapController != null)
              MarkerLayer(
                ignorePointer: false,
                mapController: _mapController!,
                markers: [
                  if (_shopLatLng != null)
                    Marker(
                      width: 42,
                      height: 50,
                      latLng: _shopLatLng!,
                      child: GestureDetector(
                        onTap: () => _toggleMarker(
                          id: "shop",
                          address: widget.shopAddress,
                          color: const Color(0xFF22A866),
                        ),
                        child: const _MapMarker(
                          icon: Icons.home_work_rounded,
                          color: Color(0xFF22A866),
                        ),
                      ),
                    ),
                  if (_deliveryLatLng != null)
                    Marker(
                      width: 42,
                      height: 50,
                      latLng: _deliveryLatLng!,
                      child: GestureDetector(
                        onTap: () => _toggleMarker(
                          id: "delivery",
                          address: widget.deliveryAddress,
                          color: const Color(0xFF4F7CF7),
                        ),
                        child: const _MapMarker(
                          icon: Icons.near_me_rounded,
                          color: Color(0xFF4F7CF7),
                        ),
                      ),
                    ),
                ],
              ),
            if (_selectedMarkerInfo != null)
              Positioned(
                left: AppDimensions.xSmallSpacing,
                right: AppDimensions.xSmallSpacing + 48,
                top: AppDimensions.xSmallSpacing,
                child: _MarkerInfoCard(
                  info: _selectedMarkerInfo!,
                  onClose: () {
                    setState(() {
                      _selectedMarkerInfo = null;
                    });
                  },
                ),
              ),
            Positioned(
              right: AppDimensions.xSmallSpacing,
              top: AppDimensions.xSmallSpacing,
              child: _MapActionButton(
                icon: Icons.my_location_rounded,
                onTap: () => _animateCamera(_initialCameraUpdate),
              ),
            ),
            Positioned(
              right: AppDimensions.xSmallSpacing,
              top: AppDimensions.xSmallSpacing * 2 + 40,
              child: _MapActionButton(
                icon: Icons.add_rounded,
                onTap: () => _zoomBy(1),
              ),
            ),
            Positioned(
              right: AppDimensions.xSmallSpacing,
              top: AppDimensions.xSmallSpacing * 3 + 80,
              child: _MapActionButton(
                icon: Icons.remove_rounded,
                onTap: () => _zoomBy(-1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CameraUpdate? get _initialCameraUpdate {
    final target = _initialTarget;
    if (target == null) return null;
    return CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: _initialZoom),
    );
  }

  Future<void> _animateCamera(CameraUpdate? update) async {
    if (update == null || _mapController == null || _isAnimatingCamera) return;
    _isAnimatingCamera = true;
    await _mapController!.animateCamera(update);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _isAnimatingCamera = false;
  }

  Future<void> _zoomBy(double delta) async {
    final currentPosition = _mapController?.cameraPosition;
    if (currentPosition == null) return;

    final nextZoom = (currentPosition.zoom + delta).clamp(4.0, 18.0);
    await _animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition.target, zoom: nextZoom),
      ),
    );
  }

  LatLng? get _initialTarget {
    final shop = _shopLatLng;
    final delivery = _deliveryLatLng;
    if (shop == null) return delivery;
    if (delivery == null) return shop;

    return LatLng(
      (shop.latitude + delivery.latitude) / 2,
      (shop.longitude + delivery.longitude) / 2,
    );
  }

  double get _initialZoom {
    if (_shopLatLng != null && _deliveryLatLng != null) return 14;
    return Constants.defaultMapZoomValue;
  }

  LatLng? _toLatLng(BaseCoordinates? coordinates) {
    final latLong = coordinates?.latLong;
    final lat = latLong?.lat;
    final long = latLong?.long;
    if (lat == null || long == null) return null;
    return LatLng(lat, long);
  }

  void _toggleMarker({
    required String id,
    required String? address,
    required Color color,
  }) {
    setState(() {
      if (_selectedMarkerInfo?.id == id) {
        _selectedMarkerInfo = null;
        return;
      }
      _selectedMarkerInfo = _SelectedMarkerInfo(
        id: id,
        address: address,
        color: color,
      );
    });
  }
}

class _SelectedMarkerInfo {
  const _SelectedMarkerInfo({
    required this.id,
    required this.address,
    required this.color,
  });

  final String id;
  final String? address;
  final Color color;
}

class _MarkerInfoCard extends StatelessWidget {
  const _MarkerInfoCard({required this.info, required this.onClose});

  final _SelectedMarkerInfo info;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.smallBorderRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral1.withOpacity(0.16),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.smallSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(color: info.color, shape: BoxShape.circle),
            ),
            AppSpacing.horizontal(AppDimensions.xSmallSpacing),
            Expanded(
              child: PrimaryText(
                info.address?.trim().isNotEmpty == true ? info.address : "--",
                style: AppTextStyles.bodySmall,
                color: AppColors.neutral2,
              ),
            ),
            InkWell(
              onTap: onClose,
              borderRadius: AppDimensions.smallBorderRadius,
              child: const Padding(
                padding: EdgeInsets.all(2),
                child: Icon(Icons.close_rounded, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapActionButton extends StatelessWidget {
  const _MapActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppDimensions.smallBorderRadius,
      elevation: 3,
      child: InkWell(
        borderRadius: AppDimensions.smallBorderRadius,
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.neutral2, size: 22),
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.neutral1.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -5),
          child: Transform.rotate(
            angle: 0.785398,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                border: const Border(
                  right: BorderSide(color: Colors.white, width: 2),
                  bottom: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: const SizedBox(width: 10, height: 10),
            ),
          ),
        ),
      ],
    );
  }
}
