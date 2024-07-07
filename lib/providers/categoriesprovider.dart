import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/categoriesmodel.dart';

final categoriesProvider = FutureProvider<List<CategoriesModel>>((ref) async {
  return ref.watch(categorylistProvider).getCategories();
});
