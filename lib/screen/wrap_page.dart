import 'package:e_commerce_mobile/main.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/cart_page.dart';
import 'package:e_commerce_mobile/screen/favorite_page.dart';
import 'package:e_commerce_mobile/screen/home_page.dart';
import 'package:e_commerce_mobile/screen/profile_page.dart';
import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:e_commerce_mobile/screen/settings_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import '../database/db.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  int _currentIndex = 0;
  late TextEditingController _searchController;
  late List<String> favorite;
  bool hasConnection = true;
  bool _imageError = false;

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

  _initCart() async {
    favorite = await DB.instance.readAllFavorites(widget.userLogged.ssn);
  }

  Widget? _renderBody() {
    switch (_currentIndex) {
      case 0:
        return HomePage(
          imageUser: widget.userLogged.image,
          ssn: widget.userLogged.ssn,
        );
      case 1:
        _initCart();
        return FavoritePage(
          ssn: widget.userLogged.ssn,
        );
      case 2:
        return CartPage(
          ssn: widget.userLogged.ssn,
        );
      case 3:
        return ProfilePage(userLogged: widget.userLogged);
      default:
        return null;
    }
  }

  Widget _widgetAppBar() {
    switch (_currentIndex) {
      case 3:
        return IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(
                    userLogged: widget.userLogged,
                    editUser: editUser,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ));
      default:
        return _imageError
            ? CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: Icon(Icons.person, color: Colors.grey[600], size: 20),
              )
            : CircleAvatar(
                radius: 25,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.userLogged.image),
                onBackgroundImageError: (_, __) {
                  setState(() {
                    _imageError = true;
                  });
                },
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                      ssn: widget.userLogged.ssn,
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
            hasConnection
                ? Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = 3;
                        });
                      },
                      child: _widgetAppBar(),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
        body: hasConnection
            ? _renderBody()
            : const Center(
                child: Text(
                  'No internet connection',
                  style: TextStyle(
                    fontSize: 20,
                    color: kColorSlider,
                  ),
                ),
              ),
        bottomNavigationBar: SalomonBar(
            setIndex: (i) => setState(() => _currentIndex = i),
            currentIndex: _currentIndex),
      ),
    );
  }

  void editUser(
      {required String firstName,
        required String lastName,
        required String userName,
        required String phoneNumber,
        required String age,
        required String email,
        required String job}) {
    setState(() {
      setState(() {
        widget.userLogged.firstName = firstName;
        widget.userLogged.lastName = lastName;
        widget.userLogged.username = userName;
        widget.userLogged.phone = phoneNumber;
        widget.userLogged.age = num.parse(age);
        widget.userLogged.email = email;
        widget.userLogged.job = job;
      });
    });
  }
}

class SalomonBar extends StatelessWidget {
  const SalomonBar({
    super.key,
    required int currentIndex,
    required this.setIndex,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;
  final Function setIndex;

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i) => setIndex(i),
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: Colors.purple,
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: const Icon(Icons.favorite_border),
          title: const Text("Likes"),
          selectedColor: Colors.pink,
        ),

        /// Cart
        SalomonBottomBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: const Text("Cart"),
          selectedColor: Colors.blue,
        ),

        /// Profile
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }


}
