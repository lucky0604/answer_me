import 'package:answer_me/schemas/ApiSetting.dart';
import 'package:answer_me/schemas/ProfileSetting.dart';

class Setting {
  ProfileSetting profileSetting;
  ApiSetting apiSetting;
  Setting({
    required this.profileSetting,
    required this.apiSetting,
  });

  Map<String, dynamic> toJson() => {
        'profileSetting': profileSetting.toJson(),
        'apiSetting': apiSetting.toJson(),
      };

  static Setting fromJson(Map<String, dynamic> json) {
    return Setting(
      profileSetting: ProfileSetting.fromJson(json['profileSetting']),
      apiSetting: ApiSetting.fromJson(json['apiSetting']),
    );
  }
}
