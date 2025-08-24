import 'package:first_project_flutter/providers/conf_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConfiguracaoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Configurações")),
      body: Column(
        children: [
          ListTile(
            title: Text("Áudio Estéreo"),
            leading: Radio<AudioMode>(
              value: AudioMode.stereo,
              groupValue: provider.audioMode,
              onChanged: (value) {
                provider.setAudioMode(value!);
              },
            ),
          ),
          ListTile(
            title: Text("Áudio 3D"),
            leading: Radio<AudioMode>(
              value: AudioMode.audio3d,
              groupValue: provider.audioMode,
              onChanged: (value) {
                provider.setAudioMode(value!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
