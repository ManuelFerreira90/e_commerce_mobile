import 'dart:convert';

import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:flutter/cupertino.dart';

import 'make_request.dart';

class RequestApiSearch{
  static Future<List<dynamic>> getProductsSearchCategory(BuildContext context, String category, int limit, int skip) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products/category/${category}?limit=$limit&skip=$skip',
      {},
    );

    if(response.statusCode == 200){
      Map<String, dynamic> copy = await jsonDecode(response.body);
      final List<dynamic> productsCategory = copy['products'];
      return productsCategory;
    }
    else{
      handleAPIError(context, response);
      final List<dynamic> productsCategory = [];
      return productsCategory;
    }
  }

  static Future<List<dynamic>> getAllProductsSearch(BuildContext context, int limit, int skip) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products?limit=$limit&skip=$skip',
      {},
    );

    if(response.statusCode == 200){
      Map<String, dynamic> copy = await jsonDecode(response.body);
      final List<dynamic> products= copy['products'];
      return products;
    }
    else{
      handleAPIError(context, response);
      final List<dynamic> products= [];
      return products;
    }
  }

  static Future<List<dynamic>> getProductsSearch(BuildContext context, String search, int limit, int skip) async{
    var response = await makeGetRequest(
      'https://dummyjson.com/products/search?q=$search&limit=$limit&skip=$skip',
      {},
    );

    if(response.statusCode == 200){
      Map<String, dynamic> copy = await jsonDecode(response.body);
      final List<dynamic> productsSearch = copy['products'];
      return productsSearch;
    }
    else{
      handleAPIError(context, response);
      final List<dynamic> productsSearch= [];
      return productsSearch;
    }
  }

}