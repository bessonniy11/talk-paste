import 'package:flutter/services.dart';

class TextPasteService {
  Future<void> pasteText(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      // For now, we only copy to clipboard.
      // Mimicking Ctrl+V might require platform-specific code or a different package,
      // as hotkey_manager does not directly support sending key presses.
      // Example (pseudo-code, not directly executable by Flutter):
      // await hotkeyManager.sendCombination(modifiers: [KeyModifier.control], keys: [LogicalKeyboardKey.keyV]);
    }
  }
}
