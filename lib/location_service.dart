import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position> getCurrentPostion() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled == false) {
      return Future.error('Location Service Disabled');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location permission permanently denied ');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<Placemark>> getPlacemarks(
      {required double latitude, required double longitude}) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    return placemarks;
  }
}
