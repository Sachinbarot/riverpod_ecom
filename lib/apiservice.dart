import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:riverpod_ecom/models/authmodel.dart';
import 'package:riverpod_ecom/models/categoriesmodel.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_ecom/models/userregisterresponsemodel.dart';
import 'package:riverpod_ecom/screens/login.dart';
import 'package:riverpod_ecom/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apiservice {
  Future<bool> isEmailAlreadyRegistered(String email) async {
    var response =
        await http.post(Uri.parse(checkUser), body: {"email": email});
    print(response.statusCode);
    if (response.statusCode == 201 &&
        jsonDecode(response.body)["isAvailable"] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(productlistUrl));
    if (response.statusCode == 200) {
      final List products = jsonDecode(response.body);
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
    print(response.body);
    if (response.statusCode == 201) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", jsonDecode(response.body)["access_token"]);
      authToken = jsonDecode(response.body)["access_token"];
      getUser();
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel> getUser() async {
    var response = await http.get(Uri.parse(userProfile),
        headers: {"Authorization": "Bearer ${authToken}"});
    if (response.statusCode == 200) {
      userId = jsonDecode(response.body)["id"];
      print(response.body);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("token");
      Get.to(() => LoginScreen());
      throw Exception("Failed");
    }
  }

  Future<UserModel> updateUser(String name, String email) async {
    var response = await http.put(Uri.parse(updateProfile),
        body: {"email": email, "name": name},
        headers: {"Authorization": "Bearer ${authToken}"});
    if (response.statusCode == 200) {
      userId = jsonDecode(response.body)["id"];
      print(response.body);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error");
    }
  }

  Future<List<CategoriesModel>> getCategories() async {
    var response = await http.get(Uri.parse(getcategories));
    if (response.statusCode == 200) {
      return List<CategoriesModel>.from(
          jsonDecode(response.body).map((x) => CategoriesModel.fromJson(x)));
    } else {
      throw Exception("Error");
    }
  }

  Future<List<ProductModel>> getCategorywiseFilteredProductsList() async {
    print(categoryId);
    final response = await http
        .get(Uri.parse(productlistUrl + ("/?categoryId=$categoryId")));
    if (response.statusCode == 200) {
      final List products = jsonDecode(response.body);
      //  print(products);
      print("Filterd list:- $products");
      return products.map(((e) => ProductModel.fromJson(e))).toList();
    } else {
      throw Exception("Failed");
    }
  }
}

final productslistProvider = Provider<Apiservice>((ref) => Apiservice());

final authProvider = StateProvider<AuthState>((ref) => AuthState());

final userProvider = Provider<Apiservice>((ref) => Apiservice());

final categorylistProvider = Provider<Apiservice>((ref) => Apiservice());

final productsFilteredByCategoryProvider =
    Provider<Apiservice>((ref) => Apiservice());
