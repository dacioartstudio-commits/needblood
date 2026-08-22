import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Wraps GPS + reverse-geocoding so profile setup and each new alert can
/// auto-fill city/area instead of asking the user to type it.
class LocationService {
  Future<bool> ensurePermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return false;
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    if (!await ensurePermission()) return null;
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Returns (city, area) best-guessed from device coordinates. Falls
  /// back to null so the caller can prompt the manual province/city
  /// picker instead.
  Future<({String? city, String? area})> resolveCityArea(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return (city: null, area: null);
      final p = placemarks.first;
      return (city: p.locality, area: p.subLocality ?? p.subAdministrativeArea);
    } catch (_) {
      return (city: null, area: null);
    }
  }

  /// Straight-line distance in km, used for "X km away" on donor cards.
  double distanceKm(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000;
  }

  /// Live position stream — powers the "notify donors as they move
  /// in/out of the request radius" behavior.
  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // meters between updates
      ),
    );
  }
}
