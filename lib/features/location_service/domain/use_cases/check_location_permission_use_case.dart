import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckLocationPermissionUseCase {
  Future<LocationPermission?> call() async {
    // Kiểm tra location service (GPS) có bật không
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    // Kiểm tra trạng thái permission hiện tại
    LocationPermission permission = await Geolocator.checkPermission();

    // Nếu chưa hỏi quyền
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      return permission;
    }

    return LocationPermission.deniedForever;
  }
}
