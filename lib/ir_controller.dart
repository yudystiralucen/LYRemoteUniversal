import 'package:flutter/services.dart';
import 'gree_ac.dart';
class IRController {
  static Future<bool> sendGree({
    required bool power,
    required int temperature,
    required String mode,
    required String fan,
    required bool swing,
  }) async {
    final pattern = GreeAcEncoder.buildPattern(
      power: power,
      temperature: temperature,
      mode: mode,
      fan: fan,
      swing: swing,
    );

    return transmit(
      frequency: GreeAcEncoder.frequency,
      pattern: pattern,
    );
  }
  
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
