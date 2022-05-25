#import "MoyoungBlePlugin.h"
#if __has_include(<moyoung_ble_plugin/moyoung_ble_plugin-Swift.h>)
#import <moyoung_ble_plugin/moyoung_ble_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "moyoung_ble_plugin-Swift.h"
#endif

@implementation MoyoungBlePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftMoyoungBlePlugin registerWithRegistrar:registrar];
    [MYScanPlugin registerWithRegistrar:registrar];
}
@end
