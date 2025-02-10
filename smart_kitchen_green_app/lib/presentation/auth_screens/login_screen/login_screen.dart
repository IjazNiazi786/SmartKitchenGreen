import 'package:flutter/material.dart';
import 'package:smart_kitchen_green_app/apis/auth_apis/signin_api.dart';
import 'package:smart_kitchen_green_app/apis/urls/urls.dart';
import 'package:smart_kitchen_green_app/data_layer/auth/auth_model.dart';
import 'package:smart_kitchen_green_app/presentation/auth_screens/verification/verification.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';
import 'package:smart_kitchen_green_app/widgets/custom_drawer.dart';
import '../../../routes/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? emailController;
  TextEditingController? passwordController;
  bool isVisibale = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
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
                      SizedBox(
                        height: 80,
                      ),
                      Image.asset(
                        'assets/logo/circle.png',
                        height: 200.0,
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                label: Text("Email"),
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: _emailValidator,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                label: Text("Password"),
                                prefixIcon: Icon(Icons.password),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisibale = !isVisibale;
                                    });
                                  },
                                  icon: Icon(
                                    isVisibale
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              obscureText: !isVisibale,
                              validator: _passwordValidator,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            Auth model = Auth(
                              email: emailController!.text,
                              password: passwordController!.text,
                            );
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await signInUser(model, context);
                            } catch (e) {
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.login,
                                    size: 25,
                                  ),
                                  Text(
                                    'Login',
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, AppRoutes.signUpScreen);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 16),
                            children: [
                              TextSpan(
                                text: "If You have Not An Account",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(text: "   "),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
