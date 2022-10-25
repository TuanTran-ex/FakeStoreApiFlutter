import 'dart:convert';

class Product {
  int? id;
  String title;
  double? price;
  String? description;
  String? category;
  String? image;
  int quantity;
  Map? rating;

  Product({
    this.id,
    this.title = "",
    this.price,
    this.description,
    this.category,
    this.image,
    this.quantity = 0,
    this.rating,
  });
  factory Product.fromItem(Product item, int quantity) {
    return Product(
      id: item.id,
      title: item.title,
      description: item.description,
      price: item.price,
      category: item.category,
      image: item.image,
      rating: item.rating,
      quantity: quantity,
    );
  }
  factory Product.fromJson(Map<String, dynamic> obj) {
    // Tên constructor tự đặt fromJson
    return Product(
      id: obj['id'],
      title: obj['title'],
      price: obj['price'],
      description: obj['description'],
      category: obj['category'],
      image: obj['image'],
      rating: obj['rating'],
    );
  }
}
