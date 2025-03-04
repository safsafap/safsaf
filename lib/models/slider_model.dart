import 'package:multi_vendor/main_constant.dart';

class SliderModel {
  final int id;
  final String imageUrl;

  SliderModel({
    required this.id,
    required this.imageUrl,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'],
      imageUrl: json['image_path'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imageUrl,
    };
  }

  SliderModel.empty()
      : id = 0,
        imageUrl = "${IMAGES_ENDPOINT}64e7ee60b873f.jpg";
}
