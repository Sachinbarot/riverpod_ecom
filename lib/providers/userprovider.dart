import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/userregisterresponsemodel.dart';

final userprofileProvider = FutureProvider<UserModel>((ref) async {
  return ref.watch(userProvider).getUser();
});
