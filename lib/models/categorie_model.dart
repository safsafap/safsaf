import 'package:multi_vendor/services/change_language.dart';

class Category {
  final int id;
  final String nameFr;
  final String nameAr;
  final String imagePath;
  final String slug;
  late String name;

  Category({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.imagePath,
    required this.slug,
    this.name = ''
  }) {
    Map<String, dynamic> lang = ChangeLanguage().getLanguage();
    if (lang['lang'] == 'fr') {
      name = nameFr;
    } else {
      name = nameAr;
    }
  }

  factory Category.fromJson(Map<String, dynamic> json) {
  
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nameFr: json['name_fr'].toString(),
      nameAr: json['name_ar'].toString(),
      imagePath: json['image_path'].toString(),
      slug: json['slug'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_fr': nameFr,
      'name_ar': nameAr,
      'image_path': imagePath,
      'slug': slug,
    };
  }

  Category.empty()
      : id = 0,
        nameAr = "hhhhhhh",
        nameFr = "hhhhhh",
        imagePath = "6496f743d21c3-huile-de-table.png",
        slug = "",name = "";
}
