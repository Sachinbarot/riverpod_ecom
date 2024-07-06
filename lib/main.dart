import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/providers/productsprovider.dart';
import 'package:riverpod_ecom/screens/login.dart';
import 'package:riverpod_ecom/screens/productdetails.dart';
import 'package:riverpod_ecom/screens/productlist.dart';
import 'package:riverpod_ecom/screens/register.dart';
import 'package:riverpod_ecom/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      authToken = prefs.getString("token");
      Apiservice apiservice = Apiservice();
      apiservice.getUser();
      userId = prefs.getString("userId");
    });
    print("authToken $authToken");
  }

  @override
  void initState() {
    getAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.outfitTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authToken != null ? const ProductlistScreen() : LoginScreen(),
    );
  }
}
