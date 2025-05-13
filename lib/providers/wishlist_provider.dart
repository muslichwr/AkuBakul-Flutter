import 'package:akubakul/models/product_model.dart';
// import 'package:akubakul/models/wishlist_model.dart';
// import 'package:akubakul/services/wishlist_service.dart';
import 'package:flutter/material.dart';

class WishlistProvider with ChangeNotifier {
  List<ProductModel> _wishlist = [];

  List<ProductModel> get wishlist => _wishlist;

  set wishlist(List<ProductModel> newWishlist) {
    _wishlist = newWishlist;
    notifyListeners();
  }

  setProduct(ProductModel product) {
    if (!isWishList(product)) {
      _wishlist.add(product);
    } else {
      _wishlist.removeWhere((element) => element.id == product.id);
    }
    notifyListeners();
  }

  bool isWishList(ProductModel product) {
    bool result =
        _wishlist.indexWhere((element) => element.id == product.id) != -1;
    return result;
  }
}
