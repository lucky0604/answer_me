import 'dart:io';

import 'package:answer_me/schemas/enums/ModelEnums.dart';
import 'package:bitmap/bitmap.dart';
import 'package:answer_me/native_interface/NativeScreenshot.dart';
import 'package:answer_me/utils/Util.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

typedef InputFinish = void Function(String message, String model);

class ChatInput extends StatelessWidget {
  InputFinish? onFinish;
  ChatInput({this.onFinish});

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  var selectModel = ModelEnums.models.first.obs;
  var selectedImage = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 252, 252, 252),
        height: 180,
        child: Column(children: [
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          Container(
              child: Row(children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.attach_file),
              tooltip: 'Attach file',
            ),
            IconButton(
              onPressed: () {
                Util.pickAndSaveImage().then((value) {
                  selectedImage.value = value;
                });
              },
              icon: Icon(Icons.camera_alt),
              tooltip: 'Attach Image',
            ),
            IconButton(
                onPressed: () {
                  var captureScreen = NativeScreenshot.captureScreen();
                  print(captureScreen.length);
                  Bitmap bitmap = Bitmap.fromHeadless(1024, 768, captureScreen);
                  var buildHeaded = bitmap.buildHeaded();
                  Util.saveImageFromBytes(buildHeaded).then(
                      (value) => {print(value), selectedImage.value = value});
                },
                icon: Icon(Icons.cut),
                tooltip: 'Cut'),
            Expanded(child: Container()),
            Obx(() => DropdownButton<Model>(
                  value: selectModel.value,
                  items: ModelEnums.models.map((Model value) {
                    return DropdownMenuItem<Model>(
                        value: value, child: Text(value.displayName));
                  }).toList(),
                  underline: Container(),
                  onChanged: (newValue) {
                    selectModel.value = newValue!;
                  },
                )),
          ])),
          Expanded(
              child: Column(children: [
            Obx(() => selectedImage.value.isEmpty
                ? Container()
                : Container(
                    height: 50,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [showSelectedImage()],
                    ))),
            Expanded(
                child: ListView(children: [
              Container(
                  child: RawKeyboardListener(
                      focusNode: focusNode,
                      onKey: handleKeyPress,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText:
                              'Type a message, press Enter to send, press Shit + Enter to newline',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        style: const TextStyle(fontSize: 12),
                        maxLines: null,
                        minLines: 1,
                        controller: controller,
                      )))
            ]))
          ]))
        ]));
  }

  void handleKeyPress(event) {
    if (event is RawKeyUpEvent) {
      if (event.logicalKey.keyLabel == "Enter" && !event.isShiftPressed) {
        final val = controller.value;
        final messageWithoutNewLine =
            controller.text.substring(0, val.selection.start - 1) +
                controller.text.substring(val.selection.start);

        controller.value = TextEditingValue(
            text: messageWithoutNewLine,
            selection: TextSelection.fromPosition(
                TextPosition(offset: messageWithoutNewLine.length)));
        String text = controller.text;
        controller.clear();
        if (onFinish != null) {
          onFinish!(text, selectModel.value.name);
        }
      }
    }
  }

  Widget showSelectedImage() {
    return Container(
        height: 50,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(children: [
          Image.file(File(selectedImage.value),
              width: 44, height: 44, fit: BoxFit.cover),
          const SizedBox(
            width: 5,
          ),
          SizedBox(
              height: 18,
              width: 18,
              child: IconButton(
                onPressed: () {
                  selectedImage.value = '';
                },
                padding: EdgeInsets.zero,
                icon: Icon(Icons.close),
                iconSize: 12,
                tooltip: 'Delete the image',
              ))
        ]));
  }
}
