import 'dart:convert';
import 'package:akubakul/models/cart_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class TransactionService {
  String baseUrl = 'http://192.168.1.15:8000/api';

  Future<Map<String, dynamic>> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
  ) async {
    try {
      developer.log('TransactionService - checkout: Starting checkout process');

      var url = Uri.parse('$baseUrl/checkout');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var items =
          carts
              .map((cart) => {'id': cart.product.id, 'quantity': cart.quantity})
              .toList();

      var body = jsonEncode({
        'address': 'Kota Kediri',
        'items': items,
        'total_price': totalPrice,
        'shipping_price': 0,
        'status': 'PENDING',
      });

      developer.log(
        'TransactionService - checkout: Sending request with body: $body',
      );

      // Simulasi data sukses untuk testing
      // return simulateSuccessResponse();

      // Simulasi data gagal untuk testing
      // return simulateFailedResponse();

      var response = await http.post(url, headers: headers, body: body);

      developer.log(
        'TransactionService - checkout: Response status: ${response.statusCode}',
      );
      developer.log(
        'TransactionService - checkout: Response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': 'Gagal checkout. Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      developer.log('TransactionService - checkout: Error: $e');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Fungsi untuk simulasi respons sukses
  Map<String, dynamic> simulateSuccessResponse() {
    developer.log('TransactionService - SIMULATING SUCCESS RESPONSE');
    return {
      'success': true,
      'data': {
        'id': 1,
        'user_id': 1,
        'address': 'Kota Kediri',
        'total_price': 2000,
        'shipping_price': 100,
        'status': 'PENDING',
        'updated_at': '2025-05-13T04:22:35.000000Z',
        'created_at': '2025-05-13T04:22:35.000000Z',
        'items': [
          {
            'id': 1,
            'product_id': 2,
            'transaction_id': 1,
            'quantity': 2,
            'created_at': '2025-05-13T04:22:35.000000Z',
            'updated_at': '2025-05-13T04:22:35.000000Z',
          },
        ],
      },
    };
  }

  // Fungsi untuk simulasi respons gagal
  Map<String, dynamic> simulateFailedResponse() {
    developer.log('TransactionService - SIMULATING FAILED RESPONSE');
    return {
      'success': false,
      'message': 'Produk tidak ditemukan atau tidak tersedia',
    };
  }
}
