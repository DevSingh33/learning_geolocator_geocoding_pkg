import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:using_location_pkg/location_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LocationService locationService = LocationService();
  double? lat;
  double? longit;

  String street = 'no val',
      locality = 'no val',
      subLocality = 'no val',
      postalCode = 'no val',
      country = 'no val';
  Position? currentPosition;

  void getCoordinates() async {
    print('get coordinates called');

    currentPosition = await locationService.getCurrentPostion();
    setState(() {
      lat = currentPosition?.latitude;
      longit = currentPosition?.longitude;
    });
    print('lat: $lat, long: $longit');
  }

  void getAddress() async {
    print('get address called');
    getCoordinates();
    // List<Placemark> placemarks = await locationService.getPlacemarks(
    //     latitude: 37.3108, longitude: -121.8601);
    if (lat != null) {
      List<Placemark> placemarks = await locationService.getPlacemarks(
          latitude: lat ?? 0.0, longitude: longit ?? 0.0);
      setState(() {
        street = placemarks[0].street ?? 'no val';
        postalCode = placemarks[0].postalCode ?? 'no val';
        locality = placemarks[0].locality ?? 'no val';
        subLocality = placemarks[0].subLocality ?? 'no val';
        country = placemarks[0].country ?? 'no val';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('home page build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Coordinates:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text('latitude : $lat'),
                Text('longitude : $longit'),
                TextButton(
                  onPressed: getCoordinates,
                  child: const Text('Get Coordinates'),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Address :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(street),
                Text(locality),
                Text(subLocality),
                Text(postalCode),
                Text(country),
                TextButton(
                  onPressed: getAddress,
                  child: const Text('Get Address'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
