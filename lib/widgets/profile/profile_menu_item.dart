import 'package:flutter/material.dart';
import '../../theme.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Grey100, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: regular,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Grey100, size: 24),
          ],
        ),
      ),
    );
  }
}
