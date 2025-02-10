import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';
import 'package:smart_kitchen_green_app/theme/theme_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkUser() {
    Future.delayed(const Duration(seconds: 4), () async {
      String? token = await getToken();

      if (token == null) {
        Navigator.pushNamed(context, AppRoutes.loginScreen);
      } else {
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showEditDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray100,
            body: Center(
              child: Image.asset(
                "assets/logo/logo-gif1.gif",
                height: 125.0,
                width: 125.0,
              ),
            )));
  }

  void _showEditDialog() {
    final TextEditingController url = TextEditingController();

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
                controller: url,
                decoration: InputDecoration(
                    labelText: 'ipv4 Address', hintText: "192.168.1.1"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  String ipv4 = url.text;
                  Urls.serverUrl = 'http://${ipv4}:8000';

                  Navigator.of(context).pop();
                  checkUser();
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
