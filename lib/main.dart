import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:answer_me/components/MainMenu.dart';
import 'package:answer_me/controller/MainMenuController.dart';
import 'package:answer_me/utils/Util.dart';
import 'package:answer_me/views/AppsView.dart';
import 'package:answer_me/views/ChatsView.dart';
import 'package:answer_me/views/FriendsView.dart';
import 'package:answer_me/views/GithubView.dart';
import 'package:answer_me/views/SettingView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  if (!Platform.isLinux) {
    if (Platform.isWindows) {
      await Window.setEffect(
          effect: WindowEffect.solid, color: Colors.transparent);

      if (Platform.operatingSystemVersion.contains('(')) {
        var version = Platform.operatingSystemVersion
            .split('(')[1]
            .split(')')[0]
            .toLowerCase()
            .replaceAll('build', '')
            .trim();
        if (int.parse(version) > 19045) {
          await Window.setEffect(
              effect: WindowEffect.acrylic, color: Colors.transparent);
        }
      }
    } else {
      await Window.setEffect(
          effect: WindowEffect.acrylic, color: Colors.transparent);
    }
  }

  appWindow.size = const Size(1000, 650);
  runApp(const MyApp());
  appWindow.show();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(900, 600);
    win.minSize = initialSize;
    win.size = appWindow.size;
    win.alignment = Alignment.center;
    win.title = 'Answer Me';
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.transparent,
            body: Row(children: [
              LeftSide(
                child: MainMenu(),
              ),
              RightSide()
            ])));
  }
}

class LeftSide extends StatelessWidget {
  final Widget child;
  const LeftSide({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 65,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(170, 53, 36, 77),
                Color.fromARGB(170, 53, 36, 77)
              ],
            )),
            child: Column(children: [Expanded(child: child)])));
  }
}

class RightSide extends StatelessWidget {
  final MainMenuController controller = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(alignment: AlignmentDirectional.topStart, children: [
      Container(
          color: Colors.transparent,
          child: Obx(() {
            if (controller.active.value == 'chats') {
              return ChatsView();
            }
            if (controller.active.value == 'apps') {
              return AppsView();
            }
            if (controller.active.value == 'friends') {
              return FriendsView();
            }
            if (controller.active.value == 'setting') {
              return SettingView();
            }
            if (controller.active.value == 'github') {
              return GithubView();
            }
            return Container(child: Text("No view selected"));
          })),
      Column(children: [
        WindowTitleBarBox(
            child: Row(children: [
          Expanded(child: MoveWindow()),
          const WindowButtons()
        ]))
      ])
    ]));
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Colors.black,
    mouseOver: const Color.fromARGB(255, 224, 224, 224),
    mouseDown: const Color.fromARGB(255, 202, 202, 202),
    iconMouseOver: Colors.black,
    iconMouseDown: Colors.black);

final closeButtonColors = WindowButtonColors(
    mouseOver: Colors.red,
    mouseDown: const Color.fromARGB(255, 206, 54, 43),
    iconNormal: Colors.black,
    iconMouseOver: Colors.black);

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() async {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      MinimizeWindowButton(colors: buttonColors),
      appWindow.isMaximized
          ? RestoreWindowButton(
              colors: buttonColors, onPressed: maximizeOrRestore)
          : MaximizeWindowButton(
              colors: buttonColors, onPressed: maximizeOrRestore),
      CloseWindowButton(colors: closeButtonColors)
    ]);
  }
}
