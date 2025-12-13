import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:scrapdealer/model/ShopListModel.dart';
import 'package:http/http.dart' as http;

import '../controller/controller.dart';

class UpdateShopApi {
  static Future<void> updateShop(ShopData shop, dynamic context) async {
    try {
      final url = Uri.parse("${Controller.baseURL}update_shop.php");
      final response = await http.post(url, body: shop.toJson());
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
      log(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
