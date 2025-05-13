import 'package:flutter/material.dart';
import '../../theme.dart';

class PaymentForm extends StatefulWidget {
  final void Function(int) onContinue;
  const PaymentForm({super.key, required this.onContinue});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  int _selectedPayment = 0; // 0: PayPal, 1: GPay, 2: Card

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _paymentMethodButton(0, 'PayPal', 'assets/paypal_logo.png'),
            const SizedBox(width: 12),
            _paymentMethodButton(1, 'GPay', 'assets/gpay_logo.png'),
          ],
        ),
        const SizedBox(height: 22),
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
            onPressed: () => widget.onContinue(_selectedPayment),
            child: Text(
              'Continue',
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

  Widget _paymentMethodButton(int idx, String label, String asset) {
    final bool selected = _selectedPayment == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPayment = idx),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: selected ? Grey100.withOpacity(0.10) : Grey50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? Cyan : Grey100.withOpacity(0.18),
              width: selected ? 2 : 1,
            ),
          ),
          child: Center(
            child:
                asset.endsWith('.png')
                    ? Image.asset(asset, height: 28)
                    : Text(
                      label,
                      style: primaryTextStyle.copyWith(fontSize: 16),
                    ),
          ),
        ),
      ),
    );
  }
}
