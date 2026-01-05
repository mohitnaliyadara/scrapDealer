import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scrapdealer/controller/controller.dart';

class DealerProfileApi {
  static Future<Map<String, dynamic>?> getProfile(String dealerEmail) async {
    final res = await http.get(
      Uri.parse(
        "${Controller.baseURL}get_dealer_profile.php?dealer_email=$dealerEmail",
      ),
    );

    final json = jsonDecode(res.body);

    if (json["status"] == "success") {
      return Map<String, dynamic>.from(json["data"]);
    }
    return null;
  }
}
