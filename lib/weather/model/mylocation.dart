import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

final String OPENWEATHER_API_KEY = dotenv.env['OPENWEATHER_API_KEY']!;

class MyLocation extends StatefulWidget {
  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  double? latitude;
  double? longitude;
  String? radarUrl;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, do not continue.
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, do not continue.
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, do not continue.
      print('Location permissions are permanently denied');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      _fetchRadarImage(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  TileCoordinates latLonToTile(double lat, double lon, int zoom) {
    int x = ((lon + 180) / 360 * pow(2, zoom)).floor();
    int y = ((1 - log(tan(lat * pi / 180) + 1 / cos(lat * pi / 180)) / pi) / 2 * pow(2, zoom)).floor();
    return TileCoordinates(x, y);
  }

  Future<void> _fetchRadarImage(double lat, double lon) async {
    String apiKey = OPENWEATHER_API_KEY;
    int zoom = 1; // 원하는 줌 레벨 설정
    TileCoordinates tile = latLonToTile(lat, lon, zoom);
    String url = 'https://tile.openweathermap.org/map/precipitation_new/$zoom/${tile.x}/${tile.y}.png?appid=$apiKey';
    setState(() {
      radarUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Example')),
      body: Center(
        child: latitude == null || longitude == null
            ? CircularProgressIndicator()
            : Text('Latitude: $latitude, Longitude: $longitude'),
      ),
    );
  }
}

class TileCoordinates {
  final int x;
  final int y;
  TileCoordinates(this.x, this.y);
}
