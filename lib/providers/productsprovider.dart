import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/productmodel.dart';
import 'package:riverpod_ecom/utils/constants.dart';

final producstProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productslistProvider).getProducts();
});

final filtbycategproducstProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final products = ref.watch(producstProvider).asData!.value;
  print(products.first.title);
  print(
      products.where((product) => product.category!.id == categoryId).toList());
  return products
      .where((product) => product.category!.id == categoryId)
      .toList();
});

final filteredproducstProvider =
    FutureProvider<List<ProductModel>>((ref) async {
  final products = ref.watch(producstProvider).asData!.value;
  if (filterType == "byCategory") {
    return products
        .where((product) => product.category!.id == categoryId)
        .toList();
  }
  if (filterType == "byRange") {
    return products
        .where(
            (product) => product.price > minPrice && product.price < maxPrice)
        .toList();
  }
  if (filterType == "byMinPrice") {
    return products.where((product) => product.price > minPrice).toList();
  }
  if (filterType == "byMaxPrice") {
    return products.where((product) => product.price < maxPrice).toList();
  }
  return products.toList();
});
