import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';

import 'package:case_flutter_interview/pages/createButton.dart';
import 'package:case_flutter_interview/pages/gridView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:case_flutter_interview/model/models.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context)=>DataImageProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<ApiResponse> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    
  }
  

  Future<ApiResponse> fetchData() async {
    final response = await http.get(Uri.parse('https://hiring-test.stag.tekoapis.net/api/products/management'));
    // print(response.body);
    if (response.statusCode == 200) {
      final vietnameseDecode=utf8.decode(response.bodyBytes);
      return ApiResponse.fromJson(jsonDecode(vietnameseDecode));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the whole app view
    final sizeApp = MediaQuery.of(context).size;
    final double appWidth = sizeApp.width;
    final double appHeight = sizeApp.height;

    return Provider(
      create: (context) => DatabaseHelper(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
       body: SingleChildScrollView(
          child: Column(
            children: [
              CreateButton(),
              Container(
                height: appHeight * 0.8, 
                child: GridViewHome(futureData: futureData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

