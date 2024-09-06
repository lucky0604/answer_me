import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:answer_me/schemas/ChatItem.dart';

class ChatSettingController extends GetxController {
  Rx<ChatItem> currentChat = ChatItem(
    id: '-',
    name: 'New Chat',
    avatar: '',
    lastMessage: '',
    lastMessageTime: '',
    subtitle: 'Empty Description',
  ).obs;

  TextEditingController name_controller = TextEditingController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController system_controller = TextEditingController();
}
