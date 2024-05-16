import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String message);

@immutable
class LoadingScreenCcontroller {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenCcontroller({
    required this.close,
    required this.update,
  });
}
