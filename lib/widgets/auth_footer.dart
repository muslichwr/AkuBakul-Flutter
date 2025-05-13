import 'package:flutter/material.dart';
import '../theme.dart';

class AuthFooter extends StatelessWidget {
  final String prefix;

  const AuthFooter({Key? key, required this.prefix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Terms and conditions
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$prefix our ',
                  style: secondaryTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  'Privacy Policy',
                  style: TextStyle(color: Blue, fontSize: 12),
                ),
                Text(' and', style: secondaryTextStyle.copyWith(fontSize: 12)),
              ],
            ),
          ),
        ),
        Center(
          child: Text(
            'Terms & Conditions',
            style: TextStyle(color: Blue, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
