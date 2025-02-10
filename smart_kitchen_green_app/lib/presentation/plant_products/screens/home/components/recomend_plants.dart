import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_kitchen_green_app/apis/plant_apis/recommended_plants.dart';
import 'package:smart_kitchen_green_app/data_layer/plants/plant.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/screens/details/details_screen.dart';

import '../../../constants.dart';

class RecomendPlants extends StatefulWidget {
  const RecomendPlants({super.key});

  @override
  State<RecomendPlants> createState() => _RecomendPlantsState();
}

class _RecomendPlantsState extends State<RecomendPlants> {
  List<Plant> plants = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  void fetchPlants() async {
    try {
      plants = await fetchRecomendations(context, "False");
    } catch (e) {
      print("Error fetching plants: $e");
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(), // Show loader when fetching
          )
        : Column(
            children: [
              MasonryGridView.count(
                crossAxisCount: 2, // 2 items horizontally
                itemCount: plants.length,
                shrinkWrap: true, // Adjusts the height based on content
                physics:
                    NeverScrollableScrollPhysics(), // Disable internal scroll if needed
                itemBuilder: (context, index) => RecomendPlantCard(
                  image: plants[index].img,
                  title: plants[index].name,
                  category: plants[index].category,
                  plant: plants[index],
                ),
                // staggeredTileBuilder: (index) => StaggeredTile.fit(1), // Adjusts height based on content
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () => () {},
                child: Text(
                  "More",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
  }
}

class RecomendPlantCard extends StatelessWidget {
  final String image, title;
  final String category;
  final Plant plant;

  const RecomendPlantCard({
    required this.image,
    required this.title,
    required this.category,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          // left: kDefaultPadding,
          top: kDefaultPadding / 2,
          bottom: kDefaultPadding * 0.5,
        ),
        width: size.width * 0.4,
        height: 300,
        child: Column(
          children: <Widget>[
            // Fixed size for the image
            Container(
              width: 170, // Set the desired width
              height: 200, // Set the desired height
              child: image.startsWith('http')
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      plant: plant,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(kDefaultPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: "$category",
                            style: TextStyle(
                              color: kPrimaryColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailsScreen(
            plant: plant,
          ),
        ));
      },
    );
  }
}
