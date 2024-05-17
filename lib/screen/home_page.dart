import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import '../utils/handle_api_error.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.perfil,
  });

  final Map<String, dynamic> perfil;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 300,
        leading: AnimSearchBar(
          onSubmitted: (value) {
            print(value);
          },
          width: 400,
          textController: _searchController,
          onSuffixTap: () {
            setState(() {
              _searchController.clear();
            });
          },
        ),
        actions: [
          CircleAvatar(
          radius: 20.0,
          onBackgroundImageError: (_, __) => IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle the action when the icon is pressed
            },
          ),
          backgroundImage: NetworkImage(
            widget.perfil['image'] as String,
          ),
        ),
        ],
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.shopping_cart),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const CheckPage()
      ),
    );
  }

  Future<void> _confirmLogout() async{
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                logout();
              },
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: (){
                logout();
              },
              child: const Text('Logout')
            ),
          ],
        );
      }
    );
  }


}
