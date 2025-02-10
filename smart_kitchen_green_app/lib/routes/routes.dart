import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/presentation/home_screen/home_screen.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/add_product/add_product.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/appliance/frezer.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/product_list/product_list.dart';
import 'package:smart_kitchen_green_app/presentation/auth_screens/login_screen/login_screen.dart';
import 'package:smart_kitchen_green_app/presentation/auth_screens/signup_screen/signup_screen.dart';
import 'package:smart_kitchen_green_app/presentation/kitchen_product/recipe/utube.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/init_plant.dart';
import 'package:smart_kitchen_green_app/presentation/plant_products/my_crops/my_crops.dart';
import 'package:smart_kitchen_green_app/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const splashScreen = "/";
  static const homeScreen = "/home";
  static const loginScreen = "/login";
  static const signUpScreen = "/signup";
  static const addKitchenProduct = "/addkitchenProduct";
  static const kitchenProducts = '/kicthenProducts';
  static const freezer = "/freezer";
  static const recipe = "/recipe";
  static const mycrops = "/mycrops";

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => SplashScreen(),
    homeScreen: (context) => HomeScreen(),
    loginScreen: (context) => LoginScreen(),
    signUpScreen: (context) => SignupScreen(),
    addKitchenProduct: (context) => AddProduct(),
    kitchenProducts: (context) => KitchenProducts(),
    freezer: (context) => FreezerPage(),
    mycrops: (context) => PlantApp(),
  };
}
