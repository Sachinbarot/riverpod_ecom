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
  print(categoryId);
  return products
      .where((product) => product.category!.id == categoryId)
      .toList();
});
