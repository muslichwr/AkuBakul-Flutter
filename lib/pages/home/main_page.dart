import 'package:flutter/material.dart';
import '../../theme.dart';
import 'home_page.dart';
import '../category_page.dart';
import '../cart_page.dart';
import 'wishlish_page.dart';
import 'profile_page.dart';
import 'chat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Black,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Black,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Cyan,
        unselectedItemColor: Grey150,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: primaryTextStyle.copyWith(
          fontSize: 10,
          fontWeight: medium,
        ),
        unselectedLabelStyle: secondaryTextStyle.copyWith(
          fontSize: 10,
          fontWeight: medium,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_home.png',
                width: 20,
                color: currentIndex == 0 ? Cyan : Grey150,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_category.png',
                width: 20,
                color: currentIndex == 1 ? Cyan : Grey150,
              ),
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_chat.png',
                width: 20,
                color: currentIndex == 2 ? Cyan : Grey150,
              ),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_shoppingcart.png',
                width: 20,
                color: currentIndex == 3 ? Cyan : Grey150,
              ),
            ),
            label: 'My Cart',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_wishlist.png',
                width: 20,
                color: currentIndex == 4 ? Cyan : Grey150,
              ),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                'assets/icon_profile.png',
                width: 20,
                color: currentIndex == 5 ? Cyan : Grey150,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const CategoryPage();
      case 2:
        return const ChatPage();
      case 3:
        return const CartPage();
      case 4:
        return const WishlistPage();
      case 5:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}
