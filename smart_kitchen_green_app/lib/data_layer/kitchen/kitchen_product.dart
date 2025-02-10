import 'dart:io';

class Product {
  int? id = 0;
  String name;
  String quantity;
  String expiryDate;
  String barcode;
  String? type;
  String? appliance_time;
  String? created_at;

  Product.add(
      {required this.name,
      required this.quantity,
      required this.expiryDate,
      required this.barcode});

  Product.get(this.id, this.name, this.quantity, this.expiryDate, this.barcode,
      this.created_at, this.appliance_time, this.type);

  Map<String, dynamic> toJson() {
    return {
      'name': name.toString(),
      'quantity': quantity.toString(),
      'expiry_date': expiryDate.toString(),
      'barcode': barcode.toString(),
      'type': type,
      'appliance_time': appliance_time,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product.get(
        json['id'],
        json['name'],
        json['quantity'],
        json['expiry_date'],
        json['barcode'] ?? "",
        json['created_at'] ?? "",
        json['appliance_time'] ?? "",
        json['type'] ?? "");
  }
}

class Products {
  static List<Product> products = [];

  static void addProduct(Product product) {
    print("PRODUCT ADDED:${product}");

    print("ADDED");
    products.add(product);
    return;
  }

  static Product getProduct(int index) {
    return products[index];
  }

  static List<Product> getProducts() {
    return products;
  }

  static void cleanProducts() {
    products.clear();
  }
}
