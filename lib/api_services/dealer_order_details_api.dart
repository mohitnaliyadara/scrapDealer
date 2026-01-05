import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

class DealerOrderDetailsApi {
  static Future<Map<String, dynamic>> getDetails(int orderId) async {
    final res = await http.get(
      Uri.parse("${Controller.baseURL}dealer_order_details.php?order_id=$orderId"),
    );
    return jsonDecode(res.body);
  }
}
