import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rondomchat/PreferenceManager/preference_manager.dart';
import 'package:rondomchat/View/Home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 55,
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(
                  labelText: "username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 55,
              child: TextFormField(
                controller: age,
                decoration: InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (kDebugMode) {
                  print('hello');
                }
                if (username.text.isEmpty) {
                  Get.showSnackbar(const GetSnackBar(
                    title: "Invalid Action",
                    message: "username is required to proceed",
                    duration: Duration(seconds: 2),
                  ));
                } else {
                  Map<String, dynamic> userData = {
                    "username": username.text,
                    "age": age.text,
                  };
                  await PreferenceManager.setUserName(jsonEncode(userData));
                  await PreferenceManager.setAge(age.text);
                  Get.off(() => const HomeScreen());
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
