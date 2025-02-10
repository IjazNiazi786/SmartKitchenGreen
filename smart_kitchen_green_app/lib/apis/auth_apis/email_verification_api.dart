import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/auth/verification_model.dart';
import 'package:smart_kitchen_green_app/routes/routes.dart';
import 'package:smart_kitchen_green_app/widgets/flashMessage.dart';

Future<void> verifEmail(EmailVerification model, BuildContext context) async {
  try {
    final response =
        await http.post(Uri.parse(Urls.verifyEmailUrl), body: model.toJson());
    if (response.statusCode < 300) {
      Navigator.pushNamed(context, AppRoutes.loginScreen);
      flashMessage(context, 'success', response.body.toString());
    } else {
      flashMessage(context, 'error', response.body);
      Navigator.pushNamed(context, AppRoutes.signUpScreen);
    }
  } catch (e) {
    flashMessage(context, 'error', e.toString());
    Navigator.pushNamed(context, AppRoutes.signUpScreen);
  }
}
