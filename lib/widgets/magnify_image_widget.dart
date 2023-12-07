import 'dart:ui';

import 'package:flutter/material.dart';

class MagnifyImage extends StatelessWidget {
  final Image image;
  final VoidCallback onClose;

  const MagnifyImage({
    super.key,
    required this.image,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Center(
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}
