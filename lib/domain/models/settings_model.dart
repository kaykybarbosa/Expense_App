import 'dart:convert';

class SettingsModel {
  SettingsModel({this.isDark = false});

  final bool isDark;

  factory SettingsModel.fromJson(String source) => SettingsModel.fromMap(json.decode(source));

  factory SettingsModel.fromMap(Map<String, dynamic> map) => SettingsModel(isDark: map['isDark']);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {'isDark': isDark};

  SettingsModel copyWith({bool? isDark}) => SettingsModel(isDark: isDark ?? this.isDark);
}
