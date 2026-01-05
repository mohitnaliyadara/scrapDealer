import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Controller extends GetxController {
  static const String baseURL = "http://10.123.18.67/scrapsnap_api/dealer/";
  static  String loginEmail = GetStorage().read("emailDealer");

}
