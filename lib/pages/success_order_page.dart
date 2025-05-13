import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import 'dart:developer' as developer;

class SuccessOrderPage extends StatelessWidget {
  final Map<String, dynamic> transactionData;

  const SuccessOrderPage({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    developer.log(
      'SuccessOrderPage - build: Transaction Data: $transactionData',
    );

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
                  child: Image.asset(
                    'assets/success_order.png',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      developer.log('SuccessOrderPage - Image error: $error');
                      return Icon(
                        Icons.check_circle_outline,
                        size: 120,
                        color: Cyan,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Pesanan Berhasil!',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle.copyWith(
                    fontWeight: bold,
                    fontSize: 22,
                    color: White,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Status: ${_getDataValue('status', 'PENDING')}',
                  textAlign: TextAlign.center,
                  style: primaryTextStyle.copyWith(
                    fontWeight: semibold,
                    fontSize: 16,
                    color: Cyan,
                  ),
                ),
                const SizedBox(height: 18),
                _buildTransactionInfo(),
                const SizedBox(height: 18),
                Text(
                  'Terima kasih telah berbelanja bersama kami! Kami akan segera memproses pesanan Anda.',
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle.copyWith(
                    fontSize: 15,
                    color: Grey100,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Lanjutkan Belanja',
                  onPressed: () {
                    developer.log(
                      'SuccessOrderPage - continue shopping button clicked',
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  backgroundColor: Cyan,
                  textColor: Black,
                  height: 52,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Grey50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('ID Pesanan', '#${_getDataValue('id', '-')}'),
          _infoRow('Alamat', _getDataValue('address', '-')),
          _infoRow('Total Harga', 'Rp${_getDataValue('total_price', '0')}'),
          _infoRow('Ongkos Kirim', 'Rp${_getDataValue('shipping_price', '0')}'),
          _infoRow('Tanggal', _formatDate(_getDataValue('created_at', ''))),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: secondaryTextStyle.copyWith(fontSize: 14, color: Grey100),
          ),
          Text(
            value,
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
              fontSize: 14,
              color: White,
            ),
          ),
        ],
      ),
    );
  }

  String _getDataValue(String key, String defaultValue) {
    // Periksa struktur data
    if (transactionData.isEmpty) {
      developer.log(
        'SuccessOrderPage - _getDataValue: transactionData is empty',
      );
      return defaultValue;
    }

    // Jika data ada di level atas
    if (transactionData.containsKey(key)) {
      developer.log(
        'SuccessOrderPage - _getDataValue: found $key at top level: ${transactionData[key]}',
      );
      return transactionData[key]?.toString() ?? defaultValue;
    }

    // Jika data berada dalam properti 'data'
    if (transactionData.containsKey('data')) {
      final data = transactionData['data'];
      if (data is Map<String, dynamic> && data.containsKey(key)) {
        developer.log(
          'SuccessOrderPage - _getDataValue: found $key in data property: ${data[key]}',
        );
        return data[key]?.toString() ?? defaultValue;
      }
    }

    developer.log('SuccessOrderPage - _getDataValue: key $key not found');
    return defaultValue;
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      developer.log('SuccessOrderPage - _formatDate: Error parsing date: $e');
      return dateString;
    }
  }
}
