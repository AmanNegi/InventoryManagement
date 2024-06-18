import 'package:flutter/material.dart';
import 'package:inv_mgmt_client/widgets/cached_image_view.dart';

class ImgFullView extends StatelessWidget {
  final String src;
  const ImgFullView({
    Key? key,
    required this.src,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: InteractiveViewer(
        child: Center(
          child: CachedImageView(
            src,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
