import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/cart_model.dart';

class Product {
  final int id;
  final String name;
  String price;
  final String description;
  final String quantiteLimite;
  final String discount;
  final String discountType;
  final int available;
  String imagePath;
  final int categorie;
  final int sousCategorie;
  final int stock;
  final int newer;
  bool discountCalcul = true;
  int realprice;
  final int min_commande;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.quantiteLimite,
      required this.discount,
      required this.discountType,
      required this.available,
      required this.imagePath,
      required this.categorie,
      required this.sousCategorie,
      required this.stock,
      required this.newer,
      this.min_commande = 1,
      this.discountCalcul = true,
      this.realprice = 0}) {
    if (discountCalcul) {
      realprice = double.tryParse(price)?.toInt() ?? 0;
      calcul();
      discountCalcul = false;
    }
  }

  Product.emptyProduct()
      : available = 1,
        discount = "0",
        categorie = 13,
        sousCategorie = 15,
        imagePath = "images/67cd72933a5f2-khbz-altakos.jpg",
        discountType = "fixed",
        quantiteLimite = "0",
        description = "",
        price = "1980",
        name = "Amor ben Amor",
        id = 86,
        realprice = 100,
        stock = 0,
        min_commande = 2,
        newer = 0;

  // Factory method to create a Product from a JSON map
  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        price: json['price'] ?? '',
        description: json['description'] ?? '',
        quantiteLimite: json['quantite_limite'] ?? '',
        discount: json['discount'] ?? '',
        discountType: json['discount_type'] ?? '',
        available: json['available'] ?? 1,
        imagePath: json['image_path'] ?? '',
        categorie: json['categorie'] ?? 0,
        sousCategorie: json['sous_categorie'] ?? 0,
        newer: json['new'] ?? 0,
        min_commande: int.tryParse(json['min_commander'].toString()) ?? 1,
        stock: int.parse(json['stock']));
  }

  // Method to convert a Product to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'quantite_limite': quantiteLimite,
      'discount': discount,
      'discount_type': discountType,
      'available': available,
      'image_path': imagePath,
      'categorie': categorie,
      'sous_categorie': sousCategorie,
      'stock': stock.toString(),
      'new': newer,
      'min_commander': min_commande,
    };
  }

  CartModel toCartModel() {
    discountCalcul = false;
    print("min_commander: $min_commande");
    return CartModel(
        quantity: min_commande,
        id: id,
        name: name,
        description: description,
        quantiteLimite: quantiteLimite,
        price: price,
        discount: discount,
        discountType: discountType,
        imagePath: imagePath,
        categorie: categorie,
        stock: stock,
        min_commande: min_commande,
        discountCalcul: false);
  }

  void calcul() {
    if (discount != "0") {
      double originalPrice = double.tryParse(price) ?? 0.0;
      double discountValue = double.tryParse(discount) ?? 0.0;

      if (discountType == "fixed") {
        // Fixed discount
        price = (originalPrice - discountValue).toStringAsFixed(2);
      } else {
        // Percentage discount
        price = (originalPrice - (originalPrice * discountValue / 100))
            .toStringAsFixed(2);
      }
    } else {
      // No discount
      price = double.tryParse(price)?.toStringAsFixed(2) ?? "0.00";
    }
  }
}
