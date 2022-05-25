import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

void main() {
  const MethodChannel channel = MethodChannel('moyoung_ble_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('startScan', () async {
    expect(await MoYoungBle().startScan, '42');
  });
}
