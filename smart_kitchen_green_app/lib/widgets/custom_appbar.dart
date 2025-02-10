import 'package:flutter/material.dart';

AppBar appBar(text){

 return AppBar(
    centerTitle: false,
    title:
    Image(image: AssetImage("assets/logo/logo1.png"),height: 80,alignment: Alignment.centerRight),
    backgroundColor: Colors.green[700],
  );
}