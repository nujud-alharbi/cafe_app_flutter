// To parse this JSON data, do
//
//     final prodect = prodectFromJson(jsonString);

import 'dart:convert';

Prodect prodectFromJson(String str) => Prodect.fromJson(json.decode(str));

String prodectToJson(Prodect data) => json.encode(data.toJson());

class Prodect {
  Prodect({
    this.productNumber,
    required this.productName,
    required this.category,
    required this.quantity,
    required this.price,
    required this.description,
    required this.imageUrl,

  });

  String? productNumber;
  final String productName;
  final String category;
  late final int quantity;
  final double price;
  final String description;
  String imageUrl;

  factory Prodect.fromJson(Map<String, dynamic> json) => Prodect(

        productNumber: json["productNumber"],
        productName: json["productName"],
        category: json["category"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
        description: json["description"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "productNumber": productNumber,
        "productName": productName,
        "category": category,
        "quantity": quantity,
        "price": price,
        "description": description,
        "imageUrl": imageUrl,
      };
}



CartModels cartFromJson(String str) => CartModels.fromJson(json.decode(str));

String cartToJson(Prodect data) => json.encode(data.toJson());
class CartModels {

  String? productNumber;
  // String? tableNumber;
 String? nameOrder;
  // String? note ;

  int? quantity;
  double? price;
 // String? category;
  String? imageUrl;
  CartModels({
    this.productNumber,

    this.nameOrder,

    this.quantity,
    this.price,

    this.imageUrl,

  });


  factory CartModels.fromJson(Map<String, dynamic> json) => CartModels(

    productNumber: json["productNumber"],
    nameOrder: json["productName"],

    quantity: json["quantity"],
    price: json["price"].toDouble(),

    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "productNumber": productNumber,
    "productName": nameOrder,

    "quantity": quantity,
    "price": price,

    "imageUrl": imageUrl,
  };



}


