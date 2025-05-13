import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

class WishlistProductCard extends StatelessWidget {
  final String image, name;
  final double price, oldPrice;
  final int qty;
  final VoidCallback onDelete;
  final Function(int) onQtyChanged;
  final bool isLast;
  final bool isNetworkImage;

  const WishlistProductCard({
    required this.image,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.qty,
    required this.onDelete,
    required this.onQtyChanged,
    this.isLast = false,
    this.isNetworkImage = false,
    Key? key,
  }) : super(key: key);

  bool get hasDiscount => oldPrice > price;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Grey100.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      isNetworkImage
                          ? Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'WishlistProductCard: Error loading image: $error',
                              );
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Grey100,
                                  size: 24,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  valueColor: AlwaysStoppedAnimation(Cyan),
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                'WishlistProductCard: Error loading asset image: $error',
                              );
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Grey100,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: primaryTextStyle.copyWith(
                        fontWeight: bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          formatter.format(price),
                          style: primaryTextStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 15,
                            color: Cyan,
                          ),
                        ),
                        if (hasDiscount) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Diskon',
                              style: TextStyle(
                                color: Red,
                                fontSize: 11,
                                fontWeight: bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (hasDiscount)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          formatter.format(oldPrice),
                          style: secondaryTextStyle.copyWith(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                            color: Grey150.withOpacity(0.7),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Grey100.withOpacity(0.13),
                            border: Border.all(color: Grey150.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                color: Black.withOpacity(0.03),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: White,
                                  size: 15,
                                ),
                                onPressed:
                                    qty > 1
                                        ? () => onQtyChanged(qty - 1)
                                        : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 26,
                                  minHeight: 28,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  '$qty',
                                  style: primaryTextStyle.copyWith(
                                    fontWeight: medium,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: White, size: 15),
                                onPressed: () => onQtyChanged(qty + 1),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 26,
                                  minHeight: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 1,
                          height: 22,
                          color: Grey100.withOpacity(0.18),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Red,
                            size: 22,
                          ),
                          onPressed: onDelete,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 0),
            child: Divider(
              color: Grey100.withOpacity(0.18),
              thickness: 1,
              height: 1,
            ),
          ),
      ],
    );
  }
}
