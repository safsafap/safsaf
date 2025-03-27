import 'package:multi_vendor/models/categorie_model.dart';

class FornisseurModel {
  int id;
  String name, imagePath;
  FornisseurModel(
      {required this.id,
      required this.name,
      required this.imagePath,
      });

factory FornisseurModel.fromJson(Map<String, dynamic> json) {
    return FornisseurModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'].toString(),
      imagePath: json['image_path'].toString(),
    );
  }

  
}
