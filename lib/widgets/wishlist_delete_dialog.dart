import 'package:flutter/material.dart';
import '../theme.dart';
import 'custom_button.dart';

class WishlistDeleteDialog extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;
  final String productName;
  const WishlistDeleteDialog({
    required this.onDelete,
    required this.onCancel,
    required this.productName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Cyan50,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Black.withOpacity(0.08),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Red, size: 40),
              const SizedBox(height: 10),
              Text(
                'Hapus dari Wishlist?',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Produk "${productName.length > 28 ? productName.substring(0, 25) + '...' : productName}" akan dihapus dari wishlist Anda.',
                style: secondaryTextStyle.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Divider(
                color: Grey100.withOpacity(0.18),
                thickness: 1,
                height: 1,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: White,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Batal',
                        style: primaryTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: onDelete,
                      style: TextButton.styleFrom(
                        backgroundColor: Red,
                        foregroundColor: White,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Hapus',
                        style: primaryTextStyle.copyWith(
                          fontWeight: bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
