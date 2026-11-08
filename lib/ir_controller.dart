import 'package:flutter/services.dart';

class IRController {
  static const MethodChannel _channel =
      MethodChannel('com.lyremote.universal/ir');

  static Future<bool> hasIrEmitter() async {
    try {
      return await _channel.invokeMethod<bool>(
            'hasIrEmitter',
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<bool> transmit({
    required int frequency,
    required List<int> pattern,
  }) async {
    try {
      return await _channel.invokeMethod<bool>(
            'transmit',
            {
              'frequency': frequency,
              'pattern': pattern,
            },
          ) ??
          false;
    } on PlatformException {
      return false;
    }
  }
}
