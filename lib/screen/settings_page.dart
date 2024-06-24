import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/main.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/address_page.dart';
import 'package:e_commerce_mobile/screen/payments_methods_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.userLogged, required this.editUser});

  final User userLogged;
  final void Function({
    required String firstName,
    required String lastName,
    required String userName,
    required String phoneNumber,
    required String age,
    required String email,
    required String job,
  }) editUser;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool hasConnection = true;

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentsMethodsPage(
                            userLogged: widget.userLogged)));
              },
              leading: const Icon(
                Icons.payment_outlined,
                color: Colors.white,
              ),
              title: const Text('Payment Methods'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddressPage(userLogged: widget.userLogged)));
              },
              leading: const Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
              title: const Text('Address'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                editProfile(context, hasConnection);
              },
              leading: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  editProfile(BuildContext context, bool hasConnection) {
    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No has connection'),
      ));
      return;
    }

    TextEditingController firstNameController =
        TextEditingController(text: widget.userLogged.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: widget.userLogged.lastName);
    TextEditingController emailController =
        TextEditingController(text: widget.userLogged.email);
    TextEditingController jobController =
        TextEditingController(text: widget.userLogged.job);
    TextEditingController phoneNumberController =
        TextEditingController(text: widget.userLogged.phone);
    TextEditingController userNameController =
        TextEditingController(text: widget.userLogged.username);
    TextEditingController ageController =
        TextEditingController(text: '${widget.userLogged.age}');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: SizedBox(
          height: 600,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: kPadding,
                    children: [
                      const Text('Edit Profile',
                          textAlign: TextAlign.center, style: kTitleTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstNameController,
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
                              controller: lastNameController,
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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: userNameController,
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
                          ),
                          kSpaceWidth,
                          Expanded(
                            child: TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              style: kFormTextStyle,
                              cursorColor: Colors.lime,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                                labelStyle: kLabelTextStyle,
                                border: OutlineInputBorder(),
                                focusedBorder: kOutlineInputBorder,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your user Age';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      kSpaceHeight,
                      TextFormField(
                        controller: phoneNumberController,
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
                                PhoneNumber.parse(phoneNumberController.text);
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
                        controller: emailController,
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
                            final String email = emailController.text.trim();
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
                        controller: jobController,
                        keyboardType: TextInputType.name,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'Job',
                          labelStyle: kLabelTextStyle,
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Job';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      OvalButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (mounted) {
                              widget.editUser(
                                  age: ageController.text,
                                  email: emailController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  job: jobController.text,
                                  phoneNumber: phoneNumberController.text,
                                  userName: userNameController.text);
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        text: 'Edit',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
