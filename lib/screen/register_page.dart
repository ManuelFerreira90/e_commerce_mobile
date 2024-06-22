import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/main.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/wrap_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:e_commerce_mobile/utils/prepare_resquest_body.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:email_validator/email_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isNotVisibility = true;
  bool isNotVisibility2 = true;
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _userNameController;
  final _formKey = GlobalKey<FormState>();
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController(text: '+55');
    _userNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: kPadding,
                children: [
                  const Text('Register',
                      textAlign: TextAlign.center, style: kTitleTextStyle),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          style: kFormTextStyle,
                          cursorColor: Colors.lime,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: kLabelTextStyle,
                            border: OutlineInputBorder(),
                            focusedBorder: kOutlineInputBorder,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ),
                      kSpaceWidth,
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          keyboardType: TextInputType.name,
                          style: kFormTextStyle,
                          cursorColor: Colors.lime,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: kLabelTextStyle,
                            border: OutlineInputBorder(),
                            focusedBorder: kOutlineInputBorder,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  kSpaceHeight,
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
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    style: kFormTextStyle,
                    cursorColor: Colors.lime,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: kLabelTextStyle,
                      border: OutlineInputBorder(),
                      focusedBorder: kOutlineInputBorder,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else {
                        final phoneNumber =
                            PhoneNumber.parse(_phoneNumberController.text);
                        final valid = phoneNumber.isValid();
                        if (!valid) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      }
                    },
                  ),
                  kSpaceHeight,
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: kFormTextStyle,
                    cursorColor: Colors.lime,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: kLabelTextStyle,
                      border: OutlineInputBorder(),
                      focusedBorder: kOutlineInputBorder,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else {
                        final String email = _emailController.text.trim();
                        final bool isValid = EmailValidator.validate(email);
                        if (!isValid) {
                          return 'Please enter a valid email';
                        }
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
                      border: const OutlineInputBorder(),
                      focusedBorder: kOutlineInputBorder,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isNotVisibility = !isNotVisibility;
                          });
                        },
                        icon: isNotVisibility2
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
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
                  TextFormField(
                    controller: _passwordConfirmController,
                    keyboardType: TextInputType.visiblePassword,
                    style: kFormTextStyle,
                    cursorColor: Colors.lime,
                    obscureText: isNotVisibility2,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: kLabelTextStyle,
                      border: const OutlineInputBorder(),
                      focusedBorder: kOutlineInputBorder,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isNotVisibility2 = !isNotVisibility2;
                          });
                        },
                        icon: isNotVisibility2
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.grey,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your confirm password';
                      } else if (_passwordController.text !=
                          _passwordConfirmController.text) {
                        return 'Password and confirm password must be the same';
                      }
                      return null;
                    },
                  ),
                  kSpaceHeight,
                  OvalButton(
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        register();
                      }
                    },
                    text: 'Register',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  register() async {
    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No has connection'),
      ));
      return;
    }

    var url = Uri.https('dummyjson.com', 'user/add');
    Map<String, dynamic> body = {
      'firstName': _nameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
      'phone': _phoneNumberController.text.trim(),
      'username' : '@${_userNameController.text.trim()}',
    };

    String jsonData = prepareRequestBody(body);

    var overlayEntry =
        OverlayEntry(builder: (context) => const LoadingOverlay());
    if (mounted) {
      Overlay.of(context).insert(overlayEntry);
    }
    var response = await makePostRequest(
        url.toString(), jsonData, {"Content-Type": "application/json"});
    final responseDecoded = jsonDecode(response.body);
    overlayEntry.remove();

    if (mounted) {
      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WrapPage(
                userLogged: User(
                    id: responseDecoded['id'],
                    firstName: responseDecoded['firstName'],
                    lastName: responseDecoded['lastName'],
                    age: responseDecoded['age'] ?? 0,
                    email: responseDecoded['email'],
                    phone: responseDecoded['phone'],
                    username: responseDecoded['username'],
                    password: responseDecoded['password'],
                    image: '',
                    address: Address(address: 'none', city: 'none', postalCode: 'none', state: 'none'),
                    university: 'none',
                    bank: Bank(cardExpire: 'none', cardNumber: 'none', cardType: 'none', currency: 'none'),
                    ssn: '${responseDecoded['id']}',
                    crypto: Crypto(coin: 'none', wallet: 'none', network: 'none'),
                    job: 'none')),
          ),
        );
      } else {
        handleAPIError(context, response);
      }
    }
  }
}
