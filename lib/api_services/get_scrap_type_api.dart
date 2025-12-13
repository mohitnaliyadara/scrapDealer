import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/model/sub_category_model.dart';

class GetScrapTypeApi {
  static Future<List<SubCategoryData>> getScrapType(
    dynamic context,
    String shopId,
  ) async {
    final url = Uri.parse("${Controller.baseURL}get_scrap_type.php");

    try {
      final response = await http.post(url, body: {"shopId": shopId});
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json["subCategoryData"] as List;
        final subCategory = data
            .map((e) => SubCategoryData.fromJson(e))
            .toList();
        return subCategory;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
        return [];
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error:${e.toString()}")));
      return [];
    }
  }
}
