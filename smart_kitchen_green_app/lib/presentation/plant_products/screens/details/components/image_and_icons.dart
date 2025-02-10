import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';

import '../../../constants.dart';
import 'icon_card.dart';

class ImageAndIcons extends StatelessWidget {
  const ImageAndIcons({
    required this.size,
    required this.plant,
  });
  final Plant plant;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: size.height * 0.7,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.09),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        icon: SvgPicture.asset("assets/icons/back_arrow.svg"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // Spacer(),
                    IconCard(
                      icon: "assets/plants/icons/sun.svg",
                      plant: plant,
                    ),
                    IconCard(
                      icon: "assets/plants/icons/icon_2.svg",
                      plant: plant,
                    ),
                    IconCard(
                      icon: "assets/plants/icons/icon_3.svg",
                      plant: plant,
                    ),
                    IconCard(
                      icon: "assets/plants/icons/icon_4.svg",
                      plant: plant,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * 0.65,
              width: size.width * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(63),
                  bottomLeft: Radius.circular(63),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 60,
                    color: kPrimaryColor.withOpacity(0.29),
                  ),
                ],
                image: DecorationImage(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.cover,
                  image: NetworkImage(plant.img),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
