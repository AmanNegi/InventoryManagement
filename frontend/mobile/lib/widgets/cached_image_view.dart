import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageView extends StatelessWidget {
  final String url;
  final double width, height;
  final BoxFit fit;

  const CachedImageView(
    this.url, {
    super.key,
    this.width = double.maxFinite,
    this.height = double.maxFinite,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.error,
      ),
    );
  }
}
