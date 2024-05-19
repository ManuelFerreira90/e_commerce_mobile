import 'package:e_commerce_mobile/models/user.dart';
import 'package:flutter/material.dart';

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
    return Center(
      child: Text('Profile Page', style: TextStyle(fontSize: 30, color: Colors.white)),
    );
  }
}
