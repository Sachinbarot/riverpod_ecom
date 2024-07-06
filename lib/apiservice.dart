import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:riverpod_ecom/models/authmodel.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_ecom/models/userregisterresponsemodel.dart';
import 'package:riverpod_ecom/screens/login.dart';
import 'package:riverpod_ecom/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apiservice {
  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(productlistUrl));
    if (response.statusCode == 200) {
      final List products = jsonDecode(response.body);
      print(products);
      print(products);
      return products.map(((e) => ProductModel.fromJson(e))).toList();
    } else {
      throw Exception("Failed");
    }
  }

  Future<bool> loginUser(String email, String password) async {
    final response = await http.post(Uri.parse(loginUrl), body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", jsonDecode(response.body)["access_token"]);
      prefs.setString("userId", jsonDecode(response.body)["id"]);
      userId = jsonDecode(response.body)["id"];
      authToken = jsonDecode(response.body)["access_token"];

      return true;
    } else {
      return false;
    }
  }

  Future<UserModel> getUser() async {
    var response = await http.get(Uri.parse(userProfile),
        headers: {"Authorization": "Bearer ${authToken}"});
    if (response.statusCode == 200) {
      print(response.body);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      Get.to(() => LoginScreen());
      throw Exception("Failed");
    }
  }
}

final productslistProvider = Provider<Apiservice>((ref) => Apiservice());

final authProvider = StateProvider<AuthState>((ref) => AuthState());

final userProvider = Provider<Apiservice>((ref) => Apiservice());
