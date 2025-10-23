import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings {
  String hotkeyCombination;
  bool alwaysOnTop;
  bool hideWidget;
  bool runAtStartup;

  AppSettings({
    this.hotkeyCombination = 'Control+Space', // Default value
    this.alwaysOnTop = true,
    this.hideWidget = false,
    this.runAtStartup = true,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  // Helper to copy settings (useful for immutable state management)
  AppSettings copyWith({
    String? hotkeyCombination,
    bool? alwaysOnTop,
    bool? hideWidget,
    bool? runAtStartup,
  }) {
    return AppSettings(
      hotkeyCombination: hotkeyCombination ?? this.hotkeyCombination,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      hideWidget: hideWidget ?? this.hideWidget,
      runAtStartup: runAtStartup ?? this.runAtStartup,
    );
  }
}
