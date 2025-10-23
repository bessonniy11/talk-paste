import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app/services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _hotkeyController;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsService>(context, listen: false).settings;
    _hotkeyController = TextEditingController(text: settings.hotkeyCombination);
  }

  @override
  void dispose() {
    _hotkeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<SettingsService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки TalkPaste'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => appWindow.close(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotkey combination input
            Text(
              'Комбинация клавиш для активации',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _hotkeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Например, Ctrl+Space',
              ),
              onChanged: (value) {
                settingsService.updateSettings(hotkeyCombination: value);
              },
            ),
            const SizedBox(height: 20),

            // Always on top checkbox
            CheckboxListTile(
              title: const Text('Показывать поверх всех окон'),
              value: settingsService.settings.alwaysOnTop,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  settingsService.updateSettings(alwaysOnTop: newValue);
                }
              },
            ),
            const SizedBox(height: 20),

            // Hide widget checkbox
            CheckboxListTile(
              title: const Text('Скрыть виджет'),
              value: settingsService.settings.hideWidget,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  settingsService.updateSettings(hideWidget: newValue);
                }
              },
            ),
            const SizedBox(height: 20),

            // Run at startup checkbox
            CheckboxListTile(
              title: const Text('Запускать при старте Windows'),
              value: settingsService.settings.runAtStartup,
              onChanged: (bool? newValue) {
                if (newValue != null) {
                  settingsService.updateSettings(runAtStartup: newValue);
                  // In the future, call StartupService.enableAutoStart() or disableAutoStart()
                }
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                appWindow.close(); // Close settings window
              },
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
    );
  }
}
