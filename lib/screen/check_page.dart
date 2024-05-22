import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/home_page.dart';
import 'package:e_commerce_mobile/screen/login_page.dart';
import 'package:e_commerce_mobile/screen/wrap_page.dart';
import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:flutter/material.dart';
import '../components/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  late Map<String, dynamic> perfil;

  @override
  void initState() {
    super.initState();
    verifyUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingOverlay(),
    );
  }

  verifyUserLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if(token != null) {
      getPerfil();
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  getPerfil() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    var url = Uri.https('dummyjson.com', 'auth/me');
    var response = await makeGetRequest(
      url.toString(),
      headers,
    );

    if(response.statusCode == 200){
      perfil = await jsonDecode(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WrapPage(
          userLogged: User(
            id: perfil['id'],
            firstName: perfil['firstName'],
            lastName: perfil['lastName'],
            age: perfil['age'],
            email: perfil['email'],
            phone: perfil['phone'],
            username: perfil['username'],
            password: perfil['password'],
            birthDate: DateTime.parse(perfil['birthDate']),
            image: perfil['image'],
            domain: perfil['domain'],
            address: Address(
              address: perfil['address']['address'],
              city: perfil['address']['city'],
              postalCode: perfil['address']['postalCode'],
              state: perfil['address']['state'],
            ),
            university: perfil['university'],
            bank: Bank(
              cardExpire: perfil['bank']['cardExpire'],
              cardNumber: perfil['bank']['cardNumber'],
              cardType: perfil['bank']['cardType'],
              currency: perfil['bank']['currency'],
            ),
            crypto: Crypto(
              coin: perfil['crypto']['coin'],
              wallet: perfil['crypto']['wallet'],
              network: perfil['crypto']['network'],
            ),
            ssn: perfil['ssn'],
            job: perfil['company']['title'],
          ),
        ),
      )
    );
    }else{
      handleAPIError(context, response);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
