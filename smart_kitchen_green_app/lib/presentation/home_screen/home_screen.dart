import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';
import 'package:smart_kitchen_green_app/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context),
      appBar: appBar("Home Screen"),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.asset(
            "assets/logo/logo1.png",
            height: 150.0,
            width: 150.0,
          ),
          Text("WELCOME BACK TO DEVELOPEMENT......",
              style: TextStyle(color: Colors.red)),
          SizedBox(height: 20),
          SizedBox(height: 10),
          Text(
            '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(15),
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
              crossAxisCount: 2, // Number of columns
              children: [
                _buildFeatureCard(
                    icon: Icons.inventory,
                    title: 'Integrated Grocery Assistant',
                    description: "",
                    route: AppRoutes.kitchenProducts,
                    context: context),
                _buildFeatureCard(
                    icon: Icons.notifications,
                    title: 'Expiry Date Notifications',
                    description: '',
                    context: context),
                _buildFeatureCard(
                    icon: Icons.kitchen,
                    title: 'Kitchen Appliance Connectivity',
                    description: '',
                    route: AppRoutes.freezer,
                    context: context),
                _buildFeatureCard(
                    icon: Icons.receipt,
                    title: 'Recipe Recommender',
                    description: '',
                    route: AppRoutes.recipe,
                    context: context),
                _buildFeatureCard(
                    icon: Icons.nature,
                    title: 'Vegetable Garden Planning',
                    description: '',
                    context: context),
                _buildFeatureCard(
                    icon: Icons.calendar_today,
                    title: 'Digital Care Calendar',
                    description: '',
                    context: context),
                _buildFeatureCard(
                    icon: Icons.info,
                    title: 'Plant Care Information',
                    description: '',
                    context: context),
                _buildFeatureCard(
                    icon: Icons.recommend,
                    title: 'Plant Recommendation',
                    description: '',
                    context: context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      {required IconData icon,
      required String title,
      required String description,
      String route = AppRoutes.kitchenProducts,
      required BuildContext context}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green[700]),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
