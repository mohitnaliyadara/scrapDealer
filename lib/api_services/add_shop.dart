import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

class AddShopApi {

  static Future<void> addShop({
    required String shopname,
    required String ownername,
    required String phone,
    required String email,
    required String address,
    required String city,
    required String pincode,
    required BuildContext context,
  }) async {
    try {
      var url = Uri.parse("${Controller.baseURL}add_shop.php");

      var response = await http.post(
        url,
        body: {
          "shopname": shopname,
          "ownername": ownername,
          "phone": phone,
          "email": email,
          "address": address,
          "city": city,
          "pincode": pincode,
        },
      );

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data["status"] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Shop Added Successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed: ${data["message"]}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection Error: $e")),
        );
      }
    }
  }
}
