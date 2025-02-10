import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/apis/auth_apis/email_verification_api.dart';
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/auth/verification_model.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/storage/auth_storage.dart';

class UrlConfig extends StatefulWidget {
  const UrlConfig({super.key});

  @override
  State<UrlConfig> createState() => _UrlConfigState();
}

class _UrlConfigState extends State<UrlConfig> {
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void urlSet() {
    Navigator.pushNamed(context, AppRoutes.loginScreen);

    String ipv4 = urlController.text;
    Urls.serverUrl = 'http://${ipv4}:8000';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 80),
                      Image.asset(
                        'assets/logo/circle.png',
                        height: 200.0,
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: urlController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: urlSet,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 25),
                            Text(
                              'Verify',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
