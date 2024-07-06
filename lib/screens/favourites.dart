import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:riverpod_ecom/models/favouritesmodel.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/screens/productdetails.dart';
import 'package:riverpod_ecom/utils/constants.dart';
import 'package:sqflite/sqflite.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  Future<List<Favouritesmodel>> favourites() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'favourites_database.db'),
    );
    final db = await database;

    final List<Map<String, Object?>> favouritesMap =
        await db.query('favourites WHERE userId == $userId');
    return [
      for (final {
            'id': id as int,
            'userId': userId as int,
            'productId': productId as int,
            'title': title as String,
            'price': price as int,
            'description': description as String,
            'images': images as List<String>,
          } in favouritesMap)
        Favouritesmodel(
            id: id,
            userId: userId,
            productId: productId,
            title: title,
            price: price,
            description: description,
            images: images),
    ];
  }

  @override
  Widget build(BuildContext context, ref) {
    const favproducts = Favouritesmodel;
    return Scaffold(
        appBar: AppBar(
          title: Text("My Favourites"),
          actions: [
            IconButton(
                onPressed: () async {
                  final database = openDatabase(
                    join(await getDatabasesPath(), 'favourites_database.db'),
                  );
                  final db = await database;
                  await db.delete('favourites');
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: FutureBuilder<List<Favouritesmodel>>(
          future: favourites(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No Favourites"));
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => Get.to(() => ProductdetailsScreen(
                            product: ProductModel(
                          id: snapshot.data![index].productId,
                          title: snapshot.data![index].title,
                          price: snapshot.data![index].price,
                          images: [
                            "https://api.lorem.space/image/face?w=640&h=480&r=867"
                          ],
                          description: snapshot.data![index].description,
                        ))),
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].price.toString()),
                  );
                });
          },
        ));
  }
}
