import 'package:flutter/material.dart';
import '../theme.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final Widget? suffixIcon;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        _buildInputLabel(),
        const SizedBox(height: 12),
        // Input field
        _buildInputField(),
      ],
    );
  }

  Widget _buildInputLabel() {
    return Row(
      children: [
        Text(
          label,
          style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
        ),
        Text(
          ' *',
          style: primaryTextStyle.copyWith(
            fontSize: 16,
            fontWeight: medium,
            color: Red,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      height: 50,
      decoration: BoxDecoration(
        color: Cyan50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus ? Cyan : Cyan50,
          width: focusNode.hasFocus ? 1.5 : 1,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: primaryTextStyle,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: secondaryTextStyle,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
