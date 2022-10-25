import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:storeproject/configs/constants.dart';
import 'package:storeproject/models/product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> list = [];
  List<dynamic> categories = [];
  List<String> listTitle = [];
  Product product = Product();
  String apiProductURL = 'https://fakestoreapi.com/products';
  String apiAllCategoryURL = 'https://fakestoreapi.com/products/categories';
  String apiCategoryURL = 'https://fakestoreapi.com/products/category';
  Future<List<Product>> getList(category) async {
    var client = http.Client();
    String url;
    if (category == "") {
      url = apiProductURL;
    } else {
      url = '$apiCategoryURL/$category';
    }
    var jsonString = await client.get(Uri.parse(url));
    var jsonObject = jsonDecode(jsonString.body);
    var newListObject = jsonObject as List;
    list = newListObject.map((e) {
      return Product.fromJson(e);
    }).toList();
    for (int i = 0; i < list.length; i++) {
      listTitle.add(list[i].title);
    }
    notifyListeners();
    return list;
  }

  void getListSearch(String searchValue) async {
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiProductURL));
    var jsonObject = jsonDecode(jsonString.body);
    var newListObject = jsonObject as List;
    list = newListObject.map((e) {
      return Product.fromJson(e);
    }).toList();
    list = list
        .where((e) => e.title.toLowerCase().contains(searchValue.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void getDetail(id) async {
    var detailUrl = '$apiProductURL/$id';
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(detailUrl));
    var jsonObject = jsonDecode(jsonString.body);
    product = Product.fromJson(jsonObject);
    notifyListeners();
  }

  Future<List> getListCategory() async {
    var client = http.Client();
    var jsonString = await client.get(Uri.parse(apiAllCategoryURL));
    var jsonObject = jsonDecode(jsonString.body);
    categories = jsonObject;
    notifyListeners();
    return categories;
  }

  Future<List<Product>> getProductInCategory(category) async {
    var client = http.Client();
    var jsonString = await client.get(Uri.parse('$apiCategoryURL/$category'));
    var jsonObject = jsonDecode(jsonString.body);
    var newListObject = jsonObject as List;
    list = newListObject.map((e) {
      return Product.fromJson(e);
    }).toList();
    notifyListeners();
    return list;
  }

  List<String> getListTilte() {
    return listTitle;
  }

  void sortListProduct(condition) {
    switch (condition) {
      case CustomConstants.PRICE_LOW_TO_HIGH:
        list.sort((a, b) {
          return a.price!.compareTo(b.price ?? 0);
        });
        break;
      case CustomConstants.PRICE_HIGH_TO_LOW:
        list.sort((a, b) {
          return b.price!.compareTo(a.price ?? 0);
        });
        break;
      case CustomConstants.ALPHABET_LOW_TO_HIGH:
        list.sort((a, b) {
          return a.title.compareTo(b.title);
        });
        break;
      case CustomConstants.ALPHABET_HIGHT_TO_LOW:
        list.sort((a, b) {
          return b.title.compareTo(a.title);
        });
        break;
      default:
    }
    notifyListeners();
  }
}
