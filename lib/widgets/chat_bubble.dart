import 'package:flutter/material.dart';
import '../theme.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final bool isProductQuestion;
  final Map<String, dynamic>? product;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    this.isProductQuestion = false,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    if (isProductQuestion && product != null) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: isMe ? Cyan : Cyan50,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apakah barang tersedia?',
                style: primaryTextStyle.copyWith(
                  color: isMe ? Black : White,
                  fontWeight: bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildProductImage(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product!['name']?.toString() ?? 'Produk',
                          style: primaryTextStyle.copyWith(
                            color: isMe ? Black : White,
                            fontWeight: medium,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product!['price']?.toString() ?? '',
                          style: secondaryTextStyle.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time, style: secondaryTextStyle.copyWith(fontSize: 11)),
                  if (isMe)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.done_all,
                        size: 14,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    // Bubble chat biasa
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Cyan : Cyan50,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: primaryTextStyle.copyWith(
                color: isMe ? Black : White,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time, style: secondaryTextStyle.copyWith(fontSize: 11)),
                if (isMe)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final imageUrl = product!['image']?.toString() ?? '';

    // Cek apakah gambar dari asset lokal atau URL
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    } else {
      // Gambar dari URL
      return Image.network(
        imageUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 40,
            height: 40,
            color: Grey50,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Cyan),
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackImage();
        },
      );
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 40,
      height: 40,
      color: Grey50,
      child: Icon(Icons.image_not_supported_outlined, color: White, size: 16),
    );
  }
}
