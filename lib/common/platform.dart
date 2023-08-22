import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;


class PlatformUtils {
  PlatformUtils._internal();

  static final PlatformUtils instance = PlatformUtils._internal();

  get isDesktop {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isMacOS || Platform.isWindows || Platform.isLinux || Platform.isFuchsia;
    }
  }

  get isMobile {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isAndroid || Platform.isIOS;
    }
  }
}