import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../pages/checkout_page.dart';
import '../providers/cart_provider.dart';
import '../models/cart_model.dart';
import 'dart:developer' as developer;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String voucherCode = '';
  bool isVoucherSheetOpen = false;

  @override
  void initState() {
    super.initState();
    developer.log('CartPage - initState: Initializing cart page');
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    developer.log(
      'CartPage - build: Cart items count: ${cartProvider.carts.length}',
    );

    return Scaffold(
      backgroundColor: Black,
      appBar: AppBar(
        backgroundColor: Black,
        elevation: 0,
        centerTitle: true,
        leading:
            ModalRoute.of(context)?.canPop == true
                ? IconButton(
                  icon: Icon(Icons.arrow_back, color: White),
                  onPressed: () => Navigator.pop(context),
                )
                : null,
        title: Text(
          'My Cart',
          style: primaryTextStyle.copyWith(
            color: White,
            fontWeight: bold,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showVoucherSheet(context),
            child: Text(
              'Voucher Code',
              style: titleTextStyle.copyWith(
                color: Cyan,
                fontWeight: semibold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            cartProvider.carts.isEmpty
                ? _buildEmptyCart()
                : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        itemCount: cartProvider.carts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, i) => _buildCartItem(context, i),
                      ),
                    ),
                    _buildOrderInfo(context),
                    _buildCheckoutButton(context),
                  ],
                ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, int i) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    CartModel item = cartProvider.carts[i];

    developer.log(
      'CartPage - _buildCartItem: Building item ${i}: ${item.product.name}',
    );

    return Container(
      decoration: BoxDecoration(
        color: Grey50,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar produk
          Container(
            margin: const EdgeInsets.all(12),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Black,
              image: DecorationImage(
                image: NetworkImage(
                  item.product.galleries.isNotEmpty
                      ? item.product.galleries[0].url
                      : 'https://via.placeholder.com/100',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Info produk
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, right: 8, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: primaryTextStyle.copyWith(
                      fontWeight: bold,
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
                        '\$${item.product.price.toStringAsFixed(2)}',
                        style: primaryTextStyle.copyWith(
                          color: White,
                          fontWeight: bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _qtyButton(Icons.remove, () {
                        developer.log(
                          'CartPage - reduceQuantity clicked for item ${i}',
                        );
                        cartProvider.reduceQuantity(i);
                      }),
                      Container(
                        width: 32,
                        alignment: Alignment.center,
                        child: Text(
                          item.quantity.toString(),
                          style: primaryTextStyle.copyWith(
                            fontWeight: bold,
                            fontSize: 15,
                            color: White,
                          ),
                        ),
                      ),
                      _qtyButton(Icons.add, () {
                        developer.log(
                          'CartPage - addQuantity clicked for item ${i}',
                        );
                        cartProvider.addQuantity(i);
                      }),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete, color: Red, size: 22),
                        onPressed: () {
                          developer.log(
                            'CartPage - removeCart clicked for item ${i}',
                          );
                          cartProvider.removeCart(i);
                        },
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Grey100.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: White, size: 16),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    double subtotal = cartProvider.totalPrice();
    double shippingCost = 0.0;
    double total = subtotal + shippingCost;

    developer.log(
      'CartPage - _buildOrderInfo: Subtotal: $subtotal, Shipping: $shippingCost, Total: $total',
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: Black,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Info',
            style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: secondaryTextStyle.copyWith(fontSize: 13),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: primaryTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Cost',
                style: secondaryTextStyle.copyWith(fontSize: 13),
              ),
              Text(
                '\$${shippingCost.toStringAsFixed(2)}',
                style: primaryTextStyle.copyWith(fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Grey100.withOpacity(0.2)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    int itemCount = cartProvider.carts.length;

    developer.log('CartPage - _buildCheckoutButton: Item count: $itemCount');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Cyan,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed:
            itemCount == 0
                ? null
                : () {
                  developer.log(
                    'CartPage - checkout button clicked, navigating to checkout page',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  );
                },
        child: Text(
          'Checkout ($itemCount)',
          style: primaryTextStyle.copyWith(
            color: Black,
            fontWeight: bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    developer.log('CartPage - _buildEmptyCart: Displaying empty cart view');

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image_emptycart.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 36),
            Text(
              'Your cart is empty',
              style: primaryTextStyle.copyWith(
                fontSize: 22,
                fontWeight: bold,
                color: White,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Looks like you have not added anything in your cart. Go ahead and explore top categories.',
              style: secondaryTextStyle.copyWith(
                fontSize: 15,
                color: Grey100,
                fontWeight: regular,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
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
                onPressed: () {
                  developer.log('CartPage - explore categories button clicked');
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text(
                  'Explore Categories',
                  style: primaryTextStyle.copyWith(
                    color: Black,
                    fontWeight: bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoucherSheet(BuildContext context) {
    developer.log('CartPage - _showVoucherSheet: Opening voucher sheet');

    showModalBottomSheet(
      context: context,
      backgroundColor: Grey50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      isScrollControlled: true,
      builder: (context) {
        String tempVoucher = voucherCode;
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Grey100.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Voucher Code',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: White,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: primaryTextStyle.copyWith(color: White),
                decoration: InputDecoration(
                  hintText: 'Enter Voucher Code',
                  hintStyle: secondaryTextStyle.copyWith(color: Grey100),
                  filled: true,
                  fillColor: Black,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Grey100.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Grey100.withOpacity(0.2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Cyan, width: 1.5),
                  ),
                ),
                onChanged: (val) => tempVoucher = val,
                onSubmitted: (_) => _applyVoucher(tempVoucher),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cyan,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    _applyVoucher(tempVoucher);
                    developer.log('CartPage - voucher applied: $tempVoucher');
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply',
                    style: primaryTextStyle.copyWith(
                      color: Black,
                      fontWeight: bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _applyVoucher(String code) {
    setState(() {
      voucherCode = code;
      developer.log('CartPage - _applyVoucher: Applied voucher code: $code');
      // TODO: Validasi dan terapkan voucher
    });
  }
}
