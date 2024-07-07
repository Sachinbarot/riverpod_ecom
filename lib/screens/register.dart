import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:get/route_manager.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/userregisterresponsemodel.dart';
import 'package:riverpod_ecom/screens/login.dart';
import 'package:riverpod_ecom/utils/constants.dart';
import 'package:riverpod_ecom/widgets/formwidgets.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Apiservice apiservice = Apiservice();
  final _formKey = GlobalKey<FormState>();

  Future<UserModel> _registerUser() async {
    final response = await http.post(Uri.parse(registerUrl), body: {
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "avatar": "https://picsum.photos/800",
    });
    print(response.body);
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User Created Successfully")));
      Get.to(() => LoginScreen());
      return UserModelFromJson(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome, Onboard!",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6.0,
              ),
              const Text("Glad to see you here"),
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
                          labelText: "Name",
                          validator: (p0) =>
                              p0!.isEmpty ? "Name is required" : null,
                          obscureText: false,
                          hintText: "John  Doe",
                          prefixIcon: LucideIcons.user_round,
                          controller: _nameController),
                      CustomFormFiled(
                          validator: (value) =>
                              value!.isEmpty ? "Email is required" : null,
                          labelText: "Email",
                          obscureText: false,
                          hintText: "John@gmail.com",
                          prefixIcon: LucideIcons.mail,
                          controller: _emailController),
                      CustomFormFiled(
                          labelText: "Password",
                          validator: (value) => value!.isEmpty
                              ? "Password can not be empty"
                              : value.length < 4
                                  ? "Password must be more than 4 character"
                                  : null,
                          obscureText: true,
                          hintText: ".......",
                          prefixIcon: LucideIcons.mail,
                          controller: _passwordController),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: Colors.black),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              apiservice
                                  .isEmailAlreadyRegistered(
                                      _emailController.text)
                                  .then((value) {
                                if (value) {
                                  Get.snackbar("Email already available",
                                      "Oops! Emails is already registered, Try with different");
                                } else {
                                  _registerUser();
                                }
                              });
                            }
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
                          Text("Already have an account? "),
                          InkWell(
                            child: Text("Login"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
