import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/constants.dart';

import 'image_and_icons.dart';
import 'title_and_price.dart';

class Body extends StatelessWidget {
  final Plant plant;

  const Body({super.key, required this.plant});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            height: 3,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            height: 3,
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    child: Row(
                  children: [
                    Text(
                      " " + plant.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        wordSpacing: 2,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    Icon(Icons.category),
                    Text(
                      " " + plant.category,
                      style: TextStyle(),
                    ),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                  
                    Text(
                      " " + plant.bestgrow,
                      style: TextStyle(),
                    ),
                  ],
                ))
              ],
            ),
          ),
          ImageAndIcons(
            size: size,
            plant: plant,
          ),
          SizedBox(height: kDefaultPadding),
          Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 2,
                height: 84,
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20)),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Plant Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text("Description"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
