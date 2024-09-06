class ProfileSetting {
  String nickname;
  String avatar;
  ProfileSetting({
    this.nickname = 'You',
    this.avatar = '',
  });

  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'avatar': avatar,
      };

  static ProfileSetting fromJson(Map<String, dynamic> json) {
    return ProfileSetting(
      nickname: json['nickname'],
      avatar: json['avatar'],
    );
  }
}
