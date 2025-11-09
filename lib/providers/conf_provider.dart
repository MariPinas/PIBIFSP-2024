import 'package:flutter/material.dart';

enum AudioMode { audio3d, directional }

class ConfiguracaoProvider extends ChangeNotifier {
  AudioMode _audioMode = AudioMode.audio3d;

  AudioMode get audioMode => _audioMode;

  void setAudioMode(AudioMode mode) {
    _audioMode = mode;
    notifyListeners();
  }
}
