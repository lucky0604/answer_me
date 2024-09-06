import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:answer_me/components/Avatar.dart';
import 'package:answer_me/controller/SettingController.dart';
import 'package:answer_me/utils/Util.dart';

class SettingView extends StatelessWidget {
  Color iconColor = const Color.fromARGB(255, 127, 92, 180);
  Color textColor = const Color.fromARGB(255, 168, 126, 236);
  Color selectColor = const Color.fromARGB(255, 103, 51, 145);
  Color bgDarkColor = const Color.fromARGB(255, 54, 37, 79);

  Color bgColor = const Color.fromARGB(150, 64, 46, 88);

  Rx<String> selectMenu = 'Profile'.obs;

  SettingController controller = Get.put(SettingController());

  FocusNode _nicknameFocusNode = FocusNode();
  TextEditingController _nickname_controller = TextEditingController();

  FocusNode _accessTokenFocusNode = FocusNode();
  TextEditingController _accessToken_controller = TextEditingController();

  FocusNode _baseUrlFocusNode = FocusNode();
  TextEditingController _baseUrl_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nickname_controller.text =
        controller.setting.value.profileSetting.nickname;
    _nicknameFocusNode.addListener(() {
      controller.setting.update((val) {
        val!.profileSetting.nickname = _nickname_controller.text;
      });
      Util.writeFile('setting.json', jsonEncode(controller.setting.value));
    });

    _accessToken_controller.text =
        controller.setting.value.apiSetting.accessToken;
    _accessTokenFocusNode.addListener(() {
      controller.setting.update((val) {
        val!.apiSetting.accessToken = _accessToken_controller.text;
      });
      Util.writeFile('setting.json', jsonEncode(controller.setting.value));
    });

    _baseUrl_controller.text = controller.setting.value.apiSetting.baseUrl;
    _baseUrlFocusNode.addListener(() {
      controller.setting.update((val) {
        val!.apiSetting.baseUrl = _baseUrl_controller.text;
      });
      Util.writeFile('setting.json', jsonEncode(controller.setting.value));
    });

