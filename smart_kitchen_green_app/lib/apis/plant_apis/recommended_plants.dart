import 'dart:convert';

import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_kitchen_green_app/apis/externals/locations.dart';
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/data_layer/providers/plants_record_provider.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<List<Plant>> fetchRecomendations(context, ismore) async {
  String? token = await getToken();
  LocationData locationData = await getCurrentLocation();
  double latitude = locationData.latitude!;
  double longitude = locationData.longitude!;

  Map<String, dynamic> loc = await getCityName(latitude, longitude);
  String address = loc['city'] + "," + loc['country'];
  Provider.of<RecordProvider>(context, listen: false).setAddress(address);

  try {
    var response = await http.get(
      Uri.parse(
          "${Urls.recommended_plants + latitude.toString() + "/" + longitude.toString() + "/" + address + "/" + ismore}"),
      headers: {
        'Authorization': 'TOKEN $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode < 300) {
      List<Plant> plants = [];
      Iterable jsonResponse = json.decode(response.body);
      jsonResponse.forEach((element) {
        Plant product = Plant.fromJson(element);
        plants.add(product);
      });
      Provider.of<RecordProvider>(context, listen: false)
          .setPlantsRecord(plants);

      return plants;
    } else {
      flashMessage(context, 'error', response.body);
      return [];
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
    return [];
  }
}
