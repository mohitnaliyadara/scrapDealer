import 'package:flutter/material.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:http/http.dart' as http;
class DeleteScrapTypeApi {
  static Future<void> deleteScrapType(String scrapTypeId, dynamic context)async{

    final url = Uri.parse("${Controller.baseURL}delete_scrap_type");

    try{

      final response = await http.post(url,body: {
        "scrapTypeId":scrapTypeId
      });
      if(response.statusCode ==200){

      }
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }
}