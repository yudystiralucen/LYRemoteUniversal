
/// Gree 8-byte infrared protocol encoder.
/// Initial compatibility profile: Gree YAW1F.
/// Carrier frequency: 38 kHz.
class GreeAcEncoder {
  static const int frequency = 38000;

  static const int _headerMark = 9000;
  static const int _headerSpace = 4500;
  static const int _bitMark = 620;
  static const int _oneSpace = 1600;
  static const int _zeroSpace = 540;
  static const int _messageGap = 19980;

  static List<int> buildPattern({
    required bool power,
    required int temperature,
    required String mode,
    required String fan,
    required bool swing,
    bool light = true,
    bool sleep = false,
    bool turbo = false,
    bool xfan = false,
  }) {
    final modeBits = switch (mode) {
      'Cool' => 1,
      'Dry' => 2,
      'Fan' => 3,
      'Heat' => 4,
      _ => 0,
    };

    final fanBits = switch (fan) {
      'Low' => 1,
      'Medium' => 2,
      'High' => 3,
      _ => 0,
    };

    // Gree Auto mode is fixed at 25 C.
    final temp = modeBits == 0
        ? 25
        : temperature.clamp(16, 30).toInt();

    // Gree Dry mode forces low fan.
    final actualFan = modeBits == 2 ? 1 : fanBits;

    // Native Gree 8-byte state.
    final state = List<int>.filled(8, 0);

    // Byte 0: mode, power, fan, vertical swing auto, sleep.
    state[0] = modeBits |
        (power ? 0x08 : 0) |
        (actualFan << 4) |
        (swing ? 0x40 : 0) |
        (sleep ? 0x80 : 0);

    // Byte 1: temperature offset from 16 C.
    state[1] = temp - 16;

    // Byte 2: timer, turbo, light, model and X-Fan.
    // YAW1F ModelA bit is set when power is ON.
    state[2] = (turbo ? 0x10 : 0) |
        (light ? 0x20 : 0) |
        (power ? 0x40 : 0) |
        (xfan ? 0x80 : 0);

    // Byte 3: Celsius and fixed protocol bits.
    state[3] = 0x50;

    // Byte 4: vertical swing position.
    // 1 = automatic, 0 = last/fixed position.
    state[4] = swing ? 0x01 : 0x00;

    // Byte 5: fixed unknown2 field.
    state[5] = 0x20;

    // Byte 6: reserved.
    state[6] = 0x00;

    // Byte 7: checksum in high nibble.
    state[7] = _checksum(state) << 4;

    final pattern = <int>[
      _headerMark,
      _headerSpace,
    ];

    void addByte(int value) {
      for (var bit = 7; bit >= 0; bit--) {
        pattern
          ..add(_bitMark)
          ..add(
            (value & (1 << bit)) != 0
                ? _oneSpace
                : _zeroSpace,
          );
      }
    }

    // First block: bytes 0-3.
    for (var i = 0; i < 4; i++) {
      addByte(state[i]);
    }

    // Gree inter-block footer: binary 010.
    pattern
      ..add(_bitMark)
      ..add(_zeroSpace)
      ..add(_bitMark)
      ..add(_oneSpace)
      ..add(_bitMark)
      ..add(_zeroSpace)
      ..add(_bitMark)
      ..add(_messageGap);

    // Second block: bytes 4-7.
    for (var i = 4; i < 8; i++) {
      addByte(state[i]);
    }

    // Final footer.
    pattern
      ..add(_bitMark)
      ..add(_messageGap);

    return pattern;
  }

  static int _checksum(List<int> state) {
    var sum = 10;

    // Low nibbles of bytes 0-3.
    for (var i = 0; i < 4; i++) {
      sum += state[i] & 0x0F;
    }

    // High nibbles of bytes 4-6.
    for (var i = 4; i < 7; i++) {
      sum += (state[i] >> 4) & 0x0F;
    }

    return sum & 0x0F;
  }
}
