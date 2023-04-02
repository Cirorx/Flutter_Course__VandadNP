// Control the loading screen and the content

import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdadeLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdadeLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
