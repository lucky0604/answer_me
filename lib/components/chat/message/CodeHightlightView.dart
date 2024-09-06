import 'package:flutter/material.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:markdown/markdown.dart' as md;

import 'package:answer_me/components/chat/message/my_flutter_highlighter.dart';

class CodeHighlightView extends StatefulWidget {
  final String content;
  final String lang;

  const CodeHighlightView(
      {super.key, required this.content, required this.lang});

  @override
  State<CodeHighlightView> createState() => _CodeHighlightViewState();
}

class _CodeHighlightViewState extends State<CodeHighlightView> {
  @override
  Widget build(BuildContext context) {
    return MyHighlightView(widget.content,
        language: widget.lang,
        theme: atomOneDarkTheme,
        padding: const EdgeInsets.all(8),
        textStyle: const TextStyle(fontSize: 14));
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(0);
    } else {
      language = 'plaintext';
    }

    if (element.children != null &&
        element.children?.length == 1 &&
        !element.textContent.contains('\n')) {
      return Container(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
        margin: const EdgeInsets.only(top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(220, 220, 220, 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(element.textContent),
      );
    }

    return CodeHighlightView(
      content: element.textContent.endsWith('\n')
          ? element.textContent.substring(0, element.textContent.length - 1)
          : element.textContent,
      lang: language,
    );
  }
}
