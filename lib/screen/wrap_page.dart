import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/cart_page.dart';
import 'package:e_commerce_mobile/screen/favorite_page.dart';
import 'package:e_commerce_mobile/screen/home_page.dart';
import 'package:e_commerce_mobile/screen/profile_page.dart';
import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../database/db.dart';

class WrapPage extends StatefulWidget {
  const WrapPage({
    super.key,
    required this.userLogged,
  });

  final User userLogged;
  @override
  State<WrapPage> createState() => _WrapPageState();
}

class _WrapPageState extends State<WrapPage> {
  var _currentIndex = 0;
  late TextEditingController _searchController;
  late List<String> favorite;

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

  _initCart() async{
    favorite = await DB.instance.readAllFavorites(widget.userLogged.ssn!);
  }

  Widget? _renderBody(){
    switch (_currentIndex) {
      case 0:
        return HomePage(
          ssn: widget.userLogged.ssn!,
        );
      case 1:
        _initCart();
        return FavoritePage(
          ssn: widget.userLogged.ssn!,
        );
      case 2:
        return CartPage(
          ssn: widget.userLogged.ssn!,
        );
      case 3:
        return ProfilePage(userLogged: widget.userLogged);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      toolbarHeight: 80,
      leadingWidth: 300,
      leading: Container(
        margin: const EdgeInsets.only(left: 15),
        child: AnimSearchBar(
          onSubmitted: (value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  choiceView: 3,
                  search: value,
                  ssn: widget.userLogged.ssn!,
                ),
              ),
            );
          },
          width: 400,
          textController: _searchController,
          onSuffixTap: () {
            setState(() {
              _searchController.clear();
            });
          },
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: CircleAvatar(
            radius: 25.0,
            onBackgroundImageError: (_, __) => IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ProfilePage(
                //         userLogged: widget.userLogged,
                //       ),
                //     ),
                //   );
                //
              },
            ),
            backgroundImage: NetworkImage(
              widget.userLogged.image ?? '',
            ),
          ),
        ),
      ],
    ),
      body: _renderBody(),
      bottomNavigationBar: SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
          selectedColor: Colors.purple,
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: Icon(Icons.favorite_border),
          title: Text("Likes"),
          selectedColor: Colors.pink,
        ),

        /// Cart
        SalomonBottomBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Cart"),
          selectedColor: Colors.blue,
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: Icon(Icons.person),
          title: Text("Profile"),
          selectedColor: Colors.teal,
        ),
      ],
    ),
    );
  }
}
