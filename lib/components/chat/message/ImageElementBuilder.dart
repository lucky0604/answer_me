import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:answer_me/utils/Util.dart';

class ImageElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    String src = element.attributes['src'].toString();
    if (src.startsWith('http')) {
      return FutureBuilder(
          future: Util.saveImageFromUrl(src),
          builder: (BuildContext content, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Image.file(File(snapshot.data.toString()));
            }
            return const CircularProgressIndicator();
          });
    }

    return Container(child: Text('![img](${element.attributes['src']})'));
  }
}
