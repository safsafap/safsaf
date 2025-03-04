import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/categorie_model.dart';
import 'package:multi_vendor/services/categorie_services.dart';
import 'package:should_rebuild/should_rebuild.dart';

import '../categorie_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ShouldRebuild(
      shouldRebuild: (oldWidget, newWidget) => false,
      child: FutureBuilder<List<Category>>(
        future: CategorieServices().getCategorie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, position) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MAIN_COLOR)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        child: ListTile(
                            onTap: () {
                              Get.to(() => CategorieScreen(
                                  category: snapshot.data![position]));
                            },
                            title: Text(snapshot.data![position].name),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            leading: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(IMAGES_ENDPOINT +
                                          snapshot.data![position].imagePath),
                                      fit: BoxFit.cover)),
                            )),
                      ));
            } else {
              return const Center(
                child: Text("there is no categories"),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(
              color: MAIN_COLOR,
            ),
          );
        },
      ),
    );
  }
}
