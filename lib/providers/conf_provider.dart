import 'package:flutter/material.dart';

enum AudioMode { stereo, audio3d }

class ConfiguracaoProvider extends ChangeNotifier {
  AudioMode _audioMode = AudioMode.audio3d; // padrão inicial

  AudioMode get audioMode => _audioMode;

  void setAudioMode(AudioMode mode) {
    _audioMode = mode;
    notifyListeners();
  }
}
