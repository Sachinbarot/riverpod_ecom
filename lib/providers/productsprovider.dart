import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/productmodel.dart';

final producstProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productslistProvider).getProducts();
});
