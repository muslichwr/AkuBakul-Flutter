import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final String image;
  final List<String> colors;
  final String backgroundColor;
  final String? id;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    required this.colors,
    this.backgroundColor = '#282828',
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(int.parse(backgroundColor.replaceAll('#', '0xff')));

    // Pastikan id produk selalu tersedia
    if (id == null || id!.isEmpty) {
      print('PERINGATAN: ID produk tidak valid untuk $name');
    }

    return GestureDetector(
      onTap: () {
        if (id != null && id!.isNotEmpty) {
          Navigator.pushNamed(context, '/product/$id');
        } else {
          print('Tidak dapat membuka produk karena ID tidak valid');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Grey50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child:
                        image.startsWith('http')
                            ? Image.network(
                              image,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/image_not_available.png',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                            )
                            : Image.asset(
                              image,
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.black87,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Available Colors
                    Row(children: _buildColorOptions()),
                    const SizedBox(height: 6),
                    // Product Name
                    Text(
                      name,
                      style: primaryTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semibold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Price and Add to Cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(price),
                              style: primaryTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: bold,
                                color: Cyan,
                              ),
                            ),
                            if (originalPrice != null && originalPrice! > price)
                              Text(
                                NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(originalPrice),
                                style: secondaryTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        // Add to cart button
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Cyan,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Cyan.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icon_addcart.png',
                                width: 20,
                                height: 20,
                                color: White,
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
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColorOptions() {
    List<Widget> colorWidgets = [];

    // Maksimal menampilkan 3 warna
    int displayCount = colors.length > 3 ? 3 : colors.length;

    for (int i = 0; i < displayCount; i++) {
      Color dotColor;

      // Menentukan warna berdasarkan nama
      switch (i) {
        case 0:
          dotColor = Blue;
          break;
        case 1:
          dotColor = Grey150;
          break;
        case 2:
          dotColor = Brown;
          break;
        default:
          dotColor = Grey150;
      }

      colorWidgets.add(
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(color: White.withOpacity(0.3), width: 1.5),
          ),
        ),
      );
    }

    // Menambahkan teks jumlah warna jika lebih dari 3
    colorWidgets.add(
      Text(
        'All ${colors.length} Colors',
        style: secondaryTextStyle.copyWith(fontSize: 11, fontWeight: medium),
      ),
    );

    return colorWidgets;
  }
}
