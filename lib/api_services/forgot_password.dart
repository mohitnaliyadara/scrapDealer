import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

import '../screens/sign_in_screens/login_screen.dart';
import '../screens/sign_in_screens/new_password.dart';

class ForgotPasswordApi {
  static void forgotPassword(String email, String phone, dynamic context) async {

    try {
      var url = Uri.parse("${Controller.baseURL}forgot_password.php");

      final response = await http.post(url, body: {"email": email, "phone":phone});
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);

          if (data["status"] == "success") {

            Get.off(()=>NewPassword(email: email,));
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
      }
      else {
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

  static void newPassword(String password, String email, dynamic context) async{

    try {
      var url = Uri.parse("${Controller.baseURL}new_password.php");

      final response = await http.post(url, body: { "password":password, "email":email});
      if (!context.mounted) return;
      if (response.statusCode == 200) {
        try {
          var data = jsonDecode(response.body);

          if (data["status"] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated successfully")));
            Get.off(()=>LoginScreen());
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
      }
      else {
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
