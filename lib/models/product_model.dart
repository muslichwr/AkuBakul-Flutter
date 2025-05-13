import 'package:akubakul/models/category_model.dart';
import 'package:akubakul/models/gallery_model.dart';

class ProductModel {
  int id;
  String name;
  double price;
  String description;
  String tags;
  CategoryModel category;
  DateTime createAt;
  DateTime updatedAt;
  List<GalleryModel> galleries;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.tags,
    required this.category,
    required this.createAt,
    required this.updatedAt,
    required this.galleries,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      price = double.parse(json['price'].toString()),
      description = json['description'],
      tags = json['tags'],
      category = CategoryModel.fromJson(json['category']),
      createAt = DateTime.parse(json['created_at']),
      updatedAt = DateTime.parse(json['updated_at']),
      galleries =
          json['galleries']
              .map<GalleryModel>((gallery) => GalleryModel.fromJson(gallery))
              .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'tags': tags,
      'category': category.toJson(),
      'create_at': createAt.toIso8601String(),
      'updated_at': updatedAt.toString(),
      'galleries': galleries.map((gallery) => gallery.toJson()).toList(),
    };
  }
}
