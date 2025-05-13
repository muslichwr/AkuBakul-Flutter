import 'package:flutter/material.dart';
import '../../theme.dart';
import 'dart:developer' as developer;

class ReviewSection extends StatelessWidget {
  final Map<String, String> address;
  final double subtotal;
  final double shippingCost;
  final VoidCallback onPlaceOrder;
  final List<Map<String, dynamic>> items;

  const ReviewSection({
    super.key,
    required this.address,
    required this.subtotal,
    required this.shippingCost,
    required this.onPlaceOrder,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    double total = subtotal + shippingCost;
    developer.log(
      'ReviewSection - build: Items count: ${items.length}, Total: $total',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items (${items.length})',
          style: titleTextStyle.copyWith(fontWeight: bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder:
              (_, __) => Divider(color: Grey100.withOpacity(0.15)),
          itemBuilder: (context, i) => _itemTile(items[i]),
        ),
        const SizedBox(height: 22),
        Text(
          'Shipping Address',
          style: titleTextStyle.copyWith(fontWeight: bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _infoRow('Full Name', address['fullName'] ?? ''),
        _infoRow('Mobile Number', address['phoneNumber'] ?? ''),
        _infoRow('Province', address['province'] ?? ''),
        _infoRow('City', address['city'] ?? ''),
        _infoRow('Street Address', address['streetAddress'] ?? ''),
        _infoRow('Postal Code', address['postalCode'] ?? ''),
        const SizedBox(height: 22),
        Text(
          'Order Info',
          style: titleTextStyle.copyWith(fontWeight: bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        _infoRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
        _infoRow('Shipping Cost', '\$${shippingCost.toStringAsFixed(2)}'),
        const Divider(height: 32, color: Color(0xffC0C0C0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 18),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Cyan,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: onPlaceOrder,
            child: Text(
              'Place Order',
              style: primaryTextStyle.copyWith(
                color: Black,
                fontWeight: bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemTile(Map<String, dynamic> item) {
    developer.log(
      'ReviewSection - _itemTile: Building item: ${item['name']}, price: ${item['price']}, qty: ${item['qty']}',
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Grey50,
            image: DecorationImage(
              image:
                  item['image'].toString().startsWith('http')
                      ? NetworkImage(item['image'])
                      : AssetImage(item['image']) as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: primaryTextStyle.copyWith(
                  fontWeight: semibold,
                  fontSize: 15,
                  color: White,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: primaryTextStyle.copyWith(
                      color: White,
                      fontWeight: bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (item['originalPrice'] > item['price'])
                    Text(
                      '\$${item['originalPrice'].toStringAsFixed(2)}',
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12,
                        color: Grey100,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Text(
                    'x${item['qty']}',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 13,
                      color: Grey100,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: secondaryTextStyle.copyWith(fontSize: 14)),
        Flexible(
          child: Text(
            value,
            style: primaryTextStyle.copyWith(fontSize: 14),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
