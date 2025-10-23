import 'package:frontend/app/services/settings_service.dart';
import 'package:window_manager/window_manager.dart';

class WindowManagementService {
  final SettingsService _settingsService;

  WindowManagementService(this._settingsService);

  Future<void> init() async {
    _settingsService.addListener(_onSettingsChanged);
    await _updateAlwaysOnTop();
  }

  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
  }

  void _onSettingsChanged() {
    _updateAlwaysOnTop();
  }

  Future<void> _updateAlwaysOnTop() async {
    await windowManager.setAlwaysOnTop(_settingsService.settings.alwaysOnTop);
  }
}
