import 'package:flutter/material.dart';

class GlobalKeys {
  static final GlobalKeys _globalKeys = GlobalKeys._internal();

  factory GlobalKeys() {
    return _globalKeys;
  }

  GlobalKeys._internal();

  static const GlobalKey portfolioKey = GlobalObjectKey('portfolio');
  
}
