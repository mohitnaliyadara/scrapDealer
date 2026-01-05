import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

class UpdateOrderStatusApi {
  static Future<void> update(int orderId, String status) async {
    await http.post(
      Uri.parse("${Controller.baseURL}update_order_status.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": orderId,
        "order_status": status,
      }),
    );
  }
}
