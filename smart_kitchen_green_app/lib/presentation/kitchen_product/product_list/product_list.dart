import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting and parsing
import 'package:smart_kitchen_green_app/apis/kitchen_apis/delete_product.dart';
import 'package:smart_kitchen_green_app/apis/kitchen_apis/get_kitche_produtcs.dart';
import 'package:smart_kitchen_green_app/apis/kitchen_apis/update_kitchen_product.dart';
import 'package:smart_kitchen_green_app/data_layer/kitchen/kitchen_product.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/appliance/frezer.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/appliance/oven.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/product_list/image_search.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/recipe/utube.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/theme/theme_helper.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';
import 'package:smart_kitchen_green_app/widgets/custom_drawer.dart';

class KitchenProducts extends StatefulWidget {
  const KitchenProducts({Key? key}) : super(key: key);

  @override
  State<KitchenProducts> createState() => _KitchenProductsState();
}

class _KitchenProductsState extends State<KitchenProducts> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchAndSortProducts();
  }

  Future<List<Product>> fetchAndSortProducts() async {
    List<Product> products = await fetchKitchenProducts(context);
    products.sort((a, b) {
      DateTime aDate = DateFormat('yyyy-MM-dd').parse(a.expiryDate);
      DateTime bDate = DateFormat('yyyy-MM-dd').parse(b.expiryDate);
      return aDate.compareTo(bDate);
    });
    return products;
  }

  double calculateProgress(String expiryDate) {
    DateTime expiry = DateFormat('yyyy-MM-dd').parse(expiryDate);
    DateTime now = DateTime.now();
    int totalDays = expiry.difference(now).inDays;
    int daysPassed = DateTime.now().difference(now).inDays;
    if (totalDays <= 0) return 1.0; // Already expired
    return (daysPassed / totalDays).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addKitchenProduct);
          },
          child: Icon(Icons.add),
        ),
        appBar: appBar(
          "Kitchen Products",
        ),
        drawer: drawer(context),
        resizeToAvoidBottomInset: false,
        body: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Product>? products = snapshot.data;
              if (products != null) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      makeCard(products[index], context),
                );
              } else {
                return Center(child: Text('No Products Available'));
              }
            }
          },
        ),
      ),
    );
  }

  Card makeCard(Product data, BuildContext context) => Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                appTheme.blueGray500C6,
              ],
            ),
          ),
          child: makeListTile(data, context),
        ),
      );
  ListTile makeListTile(Product data, BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        // Expiry date at the top in the center with label
        title: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Expired on:",
                style: TextStyle(color: const Color.fromARGB(255, 205, 17, 17)),
              ),
              Text(
                " ${data.expiryDate}",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(
                      backgroundColor: const Color.fromARGB(255, 2, 101, 5),
                      value: calculateProgress(data.expiryDate),
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                  )),
            ]),
            SizedBox(
              height: 20,
            ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageSearchPage(
                            query: data.name, isFullPage: true)));
                  },
                  child: ImageSearchPage(
                    query: data.name,
                    isFullPage: false,
                  ),
                ),

                // Avatar-shaped image on the left

                SizedBox(width: 30),
                // Title like WhatsApp (Image + Name)
                Expanded(
                  child: Text(
                    data.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                // Edit and Delete Icons on the right
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    _showEditDialog(data);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_forever_sharp, color: Colors.white),
                  onPressed: () async {
                    try {
                      await deleteProduct(context, data.id!);
                      setState(() {
                        _futureProducts = fetchAndSortProducts();
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting product: $e')),
                      );
                    }
                  },
                ),
              ],
            ),
            //
            // Progress bar and expiry date

            SizedBox(
              height: 5,
            ),
            // Text buttons below the main content
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          RecipeRecommender(query: "${data.name}"),
                    ));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.food_bank, color: Colors.white),
                      Text("Recipes", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OvenPage(),
                    ));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.icecream_rounded, color: Colors.white),
                      Text("Put in Oven",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FreezerPage(),
                    ));
                  },
                  child: Column(
                    children: [
                      Icon(Icons.heat_pump_sharp, color: Colors.white),
                      Text("Put in Freezer",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  void _showEditDialog(Product product) {
    final TextEditingController nameController =
        TextEditingController(text: product.name);
    final TextEditingController expiryDateController =
        TextEditingController(text: product.expiryDate);
    final TextEditingController quantity =
        TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: quantity,
                decoration: InputDecoration(labelText: 'Quantity'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: expiryDateController,
                decoration:
                    InputDecoration(labelText: 'Expiry Date (YYYY-MM-DD)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  product.name = nameController.text;
                  product.expiryDate = expiryDateController.text;

                  await updateKitchenProduct(context, product);

                  setState(() {
                    _futureProducts = fetchAndSortProducts();
                  });
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating product: $e')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
