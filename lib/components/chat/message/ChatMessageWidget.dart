import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';

import 'package:answer_me/components/Avatar.dart';
import 'package:answer_me/components/chat/message/CodeHightlightView.dart';
import 'package:answer_me/components/chat/message/ImageElementBuilder.dart';

class ChatMessageWidget extends StatelessWidget {
  final String content;
  final String nickname;
  final bool isMe;
  final String avatar;
  final String time;

  ChatMessageWidget({
    required this.avatar,
    required this.content,
    required this.isMe,
    required this.nickname,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: Avatar(filePath: avatar, size: 40),
                ),
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(nickname, style: Theme.of(context).textTheme.labelSmall),
                  Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 660),
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: isMe ? Colors.green : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            )
                          ]),
                      child: SelectionArea(
                          child: MarkdownBody(
                        data: content,
                        selectable: true,
                        builders: {
                          "code": CodeElementBuilder(),
                          "img": ImageElementBuilder()
                        },
                      )))
                ],
              ),
              if (isMe)
                Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: Avatar(filePath: avatar, size: 40)),
            ]));
  }
}
