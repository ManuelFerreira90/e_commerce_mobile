import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:e_commerce_mobile/screen/register_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:e_commerce_mobile/utils/prepare_resquest_body.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isNotVisibility = true;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const Text('')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: kPadding,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 100,
              color: Colors.lime,
            ),
            const Text(
                'Login',
                textAlign: TextAlign.center,
                style: kTitleTextStyle,
            ),
            const SizedBox(height: 20,),
            TextFormField(
              controller: _userNameController,
              keyboardType: TextInputType.name,
              style: kFormTextStyle,
              cursorColor: Colors.lime,
              decoration: const InputDecoration(
                labelText: 'User Name',
                labelStyle: kLabelTextStyle,
                border: OutlineInputBorder(),
                focusedBorder: kOutlineInputBorder,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your user name';
                }
                return null;
              },
            ),
            kSpaceHeight,
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: isNotVisibility,
              style: kFormTextStyle,
              cursorColor: Colors.lime,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: kLabelTextStyle,
                border: OutlineInputBorder(),
                focusedBorder: kOutlineInputBorder,
                suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        isNotVisibility = !isNotVisibility;
                      });
                    },
                  icon: isNotVisibility ? const Icon(Icons.visibility, color: Colors.grey,) : const Icon(Icons.visibility_off, color: Colors.grey,),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            kSpaceHeight,
            OvalButton(
                function: (){
                  if (_formKey.currentState!.validate()) {
                    login();
                  }
                },
                text: 'Login',
            ),
            const SizedBox(height: 5,),
            OvalButton(
              function: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RegisterPage()
                ),
              );
            },
              text: 'Register',
            )
          ]
        ),
      ),
    );
  }

  login() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.https('dummyjson.com', 'auth/login');
    Map<String, dynamic> body = {
      'username': _userNameController.text.trim(),
      'password': _passwordController.text.trim(),
      'expiresInMins': 60,
    };

    String jsonData = prepareRequestBody(body);

    var overlayEntry = OverlayEntry(builder: (context) => const LoadingOverlay());
    Overlay.of(context).insert(overlayEntry);
    var response = await makePostRequest(url.toString(), jsonData, { 'Content-Type': 'application/json' });
    overlayEntry.remove();

    if(response.statusCode == 200){
      String token = jsonDecode(response.body)['token'];
      await prefs.setString('token', token);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const CheckPage(),
          ),
      );
    } else {
      handleAPIError(context, response);
    }
  }
}
