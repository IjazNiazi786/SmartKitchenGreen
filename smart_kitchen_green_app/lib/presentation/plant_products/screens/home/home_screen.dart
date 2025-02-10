import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/components/my_bottom_nav_bar.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/screens/home/components/body.dart';
import 'package:smart_kitchen_green_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: buildAppBar(),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/plants/icons/menu.svg"),
        onPressed: () {},
      ),
    );
  }
}
