import 'package:akubakul/models/cart_model.dart';
import 'package:akubakul/models/product_model.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  set carts(List<CartModel> carts) {
    developer.log(
      'CartProvider - set carts: length before: ${_carts.length}, length after: ${carts.length}',
    );
    _carts = carts;
    notifyListeners();
  }

  addCart(ProductModel product) {
    developer.log(
      'CartProvider - addCart: productId: ${product.id}, productName: ${product.name}',
    );
    developer.log(
      'CartProvider - addCart: carts length before: ${_carts.length}',
    );

    if (productExist(product)) {
      int index = _carts.indexWhere(
        (element) => element.product.id == product.id,
      );
      developer.log(
        'CartProvider - addCart: product exists, index: $index, current qty: ${_carts[index].quantity}',
      );
      _carts[index].quantity++;
      developer.log(
        'CartProvider - addCart: updated qty: ${_carts[index].quantity}',
      );
    } else {
      developer.log('CartProvider - addCart: adding new product');
      _carts.add(CartModel(id: _carts.length, product: product, quantity: 1));
    }

    developer.log(
      'CartProvider - addCart: carts length after: ${_carts.length}',
    );
    notifyListeners();
  }

  removeCart(int id) {
    developer.log(
      'CartProvider - removeCart: id: $id, carts length before: ${_carts.length}',
    );
    if (id >= 0 && id < _carts.length) {
      developer.log(
        'CartProvider - removeCart: removing product: ${_carts[id].product.name}',
      );
      _carts.removeAt(id);
      developer.log(
        'CartProvider - removeCart: carts length after: ${_carts.length}',
      );
      notifyListeners();
    } else {
      developer.log('CartProvider - removeCart: ERROR - index out of bounds');
    }
  }

  addQuantity(int id) {
    developer.log('CartProvider - addQuantity: id: $id');
    if (id >= 0 && id < _carts.length) {
      developer.log(
        'CartProvider - addQuantity: product: ${_carts[id].product.name}, qty before: ${_carts[id].quantity}',
      );
      _carts[id].quantity++;
      developer.log(
        'CartProvider - addQuantity: qty after: ${_carts[id].quantity}',
      );
      notifyListeners();
    } else {
      developer.log('CartProvider - addQuantity: ERROR - index out of bounds');
    }
  }

  reduceQuantity(int id) {
    developer.log('CartProvider - reduceQuantity: id: $id');
    if (id >= 0 && id < _carts.length) {
      developer.log(
        'CartProvider - reduceQuantity: product: ${_carts[id].product.name}, qty before: ${_carts[id].quantity}',
      );
      _carts[id].quantity--;
      developer.log(
        'CartProvider - reduceQuantity: qty after: ${_carts[id].quantity}',
      );

      if (_carts[id].quantity == 0) {
        developer.log(
          'CartProvider - reduceQuantity: removing product because qty = 0',
        );
        _carts.removeAt(id);
        developer.log(
          'CartProvider - reduceQuantity: carts length after: ${_carts.length}',
        );
      }
      notifyListeners();
    } else {
      developer.log(
        'CartProvider - reduceQuantity: ERROR - index out of bounds',
      );
    }
  }

  totalItem() {
    int total = 0;
    for (var item in carts) {
      total += item.quantity;
    }
    developer.log('CartProvider - totalItem: total: $total');
    return total;
  }

  totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += item.product.price * item.quantity;
    }
    developer.log('CartProvider - totalPrice: total: $total');
    return total;
  }

  productExist(ProductModel product) {
    int index = _carts.indexWhere(
      (element) => element.product.id == product.id,
    );
    bool exists = index != -1;
    developer.log(
      'CartProvider - productExist: productId: ${product.id}, exists: $exists, index: $index',
    );
    return exists;
  }
}
