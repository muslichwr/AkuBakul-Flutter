import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'dart:developer' as developer;

class FailedOrderPage extends StatelessWidget {
  final String errorMessage;

  const FailedOrderPage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    developer.log('FailedOrderPage - build: Error message: $errorMessage');

    return Scaffold(
      backgroundColor: Black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Grey50,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline_rounded, size: 120, color: Red),
                      const SizedBox(height: 16),
                      Text(
                        'Transaksi Gagal',
                        style: primaryTextStyle.copyWith(
                          fontWeight: bold,
                          fontSize: 18,
                          color: White,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Checkout Gagal!',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 22,
                    color: Red,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Maaf, terjadi kesalahan saat memproses pesanan Anda.',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 16,
                    color: White,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Red.withOpacity(0.5)),
                  ),
                  child: Text(
                    errorMessage,
                    style: secondaryTextStyle.copyWith(
                      fontSize: 14,
                      color: Red,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Coba Lagi',
                  onPressed: () {
                    developer.log('FailedOrderPage - try again button clicked');
                    Navigator.pop(context);
                  },
                  backgroundColor: Cyan,
                  textColor: Black,
                  height: 52,
                  margin: EdgeInsets.zero,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'Kembali ke Home',
                  onPressed: () {
                    developer.log(
                      'FailedOrderPage - back to home button clicked',
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  backgroundColor: Colors.transparent,
                  textColor: Grey100,
                  height: 52,
                  margin: EdgeInsets.zero,
                  borderColor: Grey100.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
