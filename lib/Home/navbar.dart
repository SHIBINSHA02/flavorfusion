import 'package:flavorfusion/Home/Homepage.dart';
import 'package:flavorfusion/Profile/Profile.dart';
import 'package:flavorfusion/Shopping/Shopping.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _getPage(_page),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home_outlined, size: 30, color: Colors.orange),
          Icon(Icons.shopping_cart_outlined, size: 30, color: Colors.orange),
          Icon(Icons.search, size: 30, color: Colors.orange),
          Icon(Icons.favorite_border, size: 30, color: Colors.orange),
          Icon(Icons.person_outline, size: 30, color: Colors.orange),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.orange.withOpacity(0),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _getPage(int _page) {
    switch (_page) {
      case 0:
        return const HomePage();
      case 1:
        return const ShoppingPage();
      case 2:
      //return const SearchPage();
      case 3:
      //return const FavoritesPage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}
