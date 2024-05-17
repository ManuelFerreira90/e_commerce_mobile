import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void handleAPIError(BuildContext context, Response response) {
  if (response.statusCode >= 400) {
    try {
      var errors = jsonDecode(response.body);
      var message = errors['message'] ?? 'An error occurred.';
      var snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      var snackBar = const SnackBar(content: Text('An error occurred. Please try again later.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
