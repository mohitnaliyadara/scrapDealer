import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrapdealer/model/scrap_category_model.dart';

import '../controller/controller.dart';
import 'package:http/http.dart' as http;

class GetScrapCategoryApi {
  static Future<List<ScrapCategory>> getScrapCategory(dynamic context) async {
    final url = Uri.parse("${Controller.baseURL}get_scrap_category.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json["status"] == "success") {
          final data = json["scrapcategory"] as List;
          final category = data.map((e) => ScrapCategory.fromJson(e)).toList();
          return category;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${json["message"]}")));
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Status code: ${response.statusCode.toString()}"),
          ),
        );
        return [];
      }
    } catch (e) {
      log(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      return [];
    }
  }
}
