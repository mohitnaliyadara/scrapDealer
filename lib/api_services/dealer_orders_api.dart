import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

class DealerOrdersApi {
  static Future<List<Map<String, dynamic>>> getOrders(int shopId) async {
    final res = await http.get(
      Uri.parse("${Controller.baseURL}dealer_get_orders.php?shop_id=$shopId"),
    );

    final json = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(json["data"]);
  }
}
