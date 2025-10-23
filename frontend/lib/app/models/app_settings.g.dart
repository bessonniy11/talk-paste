// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  hotkeyCombination: json['hotkeyCombination'] as String? ?? 'Control+Space',
  alwaysOnTop: json['alwaysOnTop'] as bool? ?? true,
  hideWidget: json['hideWidget'] as bool? ?? false,
  runAtStartup: json['runAtStartup'] as bool? ?? true,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'hotkeyCombination': instance.hotkeyCombination,
      'alwaysOnTop': instance.alwaysOnTop,
      'hideWidget': instance.hideWidget,
      'runAtStartup': instance.runAtStartup,
    };
