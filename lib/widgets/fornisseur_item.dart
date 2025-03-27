import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/fornisseur_model.dart';
import 'package:multi_vendor/screens/categorie_screen.dart';
import 'package:multi_vendor/screens/fornisseur_product_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/categorie_model.dart';

class FornisseurItem extends StatelessWidget {
  FornisseurModel fornisseur;
  FornisseurItem({super.key, required this.fornisseur});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => FornisseurProductScreen(fornisseur: fornisseur));
      },
      child: Container(
        width: 85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          '$IMAGES_ENDPOINT${fornisseur.imagePath}'),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              fornisseur.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
