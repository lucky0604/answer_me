import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String filePath;
  final double size;

  const Avatar({super.key, required this.filePath, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: Colors.grey),
        clipBehavior: Clip.antiAlias,
        child: filePath.isEmpty
            ? const Icon(
                Icons.person,
                color: Colors.grey,
              )
            : Image.file(
                File(filePath),
                fit: BoxFit.cover,
              ));
  }
}
