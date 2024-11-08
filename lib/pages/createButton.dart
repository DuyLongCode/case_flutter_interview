import 'dart:io';

import 'package:case_flutter_interview/model/dataImageProvider.dart';
import 'package:case_flutter_interview/model/sqlitedb.dart';
import 'package:case_flutter_interview/themes/themeMode.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:case_flutter_interview/pages/gridView.dart';
class CreateButton extends StatefulWidget {
  @override
  CreateButtonState createState() => CreateButtonState();
}

class CreateButtonState extends State<CreateButton> with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late File _image;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  // List<Map<String, dynamic>> _products = [];
bool isFilePicked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _onShowAlertDialog(BuildContext context,bool isFilePicked) {
    if(isFilePicked == false){
      _showAlertDialog(context, 'Lỗi', 'Nhập thiếu dữ liệu');
    }
    else
    {     _showAlertDialog(context, 'Thành công', 'Thành công');}
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

 Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang nhập dữ liệu')),
      );
      
      if (!isFilePicked) {
        _onShowAlertDialog(context, false);
        return;
      }

      String savedImagePath = await saveImage();
      final productName = _productNameController.text.trim();
      final productPrice = double.tryParse(_productPriceController.text) ?? 0.0;

      await _dbHelper.insertData([
        {
          'names': productName,
          'prices': productPrice,
          'urls': savedImagePath,
        }
      ]);

      _onShowAlertDialog(context, true);
      _formKey.currentState!.reset();
      _productNameController.clear();
      _productPriceController.clear();
      setState(() {
        isFilePicked = false;
      });

   
      if (context.mounted) {
        final gridViewState = context.findAncestorStateOfType<GridViewHomeState>();
        gridViewState?.refreshGrid();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: ${e.toString()}')),
      );
    }
  }
}

  Future<String> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null) {
    _image = File(result.files.single.path!);
    setState(() {  
      isFilePicked = true;
    });
    return result.files.single.path!;
  }
  
  setState(() {
    isFilePicked = false;
  });
  return '';
}




Future<String> getDocumentsDirectoryPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

  Future<String> saveImage() async {
    // _image=_pickImage() as File;
    final String documentDirectory = await getDocumentsDirectoryPath();
    String destinationPath = documentDirectory + '/dataImages';
    final imageDirectory = Directory(destinationPath);
    if (!await imageDirectory.exists()) {
      await imageDirectory.create(recursive: true);
    }

    final File savedImage = await _image.copy(destinationPath + '/' + _image.path.split('/').last);
    print('Saved image path success: ${savedImage.path}');
    notifyListeners();
    return savedImage.path;
  }

  @override
Widget build(BuildContext context) {
  var themeModeManager=Provider.of<ThemeModeManager>(context);
  return Consumer<DataImageProvider>(
    builder: (context, listImageData, child) {
      return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product Name Field
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Hãy nhập tên sản phẩm';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product Price Field
              TextFormField(
                controller: _productPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Giá sản phẩm',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hãy nhập giá sản phẩm';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Hãy nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image Selection Button
              TextButton.icon(
                icon: const Icon(Icons.image,color: Color.fromARGB(255, 66, 7, 184),),
                label: Text(isFilePicked ? 'Đã chọn ảnh' : 'Chọn ảnh'),
                onPressed: () async {
                  await pickImage();
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
             ElevatedButton(
  onPressed: _submitForm,
  style: ElevatedButton.styleFrom(
    backgroundColor: themeModeManager.isDark ? darkMode.primaryColor : lightMode.primaryColor,
    minimumSize: const Size(double.infinity, 50),
  ),
  child:  Text('Xác nhận', style: TextStyle(color: themeModeManager.isDark ? darkMode.textTheme.bodyMedium?.color : lightMode.textTheme.bodyMedium?.color ),),
),
            ],
          ),
        ),
      );
    },
  );
  }
}
