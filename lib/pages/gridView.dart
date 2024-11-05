import 'dart:io';
import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';
import 'package:case_flutter_interview/pages/createButton.dart';
import 'package:flutter/material.dart';
import 'package:case_flutter_interview/model/models.dart';
import 'package:provider/provider.dart';

class GridViewHome extends StatefulWidget {
  const GridViewHome({
    super.key,
    required this.futureData,
  });

  final Future<ApiResponse> futureData;

  @override
  GridViewHomeState createState() => GridViewHomeState();
}

class GridViewHomeState extends State<GridViewHome> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _products = [];
  bool _hasProcessedData = false;

  @override
  void initState() {
    super.initState();

  
    fetchProducts();
  }

 Future<void> fetchProducts() async {
  try {
    final products = await _dbHelper.getProducts();
    if (mounted) {
      setState(() {
        _products = List.from(products);
      });
    }
  } catch (e) {
    print('Error fetching products: $e');
  }
}

 Future<void> _addProduct(List<Map<String, dynamic>> products) async {
    try {
      await _dbHelper.insertData(products);
      

      _products.addAll(products);  
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error adding products: $e');
    }
}



  Future<void> _processProductList(List<Map<String, dynamic>> productList) async {
    if (_hasProcessedData) return;

    try {
      final dataImageProvider = Provider.of<DataImageProvider>(context, listen: false);
      
      dataImageProvider.updateProductList(productList.map((item) => ProductItem(
        name: item['names'] as String,
        price: item['prices'] as double,
        imageSrc: item['urls'] as String,
      )).toList());

      // await _addProduct(productList);
      _products.addAll(productList);
      
      if (mounted) {
        setState(() {
          _hasProcessedData = true;
        });
      }
    } catch (e) {
      print('Error processing product list: $e');
    }
  }

  void refreshGrid() async {
  await fetchProducts(); //
  if (mounted) {
    setState(() {

    });
  }
}
  @override
  Widget build(BuildContext context) {
    double widthOfView = MediaQuery.of(context).size.width;
    
    return RefreshIndicator(
        triggerMode:RefreshIndicatorTriggerMode.anywhere,
        edgeOffset: 20,
        onRefresh: fetchProducts,
        child: FutureBuilder<ApiResponse>(
          future: widget.futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              var apiProducts = snapshot.data?.data
                  .where((item) => item.type == 'ProductList')
                  .expand((item) => item.customAttributes.productList?.items ?? [])
                  .map((item) => {
                        'names': item.name,
                        'prices': item.price,
                        'urls': item.imageSrc,
                      })
                  .toList() ?? [];
      
              if (!_hasProcessedData && apiProducts.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await _processProductList(apiProducts);
                });
              }
              _products.addAll(apiProducts);
              return Consumer<DataImageProvider>(
                builder: (context, dataImageProvider, child) {
                  if (_products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products available',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  }
                  
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      
                      return Card(
                        elevation: 4.0,
                        color: const Color.fromARGB(255, 4, 0, 47),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8.0)
                                ),
                                child: (product['urls'] as String).startsWith('http')
                                  ? Image.network(
                                      product['urls'] as String,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    )
                                  : Image.file(
                                      File(product['urls'] as String),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product['names'] as String,
                                      style: TextStyle(
                                        fontSize:widthOfView*0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${product['prices']} đ',
                                      style: TextStyle(
                                        fontSize: widthOfView*0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const Center(child: Text('No data available'));
          },
        ),
      );
  }

  @override
  void dispose() {

    super.dispose();
  }
}