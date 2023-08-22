import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

setOverlayStyleInAndroid() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
}
