import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/categoriesmodel.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/providers/categoriesprovider.dart';
import 'package:riverpod_ecom/providers/productsprovider.dart';
import 'package:riverpod_ecom/providers/userprovider.dart';
import 'package:riverpod_ecom/screens/productdetails.dart';
import 'package:riverpod_ecom/screens/userprofile.dart';
import 'package:riverpod_ecom/utils/constants.dart';

class ProductlistScreen extends ConsumerWidget {
  ProductlistScreen({super.key});

  // var categoryId;

  var isFiltering = false;
  TextEditingController minCont = TextEditingController();
  TextEditingController maxCont = TextEditingController();
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context, ref) {
    final isFilteringProvider = StateProvider<bool>((ref) => false);
    final categories = ref.watch(categoriesProvider);
    final products = ref.watch(producstProvider);
    final filtProducts = ref.watch(filteredproducstProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => UserProfileScreen());
              },
              icon: Icon(LucideIcons.user_round),
            ),
            IconButton(
                onPressed: () {
                  print(isFiltering);
                  Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
                    return Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  isFiltering
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.shade50),
                                          onPressed: () {
                                            isFiltering = false;
                                            ref.refresh(producstProvider);
                                            Get.back();
                                          },
                                          child: Text("Clear Filters X"))
                                      : Container()
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "By categories",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              categories.when(
                                  data: (categories) => Container(
                                        height: 70,
                                        child: ListView.builder(
                                          itemCount: categories.length,
                                          scrollDirection: Axis.horizontal,
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          primary: true,
                                          itemBuilder: (context, index) {
                                            List<CategoriesModel> category =
                                                categories
                                                    .map(
                                                      (e) => e,
                                                    )
                                                    .toList();
                                            return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      filterType = "byCategory";
                                                      categoryId =
                                                          category[index].id;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      // shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          category[index].name),
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                  error: (e, stackTrace) => Center(
                                        child: Text(e.toString()),
                                      ),
                                  loading: () => Center(
                                        child: CircularProgressIndicator(),
                                      )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "By Range",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                    fontSize: 14),
                              ),
                              RangeSlider(
                                  //min: 100,
                                  labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString()),
                                  max: 10000,
                                  divisions: 10000,
                                  values: _currentRangeValues,
                                  onChanged: (value) {
                                    filterType = "byRange";
                                    setState(
                                      () {
                                        _currentRangeValues = value;
                                      },
                                    );
                                    minPrice = value.start;
                                    maxPrice = value.end;
                                  }),
                              Text(
                                "By Custom Price",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: TextFormField(
                                      controller: minCont,
                                      onChanged: (value) {
                                        minPrice = int.parse(value);
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Min Price",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.2,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        maxPrice = int.parse(value);
                                      },
                                      controller: maxCont,
                                      decoration: InputDecoration(
                                          hintText: "Max Price",
                                          border: OutlineInputBorder()),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      minCont.text.isNotEmpty &&
                                              maxCont.text.isNotEmpty
                                          ? filterType = "byRange"
                                          : minCont.text.isNotEmpty &&
                                                  maxCont.text.isEmpty
                                              ? filterType = "byMinPrice"
                                              : maxCont.text.isNotEmpty &&
                                                      minCont.text.isEmpty
                                                  ? filterType = "byMaxPrice"
                                                  : null;

                                      ref
                                          .read(isFilteringProvider.notifier)
                                          .update((state) => state = true);
                                      // ref
                                      //         .read(isFilteringProvider.notifier)
                                      //         .state =
                                      //     ref
                                      //         .read(isFilteringProvider.notifier)
                                      //         .state = true;
                                      // print(ref
                                      //     .read(isFilteringProvider.notifier)
                                      //     .state);

                                      //  ref.refresh(isFilteringProvider);
                                      isFiltering = true;
                                      ref.refresh(filteredproducstProvider);
                                      Get.back();
                                    },
                                    child: Text("Apply Filters")),
                              )
                            ]),
                      ),
                    );
                  }));
                },
                icon: Icon(LucideIcons.filter))
          ],
        ),
        body: isFiltering
            ? filtProducts.when(
                data: (filtProducts) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: filtProducts.length,
                          itemBuilder: (context, index) {
                            List<ProductModel> product =
                                filtProducts.map((e) => e).toList();
                            return InkWell(
                              onTap: () {
                                print(product[index].images[0]);
                                Get.to(() => ProductdetailsScreen(
                                    product: product[index]));
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
                                                      product[index]
                                                          .images[0]
                                                          .toString()),
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
                                              "${product[index].title}",
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
                                              style: TextStyle(
                                                  color: Colors.black54),
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
                    Center(child: CircularProgressIndicator.adaptive()))
            : products.when(
                data: (products) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            List<ProductModel> product =
                                products.map((e) => e).toList();
                            return InkWell(
                              onTap: () {
                                print(product[index].images[0]);
                                Get.to(() => ProductdetailsScreen(
                                    product: product[index]));
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
                                                      product[index]
                                                          .images[0]
                                                          .toString()),
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
                                              style: TextStyle(
                                                  color: Colors.black54),
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
