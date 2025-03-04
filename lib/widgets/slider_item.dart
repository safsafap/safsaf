import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/slider_model.dart';

class SliderItem extends StatelessWidget {
  SliderModel slider;
  SliderItem({super.key, required this.slider});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.4,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    SLIDERS_IMAGES_ENDPOINT + slider.imageUrl),
                fit: BoxFit.fill)));
  }
}
