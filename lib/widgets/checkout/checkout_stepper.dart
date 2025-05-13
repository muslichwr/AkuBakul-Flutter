import 'package:flutter/material.dart';
import '../../theme.dart';

class CheckoutStepper extends StatelessWidget {
  final int currentStep;
  const CheckoutStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    List<String> steps = ['Shipping', 'Payment', 'Review'];
    List<IconData> icons = [
      Icons.local_shipping,
      Icons.payment,
      Icons.receipt_long,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Container(
            width: 36,
            height: 2,
            color: Grey100.withOpacity(0.25),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          );
        }
        int idx = i ~/ 2;
        bool active = currentStep == idx;
        return Column(
          children: [
            Icon(icons[idx], color: active ? Cyan : Grey100, size: 28),
            const SizedBox(height: 4),
            Text(
              steps[idx],
              style: primaryTextStyle.copyWith(
                color: active ? Cyan : Grey100,
                fontWeight: active ? bold : regular,
                fontSize: 13,
              ),
            ),
          ],
        );
      }),
    );
  }
}
