import 'package:multi_vendor/models/product_model.dart';

class CartModel extends Product {
  int quantity;
  CartModel({
    required this.quantity,
    required int id,
    required String name,
    required String description,
    required String price,
    required String discount,
    required String discountType,
    required String imagePath,
    required int categorie,
    required int stock,
    required bool discountCalcul, required String quantiteLimite,
  }) : super(
            discountCalcul: false,
            id: id,
            name: name,
            price: price,
            description: description,
            quantiteLimite: quantiteLimite,
            discount: discount,
            discountType: discountType,
            available: 1,
            imagePath: imagePath,
            categorie: categorie,
            stock: stock,
            newer: 0,
            sousCategorie: 0);

  factory CartModel.fromJson(Map<dynamic, dynamic> json) {
    return CartModel(
        discountCalcul: false,
        quantity: json['quantite'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        discount: json['discount'],
        discountType: json['discount_type'],
        imagePath: json['image_path'],
        categorie: json['categorie'],
        quantiteLimite: json['quantite_limite']??"0",
        stock: int.parse(json['stock']));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {'quantite': quantity};
    data.addAll(super.toJson());
    return data;
  }

  double get total => double.parse(price) * quantity;
}
