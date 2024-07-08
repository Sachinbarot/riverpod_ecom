import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:riverpod_ecom/apiservice.dart';
import 'package:riverpod_ecom/providers/userprovider.dart';

class UpdateUserScreen extends ConsumerWidget {
  UpdateUserScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userprofileProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update User'),
        ),
        body: user.when(
          data: (user) => Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController..text = user.name,
                      decoration: InputDecoration(label: Text("Name")),
                      onChanged: (value) {
                        user.name = value;
                      },
                    ),
                    TextFormField(
                      controller: _emailController..text = user.email,
                      decoration: InputDecoration(label: Text("Email")),
                      // initialValue: user.email,
                      onChanged: (value) {
                        user.email = value;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Apiservice apiservice = Apiservice();
                          apiservice
                              .updateUser(
                                  _nameController.text, _emailController.text)
                              .whenComplete(() {
                            Get.back();
                            ref.refresh(userprofileProvider);
                          });
                        },
                        child: Text("Update User"))
                  ],
                )),
          ),
          error: (e, stackTrace) => Center(
            child: Text(e.toString()),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ));
  }
}
