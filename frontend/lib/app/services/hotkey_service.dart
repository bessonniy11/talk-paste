import 'package:flutter/foundation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:frontend/app/services/settings_service.dart';
import 'package:flutter/services.dart'; // For LogicalKeyboardKey

// class HotkeyService with ChangeNotifier {
//   final SettingsService _settingsService;
//   final HotkeyManager _hotkeyManager = HotkeyManager.instance;

//   Hotkey? _registeredHotkey;
//   bool _isHotkeyPressed = false;

//   bool get isHotkeyPressed => _isHotkeyPressed;

//   HotkeyService(this._settingsService);

//   Future<void> init() async {
//     await _hotkeyManager.unregisterAll();
//     _settingsService.addListener(_onSettingsChanged);
//     await _registerCurrentHotkey();
//   }

//   void dispose() {
//     _settingsService.removeListener(_onSettingsChanged);
//     _hotkeyManager.unregisterAll();
//     super.dispose();
//   }

//   void _onSettingsChanged() async {
//     await _updateHotkeyRegistration();
//   }

//   Future<void> _registerCurrentHotkey() async {
//     final hotkeyCombinationString = _settingsService.settings.hotkeyCombination;

//     List<KeyModifier> modifiers = [];
//     LogicalKeyboardKey? key;

//     if (hotkeyCombinationString.contains('Control')) {
//       modifiers.add(KeyModifier.control);
//     }
//     if (hotkeyCombinationString.contains('Shift')) {
//       modifiers.add(KeyModifier.shift);
//     }
//     if (hotkeyCombinationString.contains('Alt')) {
//       modifiers.add(KeyModifier.alt);
//     }
//     if (hotkeyCombinationString.contains('Meta')) {
//       modifiers.add(KeyModifier.meta);
//     }

//     if (hotkeyCombinationString.contains('Space')) {
//       key = LogicalKeyboardKey.space;
//     } else if (hotkeyCombinationString.contains('KeyA')) {
//       key = LogicalKeyboardKey.keyA;
//     }

//     if (key == null) {
//       debugPrint('No primary key found for hotkey combination: $hotkeyCombinationString');
//       return;
//     }

//     final hotkey = Hotkey(
//       keyCode: key,
//       modifiers: modifiers,
//     );

//     _registeredHotkey = hotkey;

//     await _hotkeyManager.register(hotkey,
//         keyDownHandler: (hotkey) {
//       _isHotkeyPressed = true;
//       notifyListeners();
//       debugPrint('Hotkey pressed: ${hotkey.keyCode}');
//     },
//         keyUpHandler: (hotkey) {
//       _isHotkeyPressed = false;
//       notifyListeners();
//       debugPrint('Hotkey released: ${hotkey.keyCode}');
//     });
//   }

//   Future<void> _updateHotkeyRegistration() async {
//     if (_registeredHotkey != null) {
//       await _hotkeyManager.unregister(_registeredHotkey!); 
//     }
//     await _registerCurrentHotkey();
//   }
// }

// Dummy HotkeyService to prevent errors for now
class HotkeyService with ChangeNotifier {
  final SettingsService _settingsService;
  bool _isHotkeyPressed = false;

  bool get isHotkeyPressed => _isHotkeyPressed;

  HotkeyService(this._settingsService);

  Future<void> init() async {
    _settingsService.addListener(_onSettingsChanged);
  }

  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {}
}
