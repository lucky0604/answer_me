import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:answer_me/controller/ChatHistoryController.dart';
import 'package:answer_me/components/chat/ChatListItem.dart';

class ChatHistoryList extends StatelessWidget {
  ChatHistoryController controller = Get.put(ChatHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (context, index) {
          return ChatListItem(item: controller.items[index]);
        },
      );
    });
  }
}
