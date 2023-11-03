import 'dart:convert';

class AppSetting {
  bool firstTime;
  AppSetting({
    required this.firstTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstTime': firstTime,
    };
  }

  factory AppSetting.fromMap(Map<String, dynamic> map) {
    return AppSetting(
      firstTime: map['firstTime'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSetting.fromJson(String source) =>
      AppSetting.fromMap(json.decode(source));
}
