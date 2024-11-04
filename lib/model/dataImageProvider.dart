import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:case_flutter_interview/model/models.dart';

class DataImageProvider extends ChangeNotifier {
  List<ProductItem> returnNewProduct = [];
  List<ProductItem> get newProduct => returnNewProduct;

  String _name = '';
  double _price = 0.0;

  String get name => _name;
  double get price => _price;

  Future<void> loadImage(String name, double price) async {
    Directory imageFolder = Directory((await getApplicationDocumentsDirectory()).path + '/dataImages/');
    // print(imageFolder.listSync().whereType<File>().toList());

    for (var pathItem in imageFolder.listSync().whereType<File>().where((element) {
  final extension = path.extension(element.path).toLowerCase();
  return extension == '.png' || extension == '.jpg';
}).toList()) {
      ProductItem item = ProductItem(name: name, price: price, imageSrc: pathItem.path);
      returnNewProduct.add(item);
    }

  
    notifyListeners();
  }

  // void updateProductList(List<ProductItem> newProductList) {
  //   returnNewProduct = List.from(newProductList); 
  //   notifyListeners();
  // }

  List<ProductItem> _productList = [];

  List<ProductItem> get productList => _productList;

  void addProduct(ProductItem product) {
    _productList.add(product);
    notifyListeners(); // Notify listeners of changes
  }

  void updateProductList(List<ProductItem> products) {
    _productList.clear();
    _productList.addAll(products);
    notifyListeners(); // Notify listeners of changes
  }

}