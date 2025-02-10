import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<LocationData> getCurrentLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      print("....................");
      throw Exception("Location permission denied");
    }
  }

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>");
      throw Exception("Location services are disabled");
    }
  }

  locationData = await location.getLocation();
  return locationData;
}

Future<Map<String, dynamic>> getCityName(
    double latitude, double longitude) async {
  final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude&accept-language=en');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // print(data);

    if (data.containsKey('address') && data['address'].containsKey('city')) {
      return {
        'city': data['address']['city'],
        "country": data['address']['country']
      };
    } else if (data.containsKey('address') &&
        data['address'].containsKey('town')) {
      return {
        'city': data['address']['town'],
        "country": data['address']['country']
      };
    } else if (data.containsKey('address') &&
        data['address'].containsKey('village')) {
      return {
        'city': data['address']['village'],
        "country": data['address']['country']
      };
    }
  } else {
    throw Exception('Failed to get city name');
  }

  return {'city': "Unknown", 'country': 'unknown'};
}
