import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:flutter/material.dart';
import 'package:case_flutter_interview/model/models.dart';
import 'package:provider/provider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';
import 'dart:io';
class GridViewSharedProvider with ChangeNotifier{
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> finalProducts = [];
  bool _hasProcessedData = false;
   Future<void> fetchProducts() async {
    try {
      final products = await _dbHelper.getProducts();
      finalProducts= List.from(products);
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }


 Future<void> _addProduct(List<Map<String, dynamic>> products) async {
    try {
      await _dbHelper.insertData(products);
      

      finalProducts.addAll(products);  
    } catch (e) {
      print('Error adding products: $e');
    }
}



  Future<void> processProductList(List<Map<String, dynamic>> productList,BuildContext context) async {
    if (_hasProcessedData) return;

    try {
      final dataImageProvider = Provider.of<DataImageProvider>(context, listen: false);
      
      dataImageProvider.updateProductList(productList.map((item) => ProductItem(
        name: item['names'] as String,
        price: item['prices'] as double,
        imageSrc: item['urls'] as String,
      )).toList());

      // await _addProduct(productList);
      finalProducts.addAll(productList);
      
  
    } catch (e) {
      print('Error processing product list: $e');
    }
  
  }

  void refreshGrid() async {
  await fetchProducts(); //
  
}
}