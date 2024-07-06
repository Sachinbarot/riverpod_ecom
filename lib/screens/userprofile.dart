import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/models/userregisterresponsemodel.dart';
import 'package:riverpod_ecom/providers/userprovider.dart';
import 'package:riverpod_ecom/screens/edituser.dart';
import 'package:riverpod_ecom/screens/favourites.dart';
import 'package:riverpod_ecom/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userprofileProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => UpdateUserScreen());
                },
                icon: const Icon(LucideIcons.pen))
          ],
        ),
        body: user.when(
            data: (user) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        user.name,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.role,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                Text(user.email,
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ListTile(
                        onTap: () => Get.to(() => FavouritesScreen()),
                        tileColor: Colors.grey.shade100,
                        leading: Icon(LucideIcons.heart),
                        title: Text("Favourites"),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              backgroundColor: Colors.black,
                              iconColor: Colors.white),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove("token");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Logout Successfully")));
                            Get.to(() => LoginScreen());
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(LucideIcons.log_out)
                            ],
                          ))
                    ],
                  ),
                ),
            error: (e, stackTrace) => Center(
                  child: Text(e.toString()),
                ),
            loading: () => const Center(child: CircularProgressIndicator())));
  }
}
