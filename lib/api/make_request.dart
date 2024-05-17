import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future<Response> makePostRequest(String url, String jsonData, Map<String, String> headers) async {
  return await http.post(Uri.parse(url), body: jsonData, headers: headers);
}

Future<Response> makeGetRequest(String url, Map<String, String> headers) async {
  return await http.get(Uri.parse(url), headers: headers);
}
