import 'package:flutter/foundation.dart';
import '../model/enums.dart';

class ScreenInfo extends ChangeNotifier {
  ScreenType screenType;

  ScreenInfo({required this.screenType});

  updateScreen(ScreenInfo screenInfo) {
    screenType = screenInfo.screenType;

    notifyListeners();
  }
}
