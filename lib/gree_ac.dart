/// Gree AC infrared encoder.
/// Initial profile: common Gree YAW1F, 38 kHz.
class GreeAcEncoder {
  static const int frequency = 38000;

  static List<int> buildPattern({
    required bool power,
    required int temperature,
    required String mode,
    required String fan,
    required bool swing,
  }) {
    final temp = temperature.clamp(16, 30);

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

    // Gree 8-byte state.
    final state = List<int>.filled(8, 0);

    state[0] = modeBits |
        (power ? 0x08 : 0) |
        (fanBits << 4) |
        (swing ? 0x40 : 0);

    state[1] = (temp - 16) & 0x0F;
    state[2] = 0x20 | (power ? 0x40 : 0);
    state[3] = 0x50;
    state[4] = 0x00;
    state[5] = 0x20;
    state[6] = 0x00;

    // Gree/Kelvinator block checksum.
    var sum = 10;

    for (var i = 0; i < 4; i++) {
      sum += state[i] & 0x0F;
    }

    for (var i = 4; i < 7; i++) {
      sum += (state[i] >> 4) & 0x0F;
    }

    state[7] = (sum & 0x0F) << 4;

    final pattern = <int>[9000, 4500];

    void addByte(int value) {
      for (var bit = 7; bit >= 0; bit--) {
        pattern
          ..add(620)
          ..add(
            (value & (1 << bit)) != 0 ? 1600 : 540,
          );
      }
    }

    // First four bytes.
    for (var i = 0; i < 4; i++) {
      addByte(state[i]);
    }

    // Gree 3-bit footer: 010.
    pattern
      ..add(620)
      ..add(540)
      ..add(620)
      ..add(1600)
      ..add(620)
      ..add(540)
      ..add(620)
      ..add(19980);

    // Remaining four bytes.
    for (var i = 4; i < 8; i++) {
      addByte(state[i]);
    }

    pattern
      ..add(620)
      ..add(19980);

    return pattern;
  }
}
