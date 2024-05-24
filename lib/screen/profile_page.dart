import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/components/profile_avatar.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.userLogged,
  });

  final User userLogged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    ProfileAvatar(
                      imageProfile: widget.userLogged.image,
                      radius: 50,
                    ),
                    Text(
                      widget.userLogged.username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Age: ${widget.userLogged.age.toString()}',
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'First Name',
                        style: kTitleStyleProfilePage,
                      ),
                      subtitle: Text(
                        widget.userLogged.firstName,
                        style: kInfoUserProfilePage,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Email',
                        style: kTitleStyleProfilePage,
                      ),
                      subtitle: Text(
                        widget.userLogged.email,
                        style: kInfoUserProfilePage,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.phone_outlined,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Phone',
                        style: kTitleStyleProfilePage,
                      ),
                      subtitle: Text(
                        widget.userLogged.phone,
                        style: kInfoUserProfilePage,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.work_outline,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'Job',
                        style: kTitleStyleProfilePage,
                      ),
                      subtitle: Text(
                        widget.userLogged.job,
                        style: kInfoUserProfilePage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OvalButton(
              function: () {
                _confirmLogout();
              },
              text: 'Logout'),
        ),
      ],
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CheckPage()),
      );
    }
  }

  Future<void> _confirmLogout() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.green),
                  )),
            ],
          );
        });
  }
}
