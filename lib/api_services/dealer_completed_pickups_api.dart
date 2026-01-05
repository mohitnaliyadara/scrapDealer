import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:scrapdealer/controller/controller.dart';

class DealerCompletedPickupsApi {
  static Future<List<Map<String, dynamic>>> getCompletedPickups(
      int shopId,
      ) async {
    final res = await http.get(
      Uri.parse(
        "${Controller.baseURL}dealer_completed_pickups.php?shop_id=$shopId",
      ),
    );

    final json = jsonDecode(res.body);

    if (json["status"] == "success") {
      return List<Map<String, dynamic>>.from(json["data"]);
    }
    return [];
  }
}
