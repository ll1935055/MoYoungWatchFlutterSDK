//
//  MYNotification+Extension.swift
//  moyoung_ble_plugin
//
//  Created by 魔样科技 on 2022/5/21.
//

import Foundation

extension NSNotification.Name {
    
    /// 每扫描到一个蓝牙，都通过这个通知，发送给flutter的eventchannel
    ///通知的发送者：NotificationCenter.default.post(name: .kScannedBluetooth, object: nil)
    ///通知的接收者：NotificationCenter.default.addObserver(self, selector: #selector(queryData), name: .kScannedBluetooth, object: nil)
    static let kScannedBluetooth = NSNotification.Name("ScannedBluetooth")
    
    
}
