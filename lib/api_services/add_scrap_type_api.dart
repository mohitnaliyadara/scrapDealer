import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../controller/controller.dart';
import 'package:http/http.dart' as http;

class AddScrapTypeApi {
  static Future<void> addScrapType(
    String scrapCategoryId,
    String scrapName,
    String scrapRate,
    String shopId,
    dynamic context,
  ) async {
    final url = Uri.parse("${Controller.baseURL}add_scrap_type.php");

    try {
      final response = await http.post(
        url,
        body: {
          "scrapCategoryId": scrapCategoryId,
          "scrapName": scrapName,
          "scrapRate": scrapRate,
          "shopId": shopId,
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        log(json.toString());
      } else {
        log(response.statusCode.toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
