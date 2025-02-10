import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';

class MyCrops extends StatefulWidget {
  const MyCrops({super.key});

  @override
  State<MyCrops> createState() => _MyCropsState();
}

class _MyCropsState extends State<MyCrops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Plants")),
      body: Column(
        children: [
          Image(
              image: NetworkImage(
                  "https://i.pinimg.com/736x/6b/9b/ae/6b9bae1f640498cc08b74c6c9b69ebb2.jpg")),
        ],
      ),
    );
  }
}
