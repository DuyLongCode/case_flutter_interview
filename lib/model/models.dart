class CustomAttributes {
  final Label? label;
  final List<FormField>? form;
  final Button? button;
  final ProductList? productList;

  CustomAttributes({this.label, this.form, this.button, this.productList});

  factory CustomAttributes.fromJson(Map<String, dynamic> json) {
    return CustomAttributes(
      label: json['label'] != null ? Label.fromJson(json['label']) : null,
      form: json['form'] != null
          ? (json['form'] as List).map((i) => FormField.fromJson(i)).toList()
          : null,
      button: json['button'] != null ? Button.fromJson(json['button']) : null,
      productList: json['productlist'] != null
          ? ProductList.fromJson(json['productlist'])
          : null,
    );
  }
}

class Label {
  final String text;

  Label({required this.text});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(
      text: json['text'] ?? '',
    );
  }
}

class FormField {
  final String label;
  final bool required;
  final String name;
  final String type;
  final int? maxLength;
  final int? minValue;
  final int? maxValue;

  FormField({
    required this.label,
    required this.required,
    required this.name,
    required this.type,
    this.maxLength,
    this.minValue,
    this.maxValue,
  });

  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      label: json['label'] ?? '',
      required: json['required'] ?? false,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      maxLength: json['maxLength'],
      minValue: json['minValue'],
      maxValue: json['maxValue'],
    );
  }
}

class Button {
  final String text;

  Button({required this.text});

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      text: json['text'] ?? '',
    );
  }
}

class ProductList {
  final List<ProductItem> items;

  ProductList({required this.items});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<ProductItem> itemsList =
        itemsJson.map((i) => ProductItem.fromJson(i)).toList();
    return ProductList(
      items: itemsList,
    );
  }
}

class ProductItem {
  final String name;
  final double price;
  final String imageSrc;

  ProductItem({required this.name, required this.price, required this.imageSrc});

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageSrc: json['imageSrc'] ?? '',
    );
  }
}

class ApiResponse {
  final String code;
  final String message;
  final List<Data> data;

  ApiResponse({required this.code, required this.message, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<Data> dataList = dataJson.map((i) => Data.fromJson(i)).toList();
    return ApiResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: dataList,
    );
  }
}

class Data {
  final String type;
  final CustomAttributes customAttributes;

  Data({required this.type, required this.customAttributes});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      type: json['type'] ?? '',
      customAttributes: CustomAttributes.fromJson(json['customAttributes']),
    );
  }
}