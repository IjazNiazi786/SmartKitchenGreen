import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/screens/details/components/body.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';

class DetailsScreen extends StatelessWidget {
  final Plant plant;

  const DetailsScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(""),
      body: Body(
        plant: plant,
      ),
    );
  }
}
