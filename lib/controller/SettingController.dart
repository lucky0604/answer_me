import 'dart:convert';
import 'package:get/get.dart';

import 'package:answer_me/schemas/ApiSetting.dart';
import 'package:answer_me/schemas/ProfileSetting.dart';
import 'package:answer_me/schemas/Setting.dart';
import 'package:answer_me/utils/Util.dart';

class SettingController extends GetxController {
  Rx<Setting> setting =
      Setting(profileSetting: ProfileSetting(), apiSetting: ApiSetting()).obs;

  @override
  void onInit() {
    super.onInit();
    Util.readFile('settings.json').then((value) {
      if (value.isEmpty) {
        value = jsonEncode(Setting(
            profileSetting: ProfileSetting(), apiSetting: ApiSetting()));
        Util.writeFile('settings.json', value);
      }
      setting.value = Setting.fromJson(jsonDecode(value));
    });
  }
}
