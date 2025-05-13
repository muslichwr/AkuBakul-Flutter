import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../widgets/checkout/checkout_stepper.dart';
import '../../widgets/checkout/shipping_form.dart';
import '../../widgets/checkout/payment_form.dart';
import '../../widgets/checkout/review_section.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../services/transaction_service.dart';
import 'success_order_page.dart';
import 'failed_order_page.dart';
import 'dart:developer' as developer;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  Map<String, String>? _shippingAddress;
  int? _paymentMethod;
  bool _isLoading = false;
  bool _useSimulation = false; // Flag untuk testing dengan data simulasi

  @override
  void initState() {
    super.initState();
    developer.log('CheckoutPage - initState: Initializing checkout page');
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    double _subtotal = cartProvider.totalPrice();
    double _shippingCost = 0.0;

    developer.log(
      'CheckoutPage - build: Cart items count: ${cartProvider.carts.length}, Subtotal: $_subtotal',
    );

    return Scaffold(
      backgroundColor: Black,
      appBar: AppBar(
        backgroundColor: Black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: White),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
              developer.log(
                'CheckoutPage - Back button clicked, current step: $_currentStep',
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Checkout',
          style: primaryTextStyle.copyWith(
            color: White,
            fontWeight: bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Tombol untuk toggle simulasi data (hanya untuk development)
          IconButton(
            icon: Icon(
              _useSimulation ? Icons.bug_report : Icons.bug_report_outlined,
              color: _useSimulation ? Cyan : Grey100,
            ),
            tooltip: 'Gunakan Data Simulasi',
            onPressed: () {
              setState(() => _useSimulation = !_useSimulation);
              developer.log('CheckoutPage - Simulation mode: $_useSimulation');

              if (_useSimulation) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Mode Simulasi AKTIF - Data dari backend tidak akan digunakan',
                    ),
                    backgroundColor: Cyan,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            _isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Cyan),
                      const SizedBox(height: 16),
                      Text(
                        'Memproses Pesanan Anda...',
                        style: primaryTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckoutStepper(currentStep: _currentStep),
                      const SizedBox(height: 24),
                      if (_currentStep == 0)
                        ShippingForm(
                          onSaved: (address) {
                            setState(() {
                              _shippingAddress = address;
                              _currentStep = 1;
                            });
                            developer.log(
                              'CheckoutPage - ShippingForm saved, address: $_shippingAddress',
                            );
                          },
                        ),
                      if (_currentStep == 1)
                        PaymentForm(
                          onContinue: (method) {
                            setState(() {
                              _paymentMethod = method;
                              _currentStep = 2;
                            });
                            developer.log(
                              'CheckoutPage - PaymentForm saved, method: $_paymentMethod',
                            );
                          },
                        ),
                      if (_currentStep == 2 && _shippingAddress != null)
                        ReviewSection(
                          address: _shippingAddress!,
                          subtotal: _subtotal,
                          shippingCost: _shippingCost,
                          items: _getReviewItems(cartProvider),
                          onPlaceOrder: () => _handlePlaceOrder(context),
                        ),
                    ],
                  ),
                ),
      ),
    );
  }

  List<Map<String, dynamic>> _getReviewItems(CartProvider cartProvider) {
    developer.log(
      'CheckoutPage - _getReviewItems: Converting cart items to review items',
    );

    return cartProvider.carts.map((cart) {
      return {
        'id': cart.product.id,
        'name': cart.product.name,
        'price': cart.product.price,
        'originalPrice':
            cart.product.price, // Tidak ada harga original di model
        'image':
            cart.product.galleries.isNotEmpty
                ? cart.product.galleries[0].url
                : 'https://via.placeholder.com/100',
        'qty': cart.quantity,
      };
    }).toList();
  }

  Future<void> _handlePlaceOrder(BuildContext context) async {
    developer.log(
      'CheckoutPage - _handlePlaceOrder: Attempting to place order',
    );

    setState(() => _isLoading = true);

    try {
      AuthProvider authProvider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      CartProvider cartProvider = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      TransactionProvider transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      if (!_useSimulation &&
          (authProvider.user == null || authProvider.user!.token == null)) {
        developer.log(
          'CheckoutPage - _handlePlaceOrder: ERROR - User not authenticated',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda harus login untuk melakukan checkout')),
        );
        setState(() => _isLoading = false);
        return;
      }

      developer.log(
        'CheckoutPage - _handlePlaceOrder: Cart items count: ${cartProvider.carts.length}',
      );
      developer.log(
        'CheckoutPage - _handlePlaceOrder: Total price: ${cartProvider.totalPrice()}',
      );

      Map<String, dynamic> result;

      // Gunakan data simulasi jika mode simulasi aktif
      if (_useSimulation) {
        developer.log(
          'CheckoutPage - _handlePlaceOrder: Using SIMULATION data',
        );
        // Data simulasi sukses
        result = TransactionService().simulateSuccessResponse();
        // Data simulasi gagal
        // result = TransactionService().simulateFailedResponse();
      } else {
        // Gunakan data nyata dari API
        developer.log('CheckoutPage - _handlePlaceOrder: Using REAL API call');
        developer.log(
          'CheckoutPage - _handlePlaceOrder: Token: ${authProvider.user!.token}',
        );

        result = await transactionProvider.checkout(
          authProvider.user!.token!,
          cartProvider.carts,
          cartProvider.totalPrice(),
        );
      }

      developer.log(
        'CheckoutPage - _handlePlaceOrder: Checkout result: $result',
      );

      if (result['success']) {
        developer.log('CheckoutPage - _handlePlaceOrder: Checkout SUCCESS');
        cartProvider.carts = [];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessOrderPage(transactionData: result),
          ),
        );
      } else {
        developer.log('CheckoutPage - _handlePlaceOrder: Checkout FAILED');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => FailedOrderPage(
                  errorMessage: result['message'] ?? 'Gagal melakukan checkout',
                ),
          ),
        );
      }
    } catch (e) {
      developer.log(
        'CheckoutPage - _handlePlaceOrder: ERROR - ${e.toString()}',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => FailedOrderPage(errorMessage: 'Error: ${e.toString()}'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
