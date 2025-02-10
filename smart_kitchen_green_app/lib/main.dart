import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:smart_kitchen_green_app/data_layer/providers/plants_record_provider.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/theme/theme_helper.dart';

void main() async {
  // await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RecordProvider(),
        child: MaterialApp(
          title: "Smart Kitchen Green",
          debugShowCheckedModeBanner: false,
          theme: theme,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splashScreen,
        ));
  }
}
