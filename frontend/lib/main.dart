import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app/services/settings_service.dart';
import 'package:frontend/app/services/window_management_service.dart';
import 'package:frontend/app/services/speech_recognition_service.dart';
import 'package:frontend/app/services/hotkey_service.dart';
import 'package:frontend/app/services/text_paste_service.dart';
import 'package:frontend/app/services/system_tray_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:frontend/app/ui/screens/settings_screen.dart'; // Import SettingsScreen
import 'package:frontend/app/ui/widgets/talkpaste_widget.dart'; // Import TalkPasteWidget

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  final windowManagementService = WindowManagementService(settingsService);
  await windowManagementService.init();

  final speechRecognitionService = SpeechRecognitionService();
  await speechRecognitionService.init();

  // final hotkeyService = HotkeyService(settingsService); // Commented out
  // await hotkeyService.init(); // Commented out

  final textPasteService = TextPasteService();

  // final systemTrayService = SystemTrayService(); // Commented out
  // await systemTrayService.init(); // Commented out
  // systemTrayService.onSettingsRequested = () { // Commented out
  //   appWindow.show();
  //   windowManager.focus();
  //   if (appNavigatorKey.currentContext != null) {
  //     showDialog(
  //       context: appNavigatorKey.currentContext!,
  //       builder: (context) => const SettingsScreen(),
  //     );
  //   }
  // };

  // hotkeyService.addListener(() async { // Commented out
  //   if (hotkeyService.isHotkeyPressed) {
  //     speechRecognitionService.startListening();
  //   } else {
  //     speechRecognitionService.stopListening();
  //     if (speechRecognitionService.recognizedText.isNotEmpty) {
  //       await textPasteService.pasteText(speechRecognitionService.recognizedText);
  //     }
  //   }
  // });

  WindowOptions windowOptions = const WindowOptions(
    size: Size(100, 10), // Changed size to 100 width and 10 height
    center: false,
    backgroundColor: Colors.transparent,
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setAsFrameless();
    await windowManager.setHasShadow(false);
    await windowManager.show();
    await windowManager.focus();

    appWindow.minSize = const Size(100, 10); // Minimum size for our widget
    appWindow.maxSize = const Size(100, 10); // Max size will also be 100x100 for now
    appWindow.size = const Size(100, 10);
    appWindow.alignment = Alignment.bottomRight;
    appWindow.show();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(
          value: settingsService,
        ),
        ChangeNotifierProvider<SpeechRecognitionService>.value(
          value: speechRecognitionService,
        ),
        // HotkeyService is temporarily commented out
      ],
      child: MyApp(navigatorKey: appNavigatorKey),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkPaste',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        canvasColor: Colors.transparent, // Make MaterialApp background transparent
        scaffoldBackgroundColor: Colors.transparent, // Make Scaffold background transparent
      ),
      home: const TalkPasteWidget(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return ColoredBox(
          color: Colors.transparent,
          child: child,
        );
      },
    );
  }
}
