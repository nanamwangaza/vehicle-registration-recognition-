import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String locationMessage = 'My current location';
  String address = ''; // Variable to hold the address
  late String lat;
  late String long;

  // Getting current location
   Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request');
    }

    return Geolocator.getCurrentPosition();
  }

  // Listen to location updates
  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude.toString();
      long = position.longitude.toString();

      setState(() {
        locationMessage = 'Latitude: $lat, Longitude: $long';
      });
    });
  }

  // Get address
  Future<void> _getAddressFromLatLong(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    if (placemark.isNotEmpty) {
      final street = placemark[0].street ?? '';
      final subAdministrativeArea = placemark[0].subAdministrativeArea ?? '';
      final locality = placemark[0].locality ?? '';
      final administrativeArea = placemark[0].administrativeArea ?? '';
      final country = placemark[0].country ?? '';

      setState(() {
        address = '$street, $subAdministrativeArea, $locality, $administrativeArea, $country';
      });
    } else {
      setState(() {
        address = 'Address information not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            locationMessage,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),

          Text(
            address, // Display the address
            textAlign: TextAlign.center,
          ),

          SizedBox(
            height: 50,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _getCurrentLocation().then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';

                  setState(() {
                   // locationMessage = 'Latitude: $lat, Longitude: $long';

                    _liveLocation();
                    _getAddressFromLatLong(value);
                  });
                });
              },
              child: Text('My location'),
            ),
          ),
        ],
      ),
    );
  }
}


