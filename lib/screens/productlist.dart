import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/providers/productsprovider.dart';
import 'package:riverpod_ecom/screens/productdetails.dart';
import 'package:riverpod_ecom/screens/userprofile.dart';
import 'package:riverpod_ecom/utils/constants.dart';

class ProductlistScreen extends ConsumerWidget {
  const ProductlistScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final products = ref.watch(producstProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => UserProfileScreen());
              },
              icon: Icon(LucideIcons.user_round),
            )
          ],
        ),
        body: products.when(
            data: (products) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        List<ProductModel> product =
                            products.map((e) => e).toList();
                        return InkWell(
                          onTap: () {
                            Get.to(() =>
                                ProductdetailsScreen(product: product[index]));
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  product[index].images[0]),
                                              fit: BoxFit.fill,
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              //   fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 18.0),
                                        ),
                                        const SizedBox(
                                          height: 6.0,
                                        ),
                                        Text(
                                          textAlign: TextAlign.start,
                                          product[index].description,
                                          maxLines: 2,
                                          style:
                                              TextStyle(color: Colors.black54),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(
                                          height: 6.0,
                                        ),
                                        Text(
                                          "₹${product[index].price.toString()}/-",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
            error: (err, stackTrace) => Text(err.toString()),
            loading: () =>
                Center(child: CircularProgressIndicator.adaptive())));
  }
}
