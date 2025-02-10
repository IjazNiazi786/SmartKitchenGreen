import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';

import '../../../constants.dart';

class IconCard extends StatelessWidget {
  final String icon;
  final Plant plant;

  const IconCard({
    required this.icon,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.symmetric(vertical: size.height * 0.008),
        padding: EdgeInsets.all(kDefaultPadding / 1.2),
        height: 100,
        width: 80,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 15),
              blurRadius: 22,
              color: kPrimaryColor.withOpacity(0.22),
            ),
            BoxShadow(
              offset: Offset(-15, -15),
              blurRadius: 20,
              color: Colors.white,
            ),
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(icon),
            Text("567"),
          ],
        ));
  }
}
