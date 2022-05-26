import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class MusicPlayerPage extends StatefulWidget {
  MoYoungBle blePlugin;

  MusicPlayerPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<MusicPlayerPage> createState() {
    return _musicPlayerPage(blePlugin);
  }
}

class _musicPlayerPage extends State<MusicPlayerPage> {
  final MoYoungBle _blePlugin;

  _musicPlayerPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("MusicPlayerPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setPlayerState(
                          MusicPlayerStateType.MUSIC_PLAYER_PAUSE),
                  child: const Text("setPlayerState(0)")),
              ElevatedButton(
                  onPressed: () =>
                      _blePlugin.setPlayerState(
                          MusicPlayerStateType.MUSIC_PLAYER_PLAY),
                  child: const Text("setPlayerState(1)")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendSongTitle("111"),
                  child: const Text("sendSongTitle()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendLyrics("lyrics"),
                  child: const Text("sendLyrics()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.closePlayerControl,
                  child: const Text("closePlayerControl()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendCurrentVolume(50),
                  child: const Text("sendCurrentVolume()")),
              ElevatedButton(
                  onPressed: () => _blePlugin.sendMaxVolume(100),
                  child: const Text("sendMaxVolume()")),
            ])
            )
        )
    );
  }
}
