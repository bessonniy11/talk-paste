import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

// class SystemTrayService {
//   final AppWindow _appWindow = appWindow;
//   final SystemTray _systemTray = SystemTray();

//   VoidCallback? onSettingsRequested;

//   Future<void> init() async {
//     final Menu menu = Menu();
//     await menu.buildFrom([
//       MenuItem(label: 'Настройки', onClicked: (menuItem) async {
//         onSettingsRequested?.call();
//       }),
//       MenuItem(label: 'Выход', onClicked: (menuItem) async {
//         await _appWindow.close();
//       }),
//     ]);

//     await _systemTray.initSystemTray(
//       iconPath: defaultTargetPlatform == TargetPlatform.windows
//           ? 'assets/icon.ico'
//           : 'assets/icon.svg',
//       toolTip: "TalkPaste",
//     );

//     _systemTray.setContextMenu(menu);
//     _systemTray.registerSystemTrayEventHandler((eventName) {
//       debugPrint("eventName: $eventName");
//       if (eventName == "rightMouseDown") {
//         _systemTray.popUpContextMenu();
//       } else if (eventName == "click") {
//         _appWindow.show();
//         windowManager.focus();
//       }
//     });
//   }

//   Future<void> dispose() async {
//     // No explicit dispose for system_tray needed
//   }
// }

// Dummy SystemTrayService to prevent errors for now
class SystemTrayService {
  // Callback to be set by main.dart to open settings
  VoidCallback? onSettingsRequested;

  Future<void> init() async {
    // Dummy init
  }

  Future<void> dispose() async {
    // Dummy dispose
  }
}
