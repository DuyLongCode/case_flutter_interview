import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:case_flutter_interview/model/gridviewSharedProvider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';

import 'package:case_flutter_interview/pages/createButton.dart';
import 'package:case_flutter_interview/pages/gridView.dart';
import 'package:case_flutter_interview/themes/themeMode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:case_flutter_interview/model/models.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  ThemeModeManager themeMode = ThemeModeManager();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => DataImageProvider()),
      ChangeNotifierProvider(create: (context) => ThemeModeManager()),
      ChangeNotifierProvider(create: (context) => GridViewSharedProvider()),
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
      var gridViewSharedProvider=Provider.of<GridViewSharedProvider>(context);
    return MultiProvider(
      
      providers: [ChangeNotifierProvider(create: (context) => DatabaseHelper()),
    
     
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quản lý sản phẩm', style: TextStyle(color: themeMode.isDark ? darkMode.appBarTheme.foregroundColor: lightMode.appBarTheme.foregroundColor)),
          actions: [
         InkWell(
           onTap: () {
             setState(() {
               print('trigger refresh');
               gridViewSharedProvider.refreshGrid();
               gridViewSharedProvider.fetchProducts();
             });
           },
           child: Container(child: Icon(Icons.refresh_sharp)),
         ),
         
            PopupMenuButton<Row>(
      icon: Icon(Icons.more_vert),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) {
        
        return [
         PopupMenuItem(child: Row(children: [SwitchTheme(themeMode: themeMode)]),onTap: () => {
            // themeMode.toggleTheme()
         },),
       
        ];
      },
    )
              
              
          
           
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

class SwitchTheme extends StatefulWidget {
  const SwitchTheme({super.key, required this.themeMode});

  final ThemeModeManager themeMode;
  @override
  // ignore: no_logic_in_create_state
  State<SwitchTheme> createState() => SwitchThemeState(themeMode: themeMode);
}
class SwitchThemeState extends State<SwitchTheme> {
  final ThemeModeManager themeMode;
  SwitchThemeState({
    required this.themeMode,
  });
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: themeMode.isDark, 
      onChanged: (value) {
            setState(() {
              widget.themeMode.toggleTheme();
            });

      },
      inactiveTrackColor: themeMode.isDark ? darkMode.disabledColor : lightMode.disabledColor,
      focusColor: themeMode.isDark ? darkMode.primaryColor : lightMode.primaryColor, 
      activeColor: themeMode.isDark ? darkMode.primaryColor : lightMode.primaryColor,
      // inactiveThumbColor: Colors.black, 
    
    );
  }
}






