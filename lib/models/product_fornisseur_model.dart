import 'package:multi_vendor/models/product_model.dart';

class ProductFornisseurModel extends Product {
  int fornisseurId;
  ProductFornisseurModel(
      {required super.id,
      required super.name,
      required super.price,
      required super.description,
      required super.imagePath,
      required this.fornisseurId,
      required super.quantiteLimite,
      required super.discount,
      required super.discountType,
      required super.available,
      required super.categorie,
      required super.sousCategorie,
      required super.stock,
      required super.min_commande,
      required super.newer});

  factory ProductFornisseurModel.fromJson(Map<String, dynamic> json) {
    return ProductFornisseurModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'].toString(),
      price: json['price'].toString(),
      description: json['description'].toString(),
      imagePath: json['image_path'].toString(),
      fornisseurId: int.tryParse(json['fornisseur_id'].toString()) ?? 0,
      quantiteLimite: json['quantite_limite'].toString(),
      discount: json['discount'].toString(),
      discountType: json['discount_type'].toString(),
      available: int.tryParse(json['available'].toString()) ?? 0,
      categorie: int.tryParse(json['categorie'].toString()) ?? 0,
      sousCategorie: int.tryParse(json['sous_categorie'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      newer: int.tryParse(json['newer'].toString()) ?? 0,
      min_commande: int.tryParse(json['min_commande'].toString()) ?? 2,
    );
  }
}
