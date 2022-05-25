//
//  NKSystemAuth.swift
//  Nokia
//
//  Created by 魔样科技 on 2022/4/14.
//

import Foundation

/// 媒体资料库/Apple Music
import MediaPlayer
import Photos
import UserNotifications
import Contacts
/// Siri权限
import Intents
/// 语音转文字权限
import Speech
/// 日历、提醒事项
import EventKit
/// Face、TouchID
import LocalAuthentication
import HealthKit
import HomeKit
/// 运动与健身权限
import CoreMotion
/// 防止获取无效 计步器
private let cmPedometer = CMPedometer()

typealias AuthClouser = ((Bool)->())

/// 定义私有全局变量,解决在iOS 13 定位权限弹框自动消失的问题
private let locationAuthManager = CLLocationManager()

/**
 权限判断
 escaping 逃逸闭包的生命周期：
 
 1，闭包作为参数传递给函数；
 
 2，退出函数；
 
 3，闭包被调用，闭包生命周期结束
 即逃逸闭包的生命周期长于函数，函数退出的时候，逃逸闭包的引用仍被其他对象持有，不会在函数结束时释放
 经常使用逃逸闭包的2个场景：
 异步调用: 如果需要调度队列中异步调用闭包，比如网络请求成功的回调和失败的回调，这个队列会持有闭包的引用，至于什么时候调用闭包，或闭包什么时候运行结束都是不确定，上边的例子。
 存储: 需要存储闭包作为属性，全局变量或其他类型做稍后使用，例子待补充
 */
public class SystemAuth {
    
    /**
     通讯录权限
     
     - parameters: action 权限结果闭包
     */
    class func authContacts(clouser: @escaping AuthClouser){
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (result, error) in
                if result{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /// 相机权限
    /// - Parameter successCallBack: 权限结果闭包
    class func CameraQX(successCallBack: @escaping ((Bool) -> Void)) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if (authStatus == .authorized) { /****已授权，可以打开相机****/
            successCallBack(true)
        }
        
        else if (authStatus == .denied) {
            
//            let alertV = UIAlertView.init(title: "提示", message: "请去-> [设置 - 隐私 - 相机] 打开访问开关", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "确定")
//            alertV.show()
            weWillDoIfUnAuthorized(permissonName: "相机")
            successCallBack(false)
        }
        
        else if (authStatus == .restricted) {//相机权限受限
            let alertV = UIAlertView.init(title: "提示", message: "相机权限受限", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "确定")
            alertV.show()
            successCallBack(false)
        }
        
        else if (authStatus == .notDetermined) {//首次 使用
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (statusFirst) in
                if statusFirst {
                    //用户首次允许
                    successCallBack(true)
                } else {
                    //用户首次拒接
                    successCallBack(false)
                }
            })
        }
    }
    
    /**
     日历
     
     - parameters: action 权限结果闭包
     */
    class func authEvent(clouser: @escaping AuthClouser){
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .notDetermined:
            EKEventStore().requestAccess(to: .event) { (result, error) in
                if result{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .restricted:
            clouser(false)
        case .denied:
            clouser(false)
        case .authorized:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    /**
     相册权限
     
     - parameters: action 权限结果闭包
     */
    class func authPhotoLib(clouser: @escaping AuthClouser) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    DispatchQueue.main.async {
                        clouser(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        clouser(false)
                    }
                }
            }
        case .denied:
            clouser(false)
        case .restricted:
            clouser(false)
        case .authorized:
            clouser(true)
        case .limited:
            clouser(true)
        @unknown default:
            clouser(false)
        }
    }
    
    
    /// 如果未授权，则弹出以下弹窗
    /// - Parameter permissonName: 权限名称
    class func weWillDoIfUnAuthorized(permissonName: String) {
        let currentVc = NKSimpleAlertController.getCurrentViewController(with: UIApplication.shared.keyWindow?.rootViewController)!
        NKSimpleAlertController.presentAlertVc(confirmBtn: "系统设置", message: String(format: "您未授权%@，该功能无法使用，请点击系统设置或到通用-隐私-%@授权", permissonName,permissonName), title: "提示", cancelBtn: "知道了", handler: { UIAlertAction in
            var url = URL(string: UIApplication.openSettingsURLString)
            if permissonName == "蓝牙" {

            }
            if let url = url,UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:]) { success in
                    }
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }, viewController: currentVc)
    }
    
    /// 蓝牙权限判断
    /// - Parameter clouser:
    class func authBluetoothState(clouser: @escaping AuthClouser) {
        NKBluetoothManager.shared.returnDidBluetoothStateClosure { bluetoothState in
            switch bluetoothState {
            case .poweredOn:
                clouser(true)
            case .poweredOff:
                clouser(false)
            case .unauthorized:
                weWillDoIfUnAuthorized(permissonName: "蓝牙")
                clouser(false)
            case .unsupported:
                clouser(false)
            case .resetting:
                clouser(false)
            case .unknown:
                clouser(false)
            default:
                clouser(false)
            }
        }
    }
    
    /// 数组转json字符串
    /// - Parameter array: 数组
    /// - Returns: JSONString
    class func toJSONStringFromArray(array: [Any]) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return " "
        }
        if let data = try? JSONSerialization.data(withJSONObject: array, options: []), let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue) as String? {
            return JSONString
        }
        return " "
    }
    
    /// json转数组
    /// - Parameter jsonString: json
    /// - Returns: 数组
    class func getArrayFromJSONString(jsonString:String) -> NSArray{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with:  jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
    }
    
    class func returnBase64String(WithImage image: UIImage) -> String {
        let imageData = image.pngData()
        guard let string = imageData?.base64EncodedString() else { return "" }
        return string
    }
    
    /// json转字典
    /// - Parameter jsonString:
    /// - Returns: 
    class func getDictionaryFromJSONString(jsonString: String) -> Dictionary<String, Any>  {
        let jsonData: Data = jsonString.data(using: .utf8)!
        let dic = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dic != nil {
            return dic as! Dictionary
        }
        return dic as! Dictionary<String, Any>
    }
    
    
}



