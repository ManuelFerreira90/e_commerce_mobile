import 'dart:convert';

String prepareRequestBody(Map<String, dynamic> body) {
  return jsonEncode(body);
}
