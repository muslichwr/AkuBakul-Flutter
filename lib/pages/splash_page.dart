import 'package:akubakul/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    getInit();
    super.initState();
  }

  Future<void> getInit() async {
    await Provider.of<ProductProvider>(context, listen: false).getProducts();
    Navigator.pushNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Black,
      body: Center(
        child: Container(
          width: 263,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image_splash.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
