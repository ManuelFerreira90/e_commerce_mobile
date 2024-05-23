import 'package:e_commerce_mobile/components/card_carousel.dart';
import 'package:e_commerce_mobile/components/card_carousel_products.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/models/product.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

Future<Response> makePostRequest(String url, String jsonData, Map<String, String> headers) async {
  return await http.post(Uri.parse(url), body: jsonData, headers: headers);
}

Future<Response> makeGetRequest(String url, Map<String, String> headers) async {
  return await http.get(Uri.parse(url), headers: headers);
}

Future<List<dynamic>> getProducts(BuildContext context, String adress) async{
  final response = await makeGetRequest(adress, {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    final List<dynamic> copy = products['products'];
    return copy;

  }else{
    handleAPIError(context, response);
    return [];
  }
}

Future<Map<String, dynamic>> getOneProducts(BuildContext context, String adress) async{
  final response = await makeGetRequest(adress, {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    return products;

  }else{
    handleAPIError(context, response);
    return {};
  }
}

Future<List<dynamic>> getCategoriesApi(BuildContext context) async{
  var url = Uri.https('dummyjson.com', 'products/categories');
  var response = await makeGetRequest(url.toString(), {});

  if(response.statusCode == 200){
    List<dynamic> categories = await jsonDecode(response.body);
    return categories;
  }else{
    handleAPIError(context, response);
    final List<dynamic> categories = [];
    return categories;
  }
}