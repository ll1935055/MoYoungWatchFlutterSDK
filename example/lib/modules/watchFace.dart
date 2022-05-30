import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';
import 'package:path_provider/path_provider.dart';

class WatchFacePage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const WatchFacePage({Key? key, required this.blePlugin}) : super(key: key);

  @override
  State<WatchFacePage> createState() {
    return _WatchFacePage(blePlugin);
  }
}

class _WatchFacePage extends State<WatchFacePage> {
  final MoYoungBle _blePlugin;
  WatchFaceLayoutBean? _watchFaceLayoutInfo;
  String _firmwareVersion = "";
  SupportWatchFaceBean? _crpSupportWatchFaceInfo;
  List<WatchFaceBean> _watchFacelist = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  int _progress = -1;
  int _error = -1;

  _WatchFacePage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    var fileTransEveStm = _blePlugin.fileTransEveStm.listen(
          (WatchFaceBgProgressBean event) {
        setState(() {
          logger.d('fileTransEveStm===' + event.toString());
        });
      },
    );
    fileTransEveStm.onError((error) {
      logger.d(error.toString());
    });
    _streamSubscriptions.add(fileTransEveStm);

    _streamSubscriptions.add(
      _blePlugin.wfFileTransEveStm.listen(
            (FileTransBean event) {
          setState(() {
            logger.d('WFFileTransEveStm===' + event.toString());
            _progress = event.progress;
            _error = event.error;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("WatchFace Page"),
            ),
            body: Center(child: ListView(children: [
              Text("progress: $_progress"),
              Text("error: $_error"),

              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(FIRST_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.firstWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(SECOND_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.secondWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(THIRD_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.thirdWatchFace)),
              ElevatedButton(
                  child: const Text('sendDisplayWatchFace(NEW_CUSTOMIZE_WATCH_FACE)'),
                  onPressed: () => _blePlugin
                      .sendDisplayWatchFace(WatchFaceType.newCustomizeWatchFace)),
              ElevatedButton(
                  child: const Text('queryDisplayWatchFace()'),
                  onPressed: () => _blePlugin.queryDisplayWatchFace),
              ElevatedButton(
                  child: const Text('queryWatchFaceLayout()'),
                  onPressed: () async => _watchFaceLayoutInfo = await _blePlugin.queryWatchFaceLayout),
              ElevatedButton(
                  child: const Text(
                      'sendWatchFaceLayout(CrpWatchFaceLayoutInfo(2)'),
                  onPressed: () => {
                    if (_watchFaceLayoutInfo != null) {
                      _blePlugin.sendWatchFaceLayout(_watchFaceLayoutInfo!)}
                  }),
              ElevatedButton(
                  child: const Text('sendWatchFaceBackground()'),
                  onPressed: () => {
                    if (_watchFaceLayoutInfo != null) {
                      sendWatchFaceBackground()
                    }
                  }),
              ElevatedButton(
                  child: const Text('querySupportWatchFace()'),
                  onPressed: () async => _crpSupportWatchFaceInfo = await _blePlugin.querySupportWatchFace),
              ElevatedButton(
                  child: const Text("queryFirmwareVersion()"),
                  onPressed: queryFrimwareVersion),
              ElevatedButton(
                  child: const Text('queryWatchFaceStore()'),
                  onPressed: () async => {
                    if (_firmwareVersion != "" && _crpSupportWatchFaceInfo != null) {
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
                    if (_crpSupportWatchFaceInfo != null) {
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
      type:_watchFaceLayoutInfo!.compressionType,
      width: _watchFaceLayoutInfo!.width,
      height: _watchFaceLayoutInfo!.height,
      thumbWidth: _watchFaceLayoutInfo!.thumWidth,
      thumbHeight: _watchFaceLayoutInfo!.thumHeight,
    );
    _blePlugin.sendWatchFaceBackground(bgBean);
  }

  Future<void> queryFrimwareVersion() async {
    String firmwareVersion = await _blePlugin.queryFirmwareVersion;
    if (!mounted) {
      return;
    }
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
    CustomizeWatchFaceBean info =
        CustomizeWatchFaceBean(index: watchFaceBean.id, file: pathFile);
    await _blePlugin.sendWatchFace(
        SendWatchFaceBean(watchFaceFlutterBean: info, timeout: 30));
  }
}
