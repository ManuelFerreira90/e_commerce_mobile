import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
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

Future<Map<String, dynamic>> getProductsApi(BuildContext context) async{
  var url = Uri.https('dummyjson.com', 'products');
  var response = await makeGetRequest(url.toString(), {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    final Map<String, dynamic> copy = await ConvertJsonCard.convertJsonCard(products);
    return copy;
  }else{
    handleAPIError(context, response);
    final Map<String, dynamic> copy = {};
    return copy;
  }
}

Future<List<CardCarroselProducts>> getAllProducts(BuildContext context, bool isSale) async{
  var url = Uri.https('dummyjson.com', 'products');
  var response = await makeGetRequest(url.toString(), {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    final List<CardCarroselProducts> copy = await ConvertJsonCard.convertJsonProducts(products, isSale);
    return copy;
  }else{
    handleAPIError(context, response);
    final List<CardCarroselProducts> copy = [];
    return copy;
  }
}

Future<List<CardCarroselProducts>> getProductsCategory(BuildContext context, String category) async{
  var url = Uri.https('dummyjson.com', 'products/category/$category');
  var response = await makeGetRequest(url.toString(), {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    final List<CardCarroselProducts> copy = await ConvertJsonCard.convertJsonProducts(products, false);
    return copy;
  }else{
    handleAPIError(context, response);
    final List<CardCarroselProducts> copy = [];
    return copy;
  }
}

Future<List<CardCarroselProducts>> getSearchProducts(BuildContext context, String search) async{
  final response = await makeGetRequest('https://dummyjson.com/products/search?q=$search', {});

  if(response.statusCode == 200){
    Map <String, dynamic> products = await jsonDecode(response.body);
    final List<CardCarroselProducts> copy = await ConvertJsonCard.convertJsonProducts(products, false);
    return copy;
  }else{
    handleAPIError(context, response);
    final List<CardCarroselProducts> copy = [];
    return copy;
  }
}

Future<List<CardCarrosel>> getCategoriesApi(BuildContext context) async{
  var url = Uri.https('dummyjson.com', 'products/categories');
  var response = await makeGetRequest(url.toString(), {});

  if(response.statusCode == 200){
    List<dynamic> categories = await jsonDecode(response.body);
    final List<CardCarrosel> copy = await ConvertJsonCard.convertJsonCategories(categories);
    return copy;
  }else{
    handleAPIError(context, response);
    final List<CardCarrosel> copy = [];
    return copy;
  }
}