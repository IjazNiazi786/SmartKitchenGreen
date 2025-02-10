import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';

class RecordProvider extends ChangeNotifier {
  List<Plant> plants = [];

  ValueNotifier<String> address = ValueNotifier<String>('loadin...');
  ValueNotifier<String> get cityCountry => address;

  void setAddress(String address) {
    this.address.value = address;
    notifyListeners();
  }

  List<Plant> get plantsRecord => plants;
  void setPlantsRecord(List<Plant> plants) {
    this.plants = plants;
    notifyListeners();
  }
}
