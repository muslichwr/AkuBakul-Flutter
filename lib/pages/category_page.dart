import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Cyan30, // Warna hijau
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'Categories',
                  style: primaryTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Coming Soon', style: primaryTextStyle.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
