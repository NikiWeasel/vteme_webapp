import 'package:flutter/cupertino.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:vteme_tg_miniapp/main.dart';

class ThemeModeNotifier extends ValueNotifier<bool> {
  ThemeModeNotifier({required BuildContext context})
      : super(_getIsDark(context));

  static bool _getIsDark(BuildContext context) {
    if (tgSupported) {
      return TelegramWebApp.instance.colorScheme == TelegramColorScheme.dark;
    } else {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  void updateTheme(BuildContext context) {
    value = _getIsDark(context);
  }
}
