# MoYoung Ble Plugin




Welcome to use this plugin. This is a Flutter plugin for communicating with the watch.


## Platform Support

| Android | iOS |
| :-----: | :-: |
|   ✔️   | ✔️  |


## Usage

To use this plugin, add `moyoung_ble_plugin` as a dependency in your `pubspec.yaml` file.
```
moyoung_ble_plugin: ^x.x.x
```


### Example

```dart
// Import package
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

// Instantiate it
final MoYoungBle _blePlugin = MoYoungBle();

// Access current watch version
FirmwareVersionInfo versionInfo = await _blePlugin.checkFirmwareVersion();
print(versionInfo.version);

// Be informed when the  connection state changes
_blePlugin.connStateEveStm.listen(
(EventConnState event) {
// Do something with new state
}
);
```

## Detailed usage document
[Please click to Wiki](https://pub.dev/documentation/moyoung_ble_plugin/latest/).


##  GNU GENERAL PUBLIC LICENSE License
[Please click to License](https://pub.dev/packages/moyoung_ble_plugin/license).