    return Row(children: [
      Container(
          width: 240,
          color: bgColor,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(width: 1, color: bgDarkColor))),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const SafeArea(
                      child: Row(children: [
                    Text('Settings', style: TextStyle(color: Colors.white)),
                  ]))),
            ),
            Expanded(
                child: ListView(children: [
              Obx(() => buildItem('Profile', Icons.person)),
              Obx(() => buildItem('Api Settings', Icons.chat)),
              Obx(() => buildItem('About & Help', Icons.help)),
            ]))
          ])),
      Expanded(
          child: Container(
              color: Colors.white,
              child: Obx(() {
                if (selectMenu.value == 'Profile') {
                  return Container(
                      padding: const EdgeInsets.all(20),
                      child: ListView(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Stack(children: [
                          MaterialButton(
                              onPressed: () {
                                Util.pickAndSaveImage().then((value) {
                                  controller.setting.update((val) {
                                    val!.profileSetting.avatar = value;
                                  });
                                  Util.writeFile('settings.json',
                                      jsonEncode(controller.setting.value));
                                });
                              },
                              shape: const CircleBorder(),
                              child: Avatar(
                                filePath: controller
                                    .setting.value.profileSetting.avatar,
                                size: 80,
                              )),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      color: Colors.grey, size: 20)))
                        ])),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'Please enter your nickname',
                              labelText: 'Nickname',
                              prefixIcon: Icon(Icons.person, color: iconColor),
                              helperText:
                                  'Your nickname will be displayed to chat partners',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: textColor, width: 1),
                                  borderRadius: BorderRadius.circular(10))),
                          controller: _nickname_controller,
                          focusNode: _nicknameFocusNode,
                        )
                      ]));
                } else if (selectMenu.value == 'Api Settings') {
                  return Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: ListView(children: [
                        Container(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: const Offset(0.0, 1.0),
                                        blurRadius: 8.0,
                                        spreadRadius: 0.0,
                                      )
                                    ]),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('LLM API Settings',
                                          style: TextStyle(
                                              color: textColor, fontSize: 20)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(
                                            labelText: 'Select a server',
                                            prefixIcon: Icon(Icons.chat,
                                                color: iconColor),
                                            helperText:
                                                'Select a server to connect to the chat service',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: textColor, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        selectedItemBuilder:
                                            (BuildContext context) {
                                          return ['OpenAI', 'Custom']
                                              .map((String value) {
                                            return Text(value);
                                          }).toList();
                                        },
                                        alignment: Alignment.topLeft,
                                        value: controller.setting.value
                                                .apiSetting.isCustom
                                            ? 'Custom'
                                            : 'OpenAI',
                                        items: const [
                                          DropdownMenuItem(
                                              value: 'OpenAI',
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('OpenAI'),
                                                    Text(
                                                        'https://api.openai.com',
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ])),
                                          DropdownMenuItem(
                                              value: 'Custom',
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Custom'),
                                                    Text(
                                                        'https://api.example.com',
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ]))
                                        ],
                                        onChanged: (value) {
                                          controller.setting.update((val) {
                                            val!.apiSetting.isCustom =
                                                value == 'Custom';
                                          });
                                          Util.writeFile(
                                              'settings.json',
                                              jsonEncode(
                                                  controller.setting.value));
                                        },
                                      ),
                                      if (controller
                                          .setting.value.apiSetting.isCustom)
                                        Column(children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: textColor,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText:
                                                    'Please enter your API base URL',
                                                labelText:
                                                    'Custom API Base URL',
                                                helperText:
                                                    'Your API base URL will be used to access the chat service',
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: textColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            controller: _baseUrl_controller,
                                            focusNode: _baseUrlFocusNode,
                                          )
                                        ]),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          hintText:
                                              'Please enter your AccessToken',
                                          labelText: 'AccessToken',
                                          prefixIcon:
                                              Icon(Icons.key, color: iconColor),
                                          helperText:
                                              'Your AccessToken will be used to access the chat service.',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: textColor, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        controller: _accessToken_controller,
                                        focusNode: _accessTokenFocusNode,
                                      )
                                    ])))
                      ]));
                } else if (selectMenu.value == 'About & Help') {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.api,
                            color: iconColor,
                          ),
                          title: Text(
                            'Version',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            '1.0.0',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: iconColor,
                          ),
                          title: Text(
                            'About',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            'ChatGPT Desktop is a desktop client for ChatGPT, which is a chatbot developed by OpenAI.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.help,
                            color: iconColor,
                          ),
                          title: Text(
                            'Help',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            'If you have any questions or find a bug, please contact GitHub lssues.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.code,
                            color: iconColor,
                          ),
                          title: Text(
                            'Source Code',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            ' https://github.com/onlyGuo/chatgpt_desktop',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Icon(
                                Icons.question_answer,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Question',
                                style: TextStyle(color: textColor),
                              )
                            ],
                          ),
                          subtitle: Text(
                            """1. How to use the chatbot?
You need to select an API provider in the API Settings, and then enter the AccessToken. After that, you can start chatting with the chatbot.
  
2. How to add a chatbot?
Click the "Add" button above the chat list, and then select the chatbot you want to add.

3. I from China, how to use the chatbot?
You can use the custom API provider, and then enter the custom API base URL. For example, you can use the (iCoding or ChatAnyWhere) API provider, and then enter the API base URL: https://api.icoding.ink. if you don't have an AccessToken, you can get it here: https://dev.icoding.ink.
""",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(color: Colors.white);
              })))
    ]);
  }

  Widget buildItem(String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: selectMenu.value == name
            ? selectColor.withOpacity(0.3)
            : Colors.transparent,
        border: Border(
          left: BorderSide(
            color: selectMenu.value == name ? selectColor : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: MaterialButton(
        onPressed: () {
          selectMenu.value = name;
        },
        child: ListTile(
          title: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
          leading: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
