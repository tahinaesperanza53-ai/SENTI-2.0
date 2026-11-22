import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

import 'settings_button.dart';

class SoundManager {
  SoundManager._();
  static final SoundManager instance = SoundManager._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isBgmStarted = false;

  static const String _bgmAssetPath = 'audio/game_theme.mp3';

  late final Uint8List _clickBytes = _buildClickWav();
  late final Uint8List _melodyBytes = _buildMelodyWav();

  Future<void> init() async {
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(0.25);
    await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await _sfxPlayer.setVolume(0.8);

    if (GameSettingsController.instance.soundOn) {
      await startBackgroundMusic();
    }
  }

  Future<void> startBackgroundMusic() async {
    if (!GameSettingsController.instance.soundOn) return;
    try {
      if (!_isBgmStarted) {
        await _bgmPlayer.play(AssetSource(_bgmAssetPath));
        _isBgmStarted = true;
      } else {
        await _bgmPlayer.resume();
      }
    } catch (_) {
      try {
        await _bgmPlayer.play(BytesSource(_melodyBytes, mimeType: 'audio/wav'));
        _isBgmStarted = true;
      } catch (_) {}
    }
  }

  Future<void> pauseBackgroundMusic() async {
    try {
      await _bgmPlayer.pause();
    } catch (_) {}
  }

  Future<void> setSoundEnabled(bool enabled) async {
    GameSettingsController.instance.soundOn = enabled;
    await syncWithSettings();
  }

  Future<void> syncWithSettings() async {
    if (GameSettingsController.instance.soundOn) {
      await startBackgroundMusic();
    } else {
      await pauseBackgroundMusic();
    }
  }

  Future<void> playClick() async {
    if (!GameSettingsController.instance.soundOn) return;
    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.play(BytesSource(_clickBytes, mimeType: 'audio/wav'));
    } catch (_) {}
  }

  Uint8List _buildClickWav() {
    const sampleRate = 22050;
    const durationSec = 0.07;
    final numSamples = (sampleRate * durationSec).round();
    final samples = Int16List(numSamples);

    for (int i = 0; i < numSamples; i++) {
      final progress = i / numSamples;
      final t = i / sampleRate;
      final freq = 950.0 - (550.0 * progress);
      final env = pow(1.0 - progress, 2.0).toDouble();
      final val = sin(2.0 * pi * freq * t) * env * 0.5;
      samples[i] = (val * 32767).round().clamp(-32768, 32767);
    }
    return _wrapPcmInWav(samples, sampleRate);
  }

  Uint8List _buildMelodyWav() {
    const sampleRate = 22050;
    const notes = [
      523.25,
      659.25,
      783.99,
      880.00,
      783.99,
      659.25,
      587.33,
      392.00,
    ];
    final samplesPerNote = (sampleRate * 0.28).round();
    final totalSamples = notes.length * samplesPerNote;
    final samples = Int16List(totalSamples);

    int idx = 0;
    for (final freq in notes) {
      for (int i = 0; i < samplesPerNote; i++) {
        final progress = i / samplesPerNote;
        final t = i / sampleRate;
        final env = pow(sin(pi * progress), 0.7).toDouble();
        final wave =
            0.65 * sin(2.0 * pi * freq * t) + 0.35 * sin(4.0 * pi * freq * t);
        samples[idx++] = (wave * env * 0.25 * 32767).round().clamp(
          -32768,
          32767,
        );
      }
    }
    return _wrapPcmInWav(samples, sampleRate);
  }

  Uint8List _wrapPcmInWav(Int16List samples, int sampleRate) {
    final dataSize = samples.length * 2;
    final buffer = ByteData(44 + dataSize);

    // RIFF header
    buffer.setUint8(0, 0x52); // R
    buffer.setUint8(1, 0x49); // I
    buffer.setUint8(2, 0x46); // F
    buffer.setUint8(3, 0x46); // F
    buffer.setUint32(4, 36 + dataSize, Endian.little);
    buffer.setUint8(8, 0x57); // W
    buffer.setUint8(9, 0x41); // A
    buffer.setUint8(10, 0x56); // V
    buffer.setUint8(11, 0x45); // E

    // fmt chunk
    buffer.setUint8(12, 0x66); // f
    buffer.setUint8(13, 0x6D); // m
    buffer.setUint8(14, 0x74); // t
    buffer.setUint8(15, 0x20); // ' '
    buffer.setUint32(16, 16, Endian.little);
    buffer.setUint16(20, 1, Endian.little); // PCM
    buffer.setUint16(22, 1, Endian.little); // Mono
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little);
    buffer.setUint16(32, 2, Endian.little);
    buffer.setUint16(34, 16, Endian.little);

    // data chunk
    buffer.setUint8(36, 0x64); // d
    buffer.setUint8(37, 0x61); // a
    buffer.setUint8(38, 0x74); // t
    buffer.setUint8(39, 0x61); // a
    buffer.setUint32(40, dataSize, Endian.little);

    for (int i = 0; i < samples.length; i++) {
      buffer.setInt16(44 + i * 2, samples[i], Endian.little);
    }

    return buffer.buffer.asUint8List();
  }
}
