class ApiSetting {
  String accessToken;
  String baseUrl;
  bool isCustom;

  ApiSetting({
    this.accessToken = '',
    this.baseUrl = '',
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'baseUrl': baseUrl,
        'isCustom': isCustom,
      };

  static ApiSetting fromJson(Map<String, dynamic> json) {
    return ApiSetting(
      accessToken: json['accessToken'],
      baseUrl: json['baseUrl'],
      isCustom: json['isCustom'],
    );
  }
}
