import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final BorderRadius borderRadius;
  final bool isBorderCircle;
  final bool isFile;
  const ImageTile(
      {required this.width,
      required this.height,
      required this.imageUrl,
      this.isBorderCircle = false,
      this.isFile = false,
      this.borderRadius = BorderRadius.zero,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isBorderCircle
          ? const EdgeInsets.all(8)
          : EdgeInsets.zero, // Border width
      decoration: isBorderCircle
          ? const BoxDecoration(color: Colors.white, shape: BoxShape.circle)
          : const BoxDecoration(),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          height: height,
          child: isFile
              ? Image.file(File(imageUrl), width: 1000, fit: BoxFit.cover)
              : CachedNetworkImage(
                  cacheKey: imageUrl + DateTime.now().day.toString(),
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
      ),
    );
  }
}
