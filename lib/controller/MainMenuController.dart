import 'package:get/get.dart';

class MainMenuController extends GetxController {
  var active = 'chats'.obs;
  void open(String menu) => {active.value = menu};
}
