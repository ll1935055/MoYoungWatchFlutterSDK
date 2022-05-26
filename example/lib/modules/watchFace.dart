import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

class WatchFacePage extends StatefulWidget {
  MoYoungBle blePlugin;

  WatchFacePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<WatchFacePage> createState() {
    return _watchFacePage(blePlugin);
  }
}

class _watchFacePage extends State<WatchFacePage> {
  final MoYoungBle _blePlugin;
  WatchFaceLayoutBean? _crpWatchFaceLayoutInfo = null;
  String _firmwareVersion = "";
  SupportWatchFaceBean? _crpSupportWatchFaceInfo = null;
  List<WatchFaceBean> _watchFacelist = [];

  _watchFacePage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("WatchFacePage"),
            ),
            body: Center(child: ListView(children: [
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(FIRST_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.FIRST_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(SECOND_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.SECOND_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(THIRD_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.THIRD_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(NEW_CUSTOMIZE_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.NEW_CUSTOMIZE_WATCH_FACE)),
              ElevatedButton(
                  child: const Text('queryDisplayWatchFace()'),
                  onPressed: () => _blePlugin.queryDisplayWatchFace),
              ElevatedButton(
                  child: const Text('queryWatchFaceLayout()'),
                  onPressed: () async => _crpWatchFaceLayoutInfo = await _blePlugin.queryWatchFaceLayout),
              ElevatedButton(
                  child: const Text(
                      'sendWatchFaceLayout(CrpWatchFaceLayoutInfo(2)'),
                  onPressed: () => {
                    if(_crpWatchFaceLayoutInfo != null) {
                      _blePlugin.sendWatchFaceLayout(_crpWatchFaceLayoutInfo!)}
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFaceBackground()'),
                  onPressed: () => {
                    if(_crpWatchFaceLayoutInfo != null) {
                      sendWatchFaceBackground()
                    }
                  }),
              ElevatedButton(
                  child: const Text('querySupportWatchFace()'),
                  onPressed: () async => _crpSupportWatchFaceInfo = await _blePlugin.querySupportWatchFace),
              ElevatedButton(
                  child: Text(_firmwareVersion),
                  onPressed: queryFrimwareVersion),
              ElevatedButton(
                  child: const Text('queryWatchFaceStore()'),
                  onPressed: () async => {
                    if(_firmwareVersion != "" && _crpSupportWatchFaceInfo != null) {
                      _watchFacelist = await _blePlugin.queryWatchFaceStore(
                          WatchFaceStoreBean(
                              watchFaceSupportList: _crpSupportWatchFaceInfo!.supportWatchFaceList,
                              firmwareVersion: _firmwareVersion,
                              pageCount: 9,
                              pageIndex: 1)),
                    }}),
              ElevatedButton(
                  child: const Text('queryWatchFaceOfID()'),
                  onPressed: () => {
                    if(_crpSupportWatchFaceInfo != null) {
                      _blePlugin.queryWatchFaceOfID(_crpSupportWatchFaceInfo!.displayWatchFace)
                    }
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFace(_watchFacelist)'),
                  onPressed: () => sendWatchFace(_watchFacelist[0])),
            ])
            )
        )
    );
  }

  sendWatchFaceBackground() async {
    String filePath = "assets/images/text.png";
    ByteData bytes = await rootBundle.load(filePath);
    Uint8List logoUint8List = bytes.buffer.asUint8List();

    WatchFaceBackgroundBean bgBean=WatchFaceBackgroundBean(
      bitmap: logoUint8List,
      thumbBitmap: logoUint8List,
      type:_crpWatchFaceLayoutInfo!.compressionType,
      width: _crpWatchFaceLayoutInfo!.width,
      height: _crpWatchFaceLayoutInfo!.height,
      thumbWidth: _crpWatchFaceLayoutInfo!.thumWidth,
      thumbHeight: _crpWatchFaceLayoutInfo!.thumHeight,
    );
    _blePlugin.sendWatchFaceBackground(bgBean);
  }

  Future<void> queryFrimwareVersion() async {
    String firmwareVersion = await _blePlugin.queryFirmwareVersion;
    if (!mounted) return;
    setState(() {
      _firmwareVersion = firmwareVersion;
    });
  }

  sendWatchFace(WatchFaceBean watchFaceBean) async {
    //Download the file and save
    int index= watchFaceBean.file.lastIndexOf('/');
    String name=watchFaceBean.file.substring(index,watchFaceBean.file.length);
    String pathFile = "";
    await getExternalStorageDirectories().then((value) => value == null
        ? "./"
        : (value.map((e) => pathFile = e.path + name))
        .toString());

    BaseOptions options = BaseOptions(
      baseUrl: watchFaceBean.file,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = Dio(options);
    Response response = await dio.download(watchFaceBean.file, pathFile);

    //call native interface
    CustomizeWatchFaceBean info = CustomizeWatchFaceBean(
        index: watchFaceBean.id, file: pathFile);
    await _blePlugin.sendWatchFace(info,30);
  }
}
