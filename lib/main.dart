import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';

import 'package:case_flutter_interview/pages/createButton.dart';
import 'package:case_flutter_interview/pages/gridView.dart';
import 'package:case_flutter_interview/themes/themeMode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:case_flutter_interview/model/models.dart';
import 'package:provider/provider.dart';


void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  ThemeModeManager themeMode = ThemeModeManager();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => DataImageProvider()),
      ChangeNotifierProvider(create: (context) => ThemeModeManager()),
      ],
      child: Consumer<ThemeModeManager>(
      builder: (context, themeMode, child) {
        return MaterialApp(
        title: 'Flutter Demo',
        theme: lightMode,
        darkTheme: darkMode,
        themeMode: themeMode.isDark ? ThemeMode.dark : ThemeMode.light,
        home: const MyHomePage(),
        debugShowCheckedModeBanner: false,
        );
      },
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
    var themeMode = Provider.of<ThemeModeManager>(context);
    return MultiProvider(
      
      providers: [ChangeNotifierProvider(create: (context) => DatabaseHelper()),
  
     
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quản lý sản phẩm', style: TextStyle(color: themeMode.isDark ? darkMode.appBarTheme.foregroundColor: lightMode.appBarTheme.foregroundColor)),
          actions: [
            ElevatedButton.icon(
              label: Text('Chế độ sáng/tối', style: TextStyle(color: themeMode.isDark ? darkMode.appBarTheme.foregroundColor: lightMode.appBarTheme.foregroundColor)),
              onPressed: ()async{
          await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(100, 100, 0, 0),
            items: [
              PopupMenuItem(
                child: StatefulBuilder(
                  builder:(context,state){
                    return Container(
                    padding: const EdgeInsets.all(8),
                    child: SwitchTheme(themeMode: themeMode),
                  );
                  }

                ),
              ),
            ],
          );
})
           
          ],
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

class SwitchTheme extends StatelessWidget {
  const SwitchTheme({
    super.key,
    required this.themeMode,
  });

  final ThemeModeManager themeMode;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: themeMode.isDark, 
      onChanged: (value) {
      themeMode.toggleTheme();
      },
      inactiveTrackColor: themeMode.isDark ? darkMode.disabledColor : lightMode.disabledColor,
      focusColor: themeMode.isDark ? darkMode.primaryColor : lightMode.primaryColor, 
      activeColor: themeMode.isDark ? darkMode.primaryColor : lightMode.primaryColor,
      // inactiveThumbColor: Colors.black, 
    
    );
  }
}

