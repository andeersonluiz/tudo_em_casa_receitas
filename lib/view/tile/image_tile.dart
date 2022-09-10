import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final BorderRadius borderRadius;
  const ImageTile(
      {required this.width,
      required this.height,
      required this.imageUrl,
      this.borderRadius = BorderRadius.zero,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 400),
            fit: BoxFit.cover,
            imageUrl: imageUrl,
            width: 1000,
            placeholder: (context, url) => Image.asset(
                  "assets/placeholderImage.gif",
                  fit: BoxFit.cover,
                ) // Your default image here
            ),
      ),
    );
  }
}
