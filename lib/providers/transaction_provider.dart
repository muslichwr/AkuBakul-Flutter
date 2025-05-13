import 'package:akubakul/models/cart_model.dart';
import 'package:akubakul/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TransactionProvider with ChangeNotifier {
  Map<String, dynamic>? _transactionResult;

  Map<String, dynamic>? get transactionResult => _transactionResult;

  Future<Map<String, dynamic>> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
  ) async {
    developer.log(
      'TransactionProvider - checkout: Attempting checkout with ${carts.length} items and total $totalPrice',
    );

    try {
      Map<String, dynamic> result = await TransactionService().checkout(
        token,
        carts,
        totalPrice,
      );

      _transactionResult = result;

      developer.log(
        'TransactionProvider - checkout: Result - success: ${result['success']}',
      );

      if (result['success']) {
        developer.log(
          'TransactionProvider - checkout: Transaction data - ${result['data']}',
        );
      } else {
        developer.log(
          'TransactionProvider - checkout: Failed - ${result['message']}',
        );
      }

      return result;
    } catch (e) {
      developer.log('TransactionProvider - checkout: Error - $e');

      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
