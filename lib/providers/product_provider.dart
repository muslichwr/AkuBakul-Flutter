import 'package:akubakul/models/product_model.dart';
import 'package:akubakul/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;

  set products(List<ProductModel> newProducts) {
    _products = newProducts;
    notifyListeners();
  }

  set selectedProduct(ProductModel? product) {
    _selectedProduct = product;
    notifyListeners();
  }

  Future<void> getProducts() async {
    try {
      List<ProductModel> products = await ProductService().getProducts();
      _products = products;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getProductById(int id) async {
    try {
      ProductModel product = await ProductService().getProductById(id);
      _selectedProduct = product;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error pada getProductById: $e');

      // Jika gagal mengambil dari API, coba cari dari list produk yang sudah ada
      if (_products.isNotEmpty) {
        try {
          final product = _products.firstWhere((item) => item.id == id);
          _selectedProduct = product;
          notifyListeners();
          return true;
        } catch (e) {}
      } else {
        try {
          // Coba ambil semua produk dulu
          await getProducts();

          // Lalu cari di daftar yang baru saja diambil
          if (_products.isNotEmpty) {
            try {
              final product = _products.firstWhere((item) => item.id == id);
              _selectedProduct = product;
              notifyListeners();
              return true;
            } catch (e) {}
          }
        } catch (e) {}
      }

      return false;
    }
  }
}
