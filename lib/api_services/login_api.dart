import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:get/get.dart';

class LoginApi {
  static Future<void> checkLogin(
    String email,
    String password,
    dynamic context,
  ) async {
    try {
      var url = Uri.parse("${Controller.baseURL}login.php");

      final response = await http.post(
        url,
        body: {"email": email, "password": password},
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {

        try {
          var data = jsonDecode(response.body);


          if (data["status"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Success: Login Successfully")),
            );
            GetStorage().write("isLoginDealer", true);
            GetStorage().write("emailDealer", email);
            Get.off(() => DealerDashboardScreen());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed: ${data["message"]}")),
            );
          }
        } catch (e) {
          log(e.toString());
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
