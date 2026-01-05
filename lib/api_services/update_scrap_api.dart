import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:http/http.dart' as http;

class UpdateScrapApi {
  static Future<void> updateScrap(
    dynamic context,
    String subScrapId,
    String scrapRate,
  ) async {
    final url = Uri.parse("${Controller.baseURL}update_scrap.php");

    try {
      final response = await http.post(
        url,
        body: {"subScrapId": subScrapId, "scrapRate": scrapRate},
      );

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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error:${response.statusCode.toString()}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}
