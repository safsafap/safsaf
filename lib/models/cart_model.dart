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
    required min_commande,
    required bool discountCalcul,
    required String quantiteLimite,
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
            min_commande: min_commande,
            sousCategorie: 0);

 factory CartModel.fromJson(Map<dynamic, dynamic> json) {
  return CartModel(
    discountCalcul: false,
    quantity: int.tryParse(json['quantite'].toString()) ?? (int.tryParse(json['min_commander']?.toString() ?? "2") ?? 2),
    id: int.tryParse(json['id']?.toString() ?? "0") ?? 0,
    name: json['name']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    price: json['price']?.toString() ?? "0",
    discount: json['discount']?.toString() ?? "0",
    discountType: json['discount_type']?.toString() ?? "fixed",
    imagePath: json['image_path']?.toString() ?? "",
    categorie: int.tryParse(json['categorie']?.toString() ?? "0") ?? 0,
    quantiteLimite: json['quantite_limite']?.toString() ?? "0",
    min_commande: int.tryParse(json['min_commander']?.toString() ?? "2") ?? 2,
    stock: int.tryParse(json['stock']?.toString() ?? "0") ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {'quantite': quantity};
    data.addAll(super.toJson());
    return data;
  }

  double get total => double.parse(price) * quantity;
}
