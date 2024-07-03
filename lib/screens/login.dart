import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/screens/productlist.dart';
import 'package:riverpod_ecom/screens/register.dart';
import 'package:riverpod_ecom/utils/constants.dart';

import 'package:riverpod_ecom/widgets/formwidgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome, Back!",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6.0,
              ),
              const Text("Glad to see you back, sign in to explore!"),
              const SizedBox(
                height: 20.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      CustomFormFiled(
                          labelText: "Email",
                          obscureText: false,
                          hintText: "John@gmail.com",
                          prefixIcon: LucideIcons.mail,
                          controller: _emailController),
                      CustomFormFiled(
                          labelText: "Password",
                          obscureText: true,
                          hintText: ".......",
                          prefixIcon: LucideIcons.mail,
                          controller: _passwordController),
                      const SizedBox(
                        height: 10.0,
                      ),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  backgroundColor: Colors.black),
                              onPressed: () async {
                                //bool isLoggedin = await authProvider
                                setState(() {
                                  isLoading = true;
                                  print(isLoading);
                                });
                                Apiservice apiservice = Apiservice();
                                apiservice
                                    .loginUser(_emailController.text,
                                        _passwordController.text)
                                    .then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Successfully LoggedIn")));
                                    Get.to(() => const ProductlistScreen());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text("Try Again!")));
                                  }
                                });
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Submit",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Icon(
                                    LucideIcons.move_right,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          InkWell(
                            child: const Text("Register"),
                            onTap: () {
                              Get.to(() => const RegisterScreen());
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
