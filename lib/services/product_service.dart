import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:akubakul/models/product_model.dart';

class ProductService {
  // Ganti dengan alamat IP server API Anda
  // Jika menggunakan emulator Android, gunakan: String baseUrl = 'http://10.0.2.2:8000/api';
  // Jika menggunakan perangkat fisik atau emulator iOS, gunakan IP komputer Anda:
  //String baseUrl = 'http://192.168.1.15:8000/api';

  // Gunakan alamat loopback (localhost) jika server API di perangkat yang sama
  String baseUrl = 'http://192.168.1.15:8000/api';

  // Untuk pengujian tanpa server, Anda bisa gunakan server online
  // String baseUrl = 'https://mockapi.example.com/api';

  Future<List<ProductModel>> getProducts() async {
    var url = Uri.parse('$baseUrl/products');
    var headers = {'Content-Type': 'application/json'};
    var response = await http.get(url, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal mendapatkan data produk');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    var url = Uri.parse('$baseUrl/products/$id');
    var headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        ProductModel product = ProductModel.fromJson(data);
        return product;
      } else {
        throw Exception(
          'Gagal mendapatkan detail produk dengan status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}
