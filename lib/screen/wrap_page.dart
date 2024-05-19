import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/cart_page.dart';
import 'package:e_commerce_mobile/screen/favorite_page.dart';
import 'package:e_commerce_mobile/screen/home_page.dart';
import 'package:e_commerce_mobile/screen/profile_page.dart';
import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class WrapPage extends StatefulWidget {
  const WrapPage({super.key});

  @override
  State<WrapPage> createState() => _WrapPageState();
}

class _WrapPageState extends State<WrapPage> {
  var _currentIndex = 0;
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

  Widget? _renderBody(){
    switch (_currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return FavoritePage();
      case 2:
        return CartPage();
      case 3:
        return ProfilePage(userLogged: User(
          1,
          '',
          '',
          '',
          '',
          '',
          {'street': 'street', 'number': 'number', 'city': 'city', 'state': 'state', 'zipCode': 'zipCode'},
        ));
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
              '',
              scale: 10, // Adjust the scale as needed
            ),
            // backgroundImage: NetworkImage(
            //   widget.userLogged.image ?? '',
            // ),
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
