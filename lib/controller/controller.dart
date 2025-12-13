import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Controller extends GetxController {
  static const String baseURL = "http://10.155.12.67/scrapsnap_api/dealer/";
  static  String loginEmail = GetStorage().read("emailDealer");


  static Future<List<Map<String, dynamic>>> getShops() async {
    final user = GetStorage().read('dealerEmail');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("dealer")
          .doc(user)
          .collection("shops")
          .get();

      if (snapshot.docs.isEmpty) {
        final shops = snapshot.docs.map((shop) {
          return {
            "shopName": shop["shopName"] ?? "",
            "ownerName": shop["ownerName"] ?? "",
            "phone": shop["phone"] ?? "",
            "email": shop["email"] ?? "",
            "address": shop["address"] ?? "",
            "city": shop["city"] ?? "",
            "pincode": shop["pincode"] ?? "",
          };
        }).toList();
        return shops;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getScrapTypes(
    String shopName,
  ) async {
    final dealerEmail = GetStorage().read("dealerEmail");

    final snapshot = await FirebaseFirestore.instance
        .collection("dealer")
        .doc(dealerEmail)
        .collection("shops")
        .doc(shopName)
        .collection("scraptypes")
        .get();

    // Return list of scrap types
    return snapshot.docs
        .map((doc) => {"id": doc.id, "scrapType": doc["scrapType"]})
        .toList();
  }
}
