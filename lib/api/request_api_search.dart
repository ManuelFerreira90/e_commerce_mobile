import 'dart:convert';

import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:flutter/cupertino.dart';

import 'make_request.dart';

class RequestApiSearch{
  static Future<Map<String, dynamic>> getProductsSearchCategory(BuildContext context, String category, int limit, int skip, String sort, String order) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products/category/${category}?limit=$limit&skip=$skip&sortBy=$sort&order=$order',
      {},
    );

    if(response.statusCode == 200){
      Map<String, dynamic> copy = await jsonDecode(response.body);
      return copy;
    }
    else{
      handleAPIError(context, response);
      final Map <String, dynamic> copy = {};
      return copy;
    }
  }

  static Future<Map<String, dynamic>> getAllProductsSearch(BuildContext context, int limit, int skip, String sort, String order) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products?limit=$limit&skip=$skip&sortBy=$sort&order=$order',
      {},
    );

    if(response.statusCode == 200){
      Map <String, dynamic> copy = await jsonDecode(response.body);
      return copy;
    }
    else{
      handleAPIError(context, response);
      final Map<String, dynamic> products= {};
      return products;
    }
  }

  static Future<Map<String, dynamic>> getProductsSearch(BuildContext context, String search, int limit, int skip, String sort, String order) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products/search?q=$search&limit=$limit&skip=$skip&sortBy=$sort&order=$order',
      {},
    );

    if(response.statusCode == 200){
      Map <String, dynamic> copy = await jsonDecode(response.body);
      return copy;
    }
    else{
      handleAPIError(context, response);
      final Map <String, dynamic> productsSearch= {};
      return productsSearch;
    }
  }

}