import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controller/controller.dart';
import '../model/ShopListModel.dart';

class GetShopListApi {

  static Future<List<ShopData>> getShopList(String email) async {
    try {
      final url = Uri.parse("${Controller.baseURL}get_shops.php");

      final response = await http.post(url, body: {"email": email});
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["status"] == "success") {
         final json = body["data"] as List;

         final shops = json.map((e) => ShopData.fromJson(e)).toList();
         return shops;
        } else {
          Get.snackbar("Error", body["message"]);
         return [];
        }
      } else {
        Get.snackbar("Error", "${response.statusCode}");
       return [];
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
     return [];
    }
  }
}
