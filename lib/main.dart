import 'package:akubakul/pages/detail_chat_page.dart';
import 'package:akubakul/pages/product_page.dart';
import 'package:akubakul/pages/splash_page.dart';
import 'package:akubakul/pages/cart_page.dart';
import 'package:akubakul/providers/auth_provider.dart';
import 'package:akubakul/providers/product_provider.dart';
import 'package:akubakul/providers/wishlist_provider.dart';
import 'package:akubakul/pages/home/wishlish_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/home/main_page.dart';
import 'pages/home/profile_page.dart';
import 'widgets/profile/edit_profile_page.dart';
import 'widgets/profile/change_password_page.dart';
import 'providers/cart_provider.dart';
import 'providers/transaction_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/sign-in': (context) => const SignInPage(),
          '/sign-up': (context) => const SignUpPage(),
          '/home': (context) => const MainPage(),
          '/profile': (context) => const ProfilePage(),
          '/edit-profile': (context) => const EditProfilePage(),
          '/change-password': (context) => const ChangePasswordPage(),
          '/cart': (context) => const CartPage(),
          '/wishlist': (context) => const WishlistPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail-chat') {
            final chatName = settings.arguments as String? ?? '';
            return MaterialPageRoute(
              builder: (context) => DetailChatPage(chatName: chatName),
            );
          }

          if (settings.name!.startsWith('/product/')) {
            final productId = settings.name!.split('/').last;
            print('Navigasi ke produk dengan ID: $productId');
            return MaterialPageRoute(
              builder: (context) => ProductPage(productId: productId),
            );
          }

          return null;
        },
      ),
    );
  }
}
