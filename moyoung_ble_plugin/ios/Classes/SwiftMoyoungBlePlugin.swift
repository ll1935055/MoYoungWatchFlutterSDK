import Flutter
import UIKit

public class SwiftMoyoungBlePlugin: NSObject, FlutterPlugin {
    
    public override init() {
        super.init()
        NKBluetoothManager.shared.setBluetoothConfig()
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "moyoung_ble_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftMoyoungBlePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
     
  }
}
