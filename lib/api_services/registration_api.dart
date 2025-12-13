import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

import '../screens/sign_in_screens/login_screen.dart';

class RegistrationApi {

  // registration API
  static Future<void> addDealer(
      String username,
      String email,
      String phone,
      String password,
      BuildContext context,
      ) async {
    try {
      var url = Uri.parse("${Controller.baseURL}registration.php");
      // 1. CHANGE: Use POST instead of GET
      var response = await http.post(
        url,
        // 2. CHANGE: Uncomment the body so data is sent
        body: {
          "username": username,
          "email": email,
          "phone": phone,
          "password": password,
        },
      );
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);

          if (data["status"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Success: Registration Successfully"),
              ),
            );
            Future.delayed(Duration(seconds: 2), () {
              Get.off(() => LoginScreen());
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed: ${data["message"]}")),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Server Response")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Connection Error: $e")));
      }
    }
  }
}