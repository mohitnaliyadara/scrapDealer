import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:http/http.dart' as http;

class DeleteShopApi {
  static Future<void> deleteShop(String shop_id, dynamic context) async {
    final url = Uri.parse("${Controller.baseURL}delete_shop.php");

    try {
      final response = await http.post(url, body: {"shop_id": shop_id});

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["status"] == "success") {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(json["message"])));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(json["message"])));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
