//
//  NKBluetoothManager.swift
//  Nokia
//
//  Created by 魔样科技 on 2022/4/22.
//

import Foundation
import CRPSmartBand
import CoreBluetooth

final class NKBluetoothManager: NSObject {

    static let shared = NKBluetoothManager()

    var myDiscovery:CRPDiscovery!
    var mac = "C9:2C:3D:12:88:86"//D3:C3:1D:46:73:7A
    var deviceState: CRPState = .connecting


    func setBluetoothConfig() {
        CRPSmartBandSDK.sharedInstance.delegate = self
    }

    func startScan(_ duration: TimeInterval = 3, progressHandler: CRPSmartBand.scanProgressHandler?, completionHandler: CRPSmartBand.scanCompletionHandler?) {
        
        SystemAuth.authBluetoothState { result in
            guard result == true else {
                return
            }
            NKSimpleAlertController.presentOnlyOKAlertVC(message: "Is scanning")
            
            CRPSmartBandSDK.sharedInstance.scan(duration) { [self] (newDiscoverys) in
                let p = newDiscoverys[0]
                print("p.ver = \(p.ver)")
                if (mac == "") {
                    if (p.localName?.contains("F605"))! {
                        mac = p.mac!
                        self.myDiscovery = p
                        stopScan()
                        bindDevice()
                    }
                }
                else if ((p.mac?.contains(mac))!) {
                    self.myDiscovery = p
                    stopScan()
                    bindDevice()
                }
            } completionHandler: { (success, error) in
                print("error = \(error)")
                switch error {

                case .none: break
                    //TODO: -
                case .disconnected: break
                    //TODO: -此处为断开连接后，是否进行重连
                case .busy: break
                    //TODO: -此处为设备已经被连接，该进行怎样的逻辑
                case .timeout: break
                    //TODO: -此处为扫描超时咯
                case .interrupted: break
                    //TODO: -此处为扫描被中断
                case .internalError: break
                    //TODO: -此处为SDK内部错误
                case .noCentralManagerSet: break
                    //TODO: -此处为没有蓝牙设备中心
                case .other: break
                    //TODO: -此处为其他错误
                default: break
                    //TODO: -此处为默认
                }
            }
        }
    }

    /// 停止扫描
    func stopScan() {
        CRPSmartBandSDK.sharedInstance.interruptScan()
        NKSimpleAlertController.presentOnlyOKAlertVC(message: "stopScan")
    }

    /// 绑定设备
    private func bindDevice() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [self] in
            if (self.myDiscovery != nil) {
                CRPSmartBandSDK.sharedInstance.connet(self.myDiscovery)
                if self.myDiscoryClosure != nil {
                    self.myDiscoryClosure(self.myDiscovery)
                }
                NKSimpleAlertController.presentOnlyOKAlertVC(message: "connected")
            }
            else {
                NKSimpleAlertController.presentOnlyOKAlertVC(message: "Can not find:\(mac)")
            }
        }
    }
    
    /// 解除手环绑定
    public func remove(closure: @escaping ((CRPSmartBand.CRPState, CRPSmartBand.CRPError) -> Void)) {
        CRPSmartBandSDK.sharedInstance.remove { state, error in
            closure(state, error)
        }
    }
    
    /// 断开连接
    public func dicConnect() {
        CRPSmartBandSDK.sharedInstance.disConnet()
    }
    
    /// 重新连接
    public func reConnect() {
        CRPSmartBandSDK.sharedInstance.reConnet()
    }
    
    //MARK: - 回调的闭包 -

    /// 当前的⼿环的连接状态
    var didStateClosure:(((CRPState)) -> Void)!

    /// 当前蓝⽛状态
    var didBluetoothStateClosure:((_ state: CRPBluetoothState) -> Void)!

    /// 实时的运动计步数据
    var receiveStepsClosure:((_ model: StepModel) -> Void)!

    /// ⼼率测量结果(单次测量⼼率)
    var receiveHeartRateClosure:((_ heartRate: Int) -> Void)!

    /// 实时⼼率数据(⼀般只⽤于显示不⽤于存储，部分⼿环⽀持返回实时RRI数据)
    var receiveRealTimeHeartRateClosure:((_ heartRate: Int, _ rri: Int) -> Void)!

    /// 上次动态⼼率测量结果
    var receiveHeartRateAllClosure:((_ model: HeartModel) -> Void)!

    /// ⾎压测量结果
    var receiveBloodPressureClosure:((_ heartRate: Int, _ sbp: Int, _ dbp: Int) -> Void)!

    /// ⾎氧测量结果
    var receiveSpO2Closure:((_ o2: Int) -> Void)!
    var receiveUpgradeClosure:((_ state: CRPUpgradeState, _ progress: Int) -> Void)!

    /// 升级表盘文件/图片时的回调
    var receiveUpgradeScreenClosure:((_ state: CRPUpgradeState, _ progress: Int) -> Void)!

    /// 拍照请求
    var receiveTakePhotoClosure:(() -> Void)!

    /// 天⽓获取请求
    var receiveWeatherClosure:(() -> Void)!

    /// 查找⼿机请求
    var receiveFindPhoneClosure:((_ state: Int) -> Void)!

    ///  实时的体温数值
    var receiveRealTimeTemperatureClosure:((_ temp: Double) -> Void)!

    /// 体温测量状态
    var receiveTemperatureClosure:((_ state: Int) -> Void)!

    /// ⼀键呼叫请求
    var receiveCallingClosure:(() -> Void)!

    /// HRV实时数据
    var receviceHRVRealTimeClosure:((_ model: CRPHRVDataModel) -> Void)!

    /// 当前来电号码
    var receivePhoneNumberClosure:((_ number: String) -> Void)!

    /// 吃药提醒数据
    var receiveMedicineInfoClosure:((_ max: Int,_ model: CRPMedicineReminderModel?) -> Void)!

    /// 运动模式状态
    var receiveSportListClosure:((_ list: [CRPSmartBand.CRPSportRecord]) -> Void)!
    
    /// 运动模式状态
    var receiveSportStateClosure:((_ state: SportType) -> Void)!




    var receiveECGDateClosure:((_ state: ecgState, _ data: [UInt32], _ completeTime: Int) -> Void)!
    var myDiscoryClosure:((_ discovery: CRPDiscovery) -> Void)!
    var receiveSportsClosure:((_ sports: [SportModel]) -> Void)!


    //MARK: - 将蓝牙的回调封装为闭包传出去 -

    /// 返回当前的⼿环的连接状态
    /// - Parameter closure: CRPState
    func returnDidStateClosure(closure : @escaping ((CRPState) -> Void)) {
        self.didStateClosure = closure
    }

    /// 返回当前蓝⽛状态
    /// - Parameter closure: CRPBluetoothState
    func returnDidBluetoothStateClosure(closure : @escaping ((CRPBluetoothState) -> Void)) {
        self.didBluetoothStateClosure = closure
    }

    /// 接收实时的运动计步数据
    /// - Parameter closure: StepModel
    func returnReceiveStepsClosure(closure : @escaping ((StepModel) -> Void)) {
        self.receiveStepsClosure = closure
    }

    /// 接收⼼率测量结果(单次测量⼼率)
    /// - Parameter closure: Int
    func returnReceiveHeartRateClosure(closure : @escaping ((Int) -> Void)) {
        self.receiveHeartRateClosure = closure
    }

    /// 接收实时⼼率数据(⼀般只⽤于显示不⽤于存储，部分⼿环⽀持返回实时RRI数据)
    /// - Parameter closure: HeartModel
    func returnReceiveRealTimeHeartRateClosure(closure : @escaping ((Int, Int) -> Void)) {
        self.receiveRealTimeHeartRateClosure = closure
    }


    /// 查询上次动态⼼率测量结果
    /// - Parameter closure: HeartModel
    func returnReceiveHeartRateAllClosure(closure : @escaping ((HeartModel) -> Void)) {
        self.receiveHeartRateAllClosure = closure
    }

    /// 接收⾎压测量结果
    /// - Parameter closure: (Int, Int, Int)
    func returnReceiveBloodPressureClosure(closure : @escaping ((Int, Int, Int) -> Void)) {
        self.receiveBloodPressureClosure = closure
    }

    /// 接收⾎氧测量结果
    /// - Parameter closure: Int
    func returnReceiveSpO2Closure(closure : @escaping ((Int) -> Void)) {
        self.receiveSpO2Closure = closure
    }

    ///
    /// - Parameter closure: CRPUpgradeState
    func returnReceiveUpgradeClosure(closure : @escaping ((CRPUpgradeState, Int) -> Void)) {
        self.receiveUpgradeClosure = closure
    }

    /// 升级表盘文件/图片时的回调
    /// - closure:
    ///   - state: 状态
    ///   - progress: 进度
    /// 升级表盘文件/图片时的回调
    /// - Parameter closure: (CRPUpgradeState, Int)
    func returnreceiveUpgradeScreenClosure(closure : @escaping ((CRPUpgradeState, Int) -> Void)) {
        self.receiveUpgradeScreenClosure = closure
    }


    /// 收到拍照请求
    /// - Parameter closure:
    func returnReceiveTakePhotoClosure(closure : @escaping (() -> Void)) {
        self.receiveTakePhotoClosure = closure
    }

    /// 收到天⽓获取请求
    /// - Parameter closure:
    func returnReceiveWeatherClosure(closure : @escaping (() -> Void)) {
        self.receiveWeatherClosure = closure
    }


    /// 收到查找⼿机请求
    /// - Parameter closure: state
    func returnReceiveFindPhoneClosure(closure : @escaping ((_ state: Int) -> Void)) {
        self.receiveFindPhoneClosure = closure
    }

    /// 收到实时的体温数值
    /// - Parameter closure: ⼿环收到实时体温数值后，保留最后⼀次收到的值，当收到测量结束状态时，最后的值就是测量结果
    func returnReceiveRealTimeTemperatureClosure(closure : @escaping ((_ temp: Double) -> Void)) {
        self.receiveRealTimeTemperatureClosure = closure
    }

    /// 收到体温测量状态
    /// - Parameter closure: ⽤于判断单次体温测量的状态 收到state为1时为正在测量，收到state为0时为测量结束
    func returnReceiveTemperatureClosure(closure : @escaping ((_ state: Int) -> Void)) {
        self.receiveTemperatureClosure = closure
    }

    /// 收到⼀键呼叫请求
    /// - Parameter closure:
    func returnReceiveCallingClosure(closure : @escaping (() -> Void)) {
        self.receiveCallingClosure = closure
    }

    /// 收到HRV实时数据
    /// - Parameter closure: CRPHRVDataModel
    func returnReceviceHRVRealTimeClosure(closure : @escaping ((_ model: CRPHRVDataModel) -> Void)) {
        self.receviceHRVRealTimeClosure = closure
    }

    /// 收到当前来电号码
    /// - Parameter closure: String
    func returnReceivePhoneNumberClosure(closure : @escaping ((_ number: String) -> Void)){
        self.receivePhoneNumberClosure = closure
    }

    /// 收到吃药提醒数据
    /// - Parameter closure: _ max: Int,_ model: CRPMedicineReminderModel
    func returnReceiveMedicineInfoClosure(closure : @escaping ((_ max: Int,_ model: CRPMedicineReminderModel?) -> Void)) {
        self.receiveMedicineInfoClosure = closure
    }

    /// 收到运动list
    /// - Parameter state: SportType
    func returnReceiveSportListClosure(closure : @escaping ((_ list: [CRPSmartBand.CRPSportRecord]) -> Void)) {
        self.receiveSportListClosure = closure
    }
    
    /// 收到运动模式状态
    /// - Parameter state: SportType
    func returnReceiveSportStateClosure(closure : @escaping ((_ state: SportType) -> Void)) {
        self.receiveSportStateClosure = closure
    }

    func returnReceiveECGDateClosure(closure : @escaping ((ecgState, [UInt32], Int) -> Void)) {
        self.receiveECGDateClosure = closure
    }


    /// 将扫描到的匹配的设备信息存起来
    /// - Parameter closure: 设备信息
    func returnMyDiscoryClosure(closure : @escaping ((CRPDiscovery) -> Void)) {
        self.myDiscoryClosure = closure
    }

    //MARK: - 手环交互 -

    //MARK: - 同步时间
    /// 同步时间
    func setTime() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setTime()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setTime()
        }
    }

    //MARK: - 固件升级
    /// 查询⼿环当前固件版本
    /// - Parameter closure: String 当前固件版本
    func getSoftver(_ closure: @escaping ((_ softver: String) ->Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSoftver {(softver, error) in
                        closure(softver)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSoftver {(softver, error) in
                closure(softver)
            }
        }

    }

    /// 查询新固件(通过传⼊当前版本的和mac地址获取是否有新版本固件可升级)
    /// - Parameters:
    ///   - version: 当前版本
    ///   - mac: mac地址
    ///   - closure: 是否有新版本固件可升级)
    func checkLatest(_ version: String, _ mac: String, _ closure:
                     @escaping ((newVersionInfo?, newVersionTpInfo?) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.checkLatest(version, mac) { newVerInfo, newVerTpInfo, error in
                        closure(newVerInfo, newVerTpInfo)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.checkLatest(version, mac) { newVerInfo, newVerTpInfo, error in
                closure(newVerInfo, newVerTpInfo)
            }
        }

    }

    //MARK: - 查询设备电量
    /// 查询⼿环当前电量
    /// - Parameter closure: String ⼿环当前电量
    func getBattery(_ closure: @escaping ((_ battery: Int) ->Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getBattery { battery, error in
                        closure(battery)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getBattery { battery, error in
                closure(battery)
            }
        }

    }

    //MARK: - 用户信息

    /// 设置用户信息
    /// - Parameter profile: CRPSmartBand.ProfileModel
    func setProfile(_ profile: CRPSmartBand.ProfileModel) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setProfile(profile)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setProfile(profile)
        }
    }
    
    /// 获取用户信息
    /// - Parameter closure:
    func getProfile(_ closure: @escaping ((CRPSmartBand.ProfileModel, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getProfile { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getProfile { data, error in
                closure(data, error)
            }
        }
    }

    /// 设置步长
    /// - Parameter length: 步长
    func setStepLength(length: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStepLength(length: length)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStepLength(length: length)
        }
    }

    //MARK: - 天气

    /// 设置今日天气
    /// - Parameter weather: CRPSmartBand.weather
    func setWeather(_ weather: CRPSmartBand.weather) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setWeather(weather)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setWeather(weather)
        }
    }

    /// 设置未来7日天气
    /// - Parameter weathers: 未来七日的天气数组:[CRPSmartBand.forecastWeather]
    func setForecastWeather(_ weathers: [CRPSmartBand.forecastWeather]) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setForecastWeather(weathers)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setForecastWeather(weathers)
        }
    }

    /// 设置当前城市名
    /// - Parameter cityName: 城市名:String
    func sendCityName(_ cityName: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendCityName(cityName)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendCityName(cityName)
        }
    }

    //MARK: - 翻腕亮屏

    /// 设置翻腕亮屏状态
    /// - Parameter isOn: 开启或者关闭
    func setQuickView(_ isOn: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setQuickView(isOn)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setQuickView(isOn)
        }
    }

    /// 查询⼿环翻腕亮屏开启状态.
    /// - Parameter closure: int（0：关闭 1：开启）, error
    func getQuickView(_ closure: @escaping (Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getQuickView { type, error in
                        closure(type,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getQuickView { type, error in
                closure(type,error)
            }
        }
    }

    /// 设置翻腕亮屏时间
    /// - Parameter periodTime: 翻腕亮屏时间模型：periodTimeModel
    func setQuickViewTime(_ periodTime: CRPSmartBand.periodTimeModel) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setQuickViewTime(periodTime)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setQuickViewTime(periodTime)
        }
    }

    /// 获取翻腕亮屏时间
    /// - Parameter closure: 翻腕亮屏时间模型：periodTimeModel
    func getQuickViewTime(_ closure: @escaping (CRPSmartBand.periodTimeModel, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getQuickViewTime { model, error in
                        closure(model,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getQuickViewTime { model, error in
                closure(model,error)
            }
        }
    }

    //MARK: - 表盘

    /// 切换手环表盘
    /// - Parameter type: 第（0  1  2）+1 个表盘
    func setDial(_ type:Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setDial(type)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setDial(type)
        }
    }

    /// 查询手环正在使用的表盘序号
    /// - Parameter closure: 表盘序号
    func getDial(_ closure: @escaping (Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getDial { type, error in
                        closure(type,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getDial { type, error in
                closure(type,error)
            }
        }
    }

    /// 更换自定义表盘背景图片
    /// - Parameters:
    ///   - image: 图片
    ///   - imageSize: 图片宽高,需要通过getScreenContent获取
    ///   - isCricle: 是否圆型
    ///   - compressionType: 压缩类型,需要通过getScreenContent获取
    func startChangeScreen(_ image: UIImage, _ imageSize :ScreenImageSize, _ isCricle: Bool = false, _ compressionType: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startChangeScreen(image, imageSize, isCricle, compressionType)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startChangeScreen(image, imageSize, isCricle, compressionType)
        }
    }

    /// 修改自定义表盘布局
    /// - Parameter content: 表盘布局：CRPSmartBand.ScreenContent
    func setupScreenContent(content: CRPSmartBand.ScreenContent) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setupScreenContent(content: content)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setupScreenContent(content: content)
        }
    }

    /// 获取指定表盘布局
    /// - Parameter closure: 表盘布局
    func getScreenContent(_ closure: @escaping (CRPSmartBand.ScreenContent, CRPSmartBand.ScreenImageSize, Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getScreenContent { screenContent, imageSize, compressionType, error in
                        closure(screenContent,imageSize,compressionType,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getScreenContent { screenContent, imageSize, compressionType, error in
                closure(screenContent,imageSize,compressionType,error)
            }
        }
    }

    /// 获取⽀持摆盘类型
    /// - Parameter closure: ⽀持的表盘类型以及当前的表盘在表盘市场的ID
    func getWatchFaceSupportModel(_ closure: @escaping
                                  (CRPSmartBand.watchFaceSupportModel, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getWatchFaceSupportModel { model, error in
                        closure(model,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getWatchFaceSupportModel { model, error in
                closure(model,error)
            }
        }
    }

    /// 获取表盘市场
    /// 根据表盘的⽀持类型获取可以更换的表盘列表(分⻚获取)
    /// - Parameters:
    ///   - supportModel: 表盘的支持类型
    ///   - currentPage: 当前第几页（从1开始）
    ///   - perPage: 每页多少个表盘（建议设置为18）
    ///   - closure: 表盘列表
    func getWatchFaceInfo(_ supportModel: [Int], currentPage: Int,
                          perPage: Int ,_ closure: @escaping ([CRPSmartBand.watchFaceInfo], Int, Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getWatchFaceInfo(supportModel, currentPage: currentPage, perPage: perPage) { watchFaceInfos, currentPage, perPage, error in
                        closure(watchFaceInfos,currentPage,perPage,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfo(supportModel, currentPage: currentPage, perPage: perPage) { watchFaceInfos, currentPage, perPage, error in
                closure(watchFaceInfos,currentPage,perPage,error)
            }
        }
    }
    
    /// 获取表盘ID的表盘信息
    /// - Parameters:
    ///   - id: 表盘id
    ///   - closure: 表盘信息
    func getWatchFaceInfoByID(_ id: Int, _ closure: @escaping (([CRPSmartBand.watchFaceInfo], Int, Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getWatchFaceInfoByID(id) { watchFaceInfos, currentPage, perPage, error in
                        closure(watchFaceInfos, currentPage, perPage, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfoByID(id) { watchFaceInfos, currentPage, perPage, error in
                closure(watchFaceInfos, currentPage, perPage, error)
            }
        }
    }

    func startChangeWatchFace(_ Info: CRPSmartBand.watchFaceInfo) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startChangeWatchFace(Info)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startChangeWatchFace(Info)
        }
    }
    
    func startChangeWathcFaceFromFile(path: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startChangeWathcFaceFromFile(path: path)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startChangeWathcFaceFromFile(path: path)
        }
    }

    //MARK: - 语言

    /// 设置手环语言
    /// - Parameter lang: 数组下标["英语","简体中文","日语","韩语","德语","法语","西班牙语","阿拉伯语","俄语","繁体中文","乌克兰语","意大利语","葡萄牙语","荷兰语","波兰语","瑞典语","芬兰语","丹麦语","挪威语","匈牙利语","捷克语","保加利亚语","罗马尼亚语","斯洛伐克语","拉脱维亚语","印度尼西亚语","泰语","土耳其语","越南语","印地语"]
    func setLanguage(_ lang: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setLanguage(lang)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setLanguage(lang)
        }
    }

    /// 获取当前手环语言
    /// - Parameters:
    ///   - closure:int 当前手环的语言 ，去上面的数组取
    ///   - supportClosure:下标数组 当前手环支持的语言们，去上面的数组取
    func getLanguage(_ closure: @escaping (Int, CRPSmartBand.CRPError) -> Void, _ supportClosure: @escaping ([Int], CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getLanguage { idx, error in
                        closure(idx,error)
                    } _: { supportIdxs, error in
                        supportClosure(supportIdxs,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getLanguage { idx, error in
                closure(idx,error)
            } _: { supportIdxs, error in
                supportClosure(supportIdxs,error)
            }
        }
    }

    /// 设置手环当前语言版本
    /// ⼿环语⾔版本分中⽂版和国际版，中⽂版只显示中⽂，国际版才能切换外语
    /// - Parameter isChinese: bool, 是否为中文版本
    func setLanguageVersion( isChinese: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setLanguageVersion(isChinese)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setLanguageVersion(isChinese)
        }
    }

    //MARK: - 久坐提醒

    /// 设置久坐提醒状态
    /// - Parameter isOn: 开启或者关闭
    func setRemindersToMove(_ isOn: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setRemindersToMove(isOn)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setRemindersToMove(isOn)
        }
    }

    /// 查询久坐提醒状态
    /// - Parameter closure: 是否开启  0 - false 1 true
    func getRemindersToMove(_ closure: @escaping (Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getRemindersToMove { type, error in
                        closure(type,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getRemindersToMove { type, error in
                closure(type,error)
            }
        }
    }

    /// 设置久坐提醒有效时间段
    /// - Parameter sitRemind:CRPSmartBand.SitRemindModel 久坐提醒model
    func setSitRemind(_ sitRemind: CRPSmartBand.SitRemindModel) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setSitRemind(sitRemind)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setSitRemind(sitRemind)
        }
    }

    /// 获取久坐提醒时间段
    /// - Parameter closure: CRPSmartBand.SitRemindModel,久坐提醒model
    func getSitRemindInfo(_ closure: @escaping (CRPSmartBand.SitRemindModel, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSitRemindInfo { model, error in
                        closure(model,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSitRemindInfo { model, error in
                closure(model,error)
            }
        }
    }

    //MARK: - 查找手环

    /// 查找手环，手环收到此指令以后会震动几秒
    func setFindDevice() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setFindDevice()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFindDevice()
        }
    }
    
    //MARK: - 找寻手机
    
    /// 开始找寻手机
    func sendFindingPhone() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendFindingPhone()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFindDevice()
        }
    }
    
    /// 停止找寻手机
    func stopFindPhone() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.stopFindPhone()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFindDevice()
        }
    }
    
    

    //MARK: - 校准GSensor

    /// 校准GSensor
    /// ⼿环出现翻腕亮屏不灵敏或者计步不准，可校准GSensor以修复，校准过程中，⼿环⽔平置于桌⾯
    func sendCalibration() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendCalibration()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendCalibration()
        }
    }

    //MARK: - 拍照

    /// 切换手环至拍照界面
    func switchCameraView() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.switchCameraView()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.switchCameraView()
        }
    }
    
    func exitCameraView() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.exitCameraView()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.exitCameraView()
        }
    }
    

    //MARK: - 关机

    /// 手环关机
    func shutDown() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.shutDown()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.shutDown()
        }
    }

    //MARK: - 勿扰时段

    /// 设置勿扰时段,勿扰时段内不显示消息推送
    /// - Parameter periodTime: periodTimeMode - l勿扰时段model
    func setDisturbTime(_ periodTime: CRPSmartBand.periodTimeModel) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setDisturbTime(periodTime)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setDisturbTime(periodTime)
        }
    }

    /// 查询⼿环设置的勿扰时段
    /// - Parameter closure: periodTimeModel - 勿扰时段model
    func getDisturbTime(_ closure: @escaping (CRPSmartBand.periodTimeModel, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getDisturbTime { model, error in
                        closure(model, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getDisturbTime { model, error in
                closure(model, error)
            }
        }
    }

    //MARK: - 历史步数和睡眠数据

    /// 获取历史数据
    /// ⼿环可保存前两天的计步数据和睡眠数据
    /// - Parameter closure: 包含stepModels和sleepModels,数组的第⼀个为昨天数据，第⼆个为前天数据
    func getAllData(_ closure: @escaping ([CRPSmartBand.StepModel], [CRPSmartBand.SleepModel], CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAllData { stepModels, sleepModels, error in
                        closure(stepModels, sleepModels, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAllData { stepModels, sleepModels, error in
                closure(stepModels, sleepModels, error)
            }
        }
    }
    
    func getAllDataWithREM(_ closure: @escaping ([CRPSmartBand.StepModel], [CRPSmartBand.SleepModel], CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAllDataWithREM { stepDatas, sleepDatas, error in
                        closure(stepDatas, sleepDatas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAllDataWithREM { stepDatas, sleepDatas, error in
                closure(stepDatas, sleepDatas, error)
            }
        }
    }

    //MARK: - 生理周期

    /// 设置⽣理周期提醒
    /// - Parameter physiological: Physiological
    func setPhysiological(_ physiological: CRPSmartBand.Physiological) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setPhysiological(physiological)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setPhysiological(physiological)
        }
    }

    /// 查询生理周期提醒
    /// - Parameter closure: Physiological
    func getPhysiological(_ closure: @escaping (CRPSmartBand.Physiological, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getPhysiological { physiological, error in
                        closure(physiological, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getPhysiological { physiological, error in
                closure(physiological, error)
            }
        }
    }

    //MARK: - 心电测量

    /// 开始心电测量
    func startECGMeasure() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startECGMeasure()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startECGMeasure()
        }
    }

    /// 停止心电测量
    func stopECGMeasure() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.stopECGMeasure()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.stopECGMeasure()
        }
    }


    /// 检测是否是新的⼼电测量⽅式
    /// 新的测量⽅式，⼿环可以保存最后⼀次未发送的测量量结果
    /// - Returns: bool
    func isNewECGMeasurementVersion(_ closure: @escaping (Bool) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    closure(CRPSmartBandSDK.sharedInstance.isNewECGMeasurementVersion())
                }
            }
        }
        else {
            closure(CRPSmartBandSDK.sharedInstance.isNewECGMeasurementVersion())
        }

    }

    /// 查询上次⼼电数据
    /// 查询⼿环保存的⼼电数据
    func getLastMeasureECGData() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getLastMeasureECGData()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getLastMeasureECGData()
        }
    }

    /// 设置⼼⼼电测量量期间⼼率
    /// ⽤测量所得到的数据，通过⼼电算法库计算出瞬时⼼率，发送⾄⼿⼿环
    /// - Parameter heartRate: int - 心率
    func sendECGHeartRate(heartRate: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendECGHeartRate(heartRate: heartRate)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendECGHeartRate(heartRate: heartRate)
        }
    }

    //MARK: - 体温

    /// 开始单次体温测量
    /// receiveRealTimeTemperature回调⽅法返回测量值，receiveTemperature回调⽅法返回测量状态
    func sendSingleTemperatureStart() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendSingleTemperatureStart()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendSingleTemperatureStart()
        }
    }

    /// 结束单词体温测量
    func sendSingleTemperatureEnd() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendSingleTemperatureEnd()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendSingleTemperatureEnd()
        }
    }

    /// 获取⾃动体温测量开关
    /// - Parameter closure: 1：开启；0：关闭
    func getAutoTemperatureState(_ closure: @escaping (Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAutoTemperatureState { state, error in
                        closure(state, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAutoTemperatureState { state, error in
                closure(state, error)
            }
        }
    }

    /// 设置⾃动体温测量开关
    /// - Parameter isOpen: 开关
    func sendAutoTemperature(_ isOpen: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendAutoTemperature(isOpen)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendAutoTemperature(isOpen)
        }
    }

    /// 获取⾃动体温测量数据，每半⼩时⼀个数据
    /// - Parameters:
    ///   - todayClosure: [Double]数组
    ///   - yesterdayClosure: [Double]数组
    func getAutoTemperatureData(_ todayClosure: @escaping ([Double], CRPSmartBand.CRPError) -> Void, _ yesterdayClosure: @escaping (([Double], CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAutoTemperatureData { todayDatas, error in
                        todayClosure(todayDatas, error)
                    } _: { yesterdayDatas, error in
                        yesterdayClosure(yesterdayDatas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAutoTemperatureData { todayDatas, error in
                todayClosure(todayDatas, error)
            } _: { yesterdayDatas, error in
                yesterdayClosure(yesterdayDatas, error)
            }
        }
    }

    /// 获取体温单位 1:华⽒度；0:摄⽒度
    /// - Parameter closure: 1:华⽒度；0:摄⽒度
    func getTemperatureUnit(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getTemperatureUnit { unit, error in
                        closure(unit, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getTemperatureUnit { unit, error in
                closure(unit, error)
            }
        }
    }

    /// 设置体温单位 1:华⽒度；0:摄⽒度
    /// - Parameter unit: 1:华⽒度；0:摄⽒度
    func setTemperatureUnit(_ unit:Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setTemperatureUnit(unit)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setTemperatureUnit(unit)
        }
    }

    /// 设置全天体温(⼀分钟测⼀次)
    /// - Parameter open: 开关
    func setFullDayTemperatureStatus(open: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setFullDayTemperatureStatus(open: open)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFullDayTemperatureStatus(open: open)
        }
    }

    /// 获取全天体温状态
    /// - Parameter closure: int
    func getFullDayTemperatureStatus(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayTemperatureStatus { status, error in
                        closure(status, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayTemperatureStatus { status, error in
                closure(status, error)
            }
        }
    }

    /// 获取全天体温数据
    /// - Parameter closure: [Double]
    func getFullDayTemperatureData(_ closure: @escaping (([Double], CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayTemperatureData { datas, error in
                        closure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayTemperatureData { datas, error in
                closure(datas, error)
            }
        }
    }

    //MARK: - 亮屏时间

    /// 设置亮屏时间
    /// - Parameter time: int
    func sendAutoLockTime(_ time: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendAutoLockTime(time)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendAutoLockTime(time)
        }
    }

    /// 获取亮屏时间
    /// - Parameter closure: int`
    func getAutoLockTime(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAutoLockTime { time, error in
                        closure(time, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAutoLockTime { time, error in
                closure(time, error)
            }
        }
    }

    //MARK: - 心率预警

    /// 设置⼼率预警值
    /// - Parameter remind: ⼼率预警值
    func sendHeartRateRemind(_ remind: CRPSmartBand.hrRemind) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendHeartRateRemind(remind)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendHeartRateRemind(remind)
        }
    }

    /// 获取⼼率预警值
    /// - Parameter closure: ⼼率预警值
    func getHeartRateRemind(_ closure: @escaping ((CRPSmartBand.hrRemind, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHeartRateRemind { hrRemind, error in
                        closure(hrRemind, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHeartRateRemind { hrRemind, error in
                closure(hrRemind, error)
            }
        }
    }



    //MARK: - 喝水提醒

    /// 设置喝⽔提醒数据
    /// - Parameter remind: drinkWaterRemind
    func sendDrinkWaterRemind(_ remind: CRPSmartBand.drinkWaterRemind) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(remind)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(remind)
        }
    }

    /// 获取喝水提醒数据
    /// - Parameter closure:drinkWaterRemind
    func getDrinkWaterRemind(_ closure: @escaping ((CRPSmartBand.drinkWaterRemind, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getDrinkWaterRemind { drinkWaterRemind, error in
                        closure(drinkWaterRemind, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getDrinkWaterRemind { drinkWaterRemind, error in
                closure(drinkWaterRemind, error)
            }
        }
    }

    //MARK: - 洗手提醒

    /// 设置洗手提醒数据
    /// - Parameter remind: 洗手提醒数据
    func sendHandWashRemind(_ remind: eventRemind) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendHandWashRemind(remind)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendHandWashRemind(remind)
        }
    }

    /// 获取洗⼿提醒数据
    /// - Parameter handler: 洗手提醒数据
    func getHandWashRemind(_ closure: @escaping ((CRPSmartBand.eventRemind, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHandWashRemind { eventRemind, error in
                        closure(eventRemind, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHandWashRemind { eventRemind, error in
                closure(eventRemind, error)
            }
        }
    }

    //MARK: - 恢复出厂设置

    /// 恢复出厂设置
    func reset() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.reset()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.reset()
        }
    }

    //MARK: - HRV疲劳度

    /// 设置测量间隔
    /// - Parameter interval: int - 测量间隔
    func setHRV(_ interval:Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setHRV(interval)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setHRV(interval)
        }
    }

    /// 获取测量间隔
    /// - Parameter closure: int 测量间隔
    func getHRVInterval(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHRVInterval { interval, error in
                        closure(interval, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHRVInterval { interval, error in
                closure(interval, error)
            }
        }
    }

    /// 获取历史数据中某天的疲劳度数据量(dayIndex: 0~6,可获取7天的数据，0:今天 ，1:昨天，以此类推)
    /// - Parameters:
    ///   - dayIndex: dayIndex: 0~6,可获取7天的数据，0:今天 ，1:昨天，以此类推
    ///   - closure: int 疲劳度数据量
    func getHRVCount(_ dayIndex: Int, _ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHRVCount(dayIndex) { count, error in
                        closure(count, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHRVCount(dayIndex) { count, error in
                closure(count, error)
            }
        }
    }

    /// 获取历史数据中某天指定条的的疲劳度数据
    /// - Parameters:
    ///   - dayIndex: dayIndex: 0~6,可获取7天的数据，0:今天 ，1:昨天，以此类推
    ///   - index: 第几条
    ///   - closure: CRPHRVDataModel - 疲劳度数据
    func getHRVData(_ dayIndex: Int, _ index: Int, _ closure: @escaping ((CRPSmartBand.CRPHRVDataModel, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHRVData(dayIndex, index) { model, error in
                        closure(model, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHRVData(dayIndex, index) { model, error in
                closure(model, error)
            }
        }
    }

    /// 主动测量获取RRI数据
    func startHRVMeasure() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    return CRPSmartBandSDK.sharedInstance.startHRVMeasure()
                }
            }
        }
        else {
            return CRPSmartBandSDK.sharedInstance.startHRVMeasure()
        }
    }

    /// 停⽌测量RRI数据
    func stopHRVMeasure() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.stopHRVMeasure()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.stopHRVMeasure()
        }
    }

    //MARK: - 省电模式

    /// 设置省电模式
    /// - Parameter open: bool
    func setPowerSaveState(open: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setPowerSaveState(open: open)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setPowerSaveState(open: open)
        }
    }

    /// 获取省电模式状态
    /// - Parameter closure: int 状态
    func getPowerSaveState(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getPowerSaveState { state, error in
                        closure(state, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getPowerSaveState { state, error in
                closure(state, error)
            }
        }
    }

    //MARK: - 吃药提醒

    /// 获取当前吃药提醒信息,通过receiveMedicineInfo⽅法返回数据
    func getMedicineInfo() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getMedicineInfo()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getMedicineInfo()
        }
    }

    /// 设置吃药提醒
    /// - Parameter medicine: CRPMedicineReminderModel 吃药提醒model
    func setMedicine(medicine: CRPMedicineReminderModel) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setMedicine(medicine: medicine)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setMedicine(medicine: medicine)
        }
    }

    /// 删除指定id的吃药提醒
    /// - Parameter id: int - 吃药提醒的id
    func deleteMedicine(id: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.deleteMedicine(id: id)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.deleteMedicine(id: id)
        }
    }

    /// 删除所有吃药提醒设置
    func deleteAllMedicine() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.deleteAllMedicine()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.deleteAllMedicine()
        }
    }

    //MARK: - 屏幕轻触唤醒

    /// 设置屏幕轻触唤醒
    /// - Parameter open: bool
    func setTapToWake(open: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setTapToWake(open: open)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setTapToWake(open: open)
        }
    }

    /// 获取屏幕轻触唤醒设置(0: 关闭，1: 开启)
    /// - Parameter closure: (0: 关闭，1: 开启)
    func readTapToWake(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.readTapToWake { type, error in
                        closure(type, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.readTapToWake { type, error in
                closure(type, error)
            }
        }
    }

    //MARK: - 开启运动模式

    /// 设置运动模式
    /// - Parameter state: SportType 运动模式
    func setSportState(state: SportType) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setSportState(state: state)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setSportState(state: state)
        }
    }
    
    /// 获取运动数据
    /// - Parameter closure: 运动信息

    func getSportData(closure : @escaping (([SportModel]) ->Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSportData {(sportModels, error) in
                        closure(sportModels)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSportData {(sportModels, error) in
                closure(sportModels)
            }
        }
    }
    
    func getSportRecordList() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSportRecordList()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSportRecordList()
        }
    }
    
    func getSportRecordData(id: Int, _ closure: @escaping CRPSmartBand.sportDetailHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSportRecordData(id: id) { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSportRecordData(id: id) { data, error in
                closure(data, error)
            }
        }
    }

    //MARK: - 睡眠
    /// 获取睡眠数据
    /// - Parameter closure: 睡眠信息
    func getSleepData(closure : @escaping ((SleepModel) ->Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSleepData { sleepModel, error in
                        closure(sleepModel)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSleepData { sleepModel, error in
                closure(sleepModel)
            }
        }
    }
    
    func getSleepDataWithREM(_ closure: @escaping ((CRPSmartBand.SleepModel, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSleepDataWithREM { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSleepDataWithREM { data, error in
                closure(data, error)
            }
        }
    }

    //MARK: - 活动步数
    /// 同步今⽇活动步数
    /// - Parameter closure: StepModel
    func getSteps(closure : @escaping ((StepModel) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getSteps { stepModel, error in
                        closure(stepModel)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getSteps { stepModel, error in
                closure(stepModel)
            }
        }
    }

    /// 获取今天步数统计
    /// - Parameter closure: [Int]
    func get24HourSteps(closure : @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.get24HourSteps { steps, error in
                        closure(steps)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.get24HourSteps { steps, error in
                closure(steps)
            }
        }
    }

    /// 获取昨天步数统计
    /// - Parameter closure: [Int]
    func getAgo24HourSteps(closure : @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAgo24HourSteps { steps, error in
                        closure(steps)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAgo24HourSteps { steps, error in
                closure(steps)
            }
        }
    }

    //MARK: - 设置时间制式
    /// 设置时间制（⼿环时间制式⽀持12⼩时制和24⼩时制。）
    /// - Parameter type:
    func setTimeFormat(_ type:Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setTimeFormat(type)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setTimeFormat(type)
        }
    }

    /// 查询⼿环正在使⽤的时间制式
    /// - Parameter closure: [Int]
    func getTimeformat(_ closure: @escaping ((Int) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getTimeformat { timeFormat, error in
                        closure(timeFormat)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getTimeformat { timeFormat, error in
                closure(timeFormat)
            }
        }
    }

    //MARK: - 目标步数
    /// 设置⽬标步数
    /// 向⼿环推送⽤户设置的⽬标步数，当天活动步数达到⽬标步数时，⼿环会有⽬标达成提示。
    /// - Parameter closure: [Int]
    func setGoal(_ goal: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setGoal(goal)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setGoal(goal)
        }
    }

    /// 查询⽬标步数
    /// 查询⼿环被设置的⽬标步数
    /// - Parameter closure: [Int]
    func getGoal(_ closure: @escaping ((Int) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getGoal { goal, error in
                        closure(goal)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getGoal { goal, error in
                closure(goal)
            }
        }
    }

    //MARK: - 心率
    /// 开始动态⼼率测量
    /// - Parameter closure:
    func setStartHeart() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStartHeart()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStartHeart()
        }
    }

    /// 停⽌动态⼼率测量
    /// 停⽌动态⼼率测量。测量结果通过receiveHeartRateAll(_ model: HeartModel)回调。
    func setStopHeart() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStopHeart()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStopHeart()
        }
    }

    /// 查询上次动态⼼率测量结果
    /// 在未连接状态下测量动态⼼率，⼿环可以保存最后⼀次的测量结果。结果通过receiveHeartRateAll回调。
    func getHeartData() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHeartData()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHeartData()
        }
    }

    /// 开启定时测量⼼率
    /// ⼿环⽀持24⼩时定时测量⼼率，从0点0分开始测量量，可以设置测量量时间间隔隔（0为关闭,正数为开启,并设置为测量量时间间隔为：正数 * 5分钟）
    /// - Parameter interval: 0为关闭,正数为开启,并设置为测量量时间间隔为：正数 * 5分钟
    func set24HourHeartRate(_ interval:Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.set24HourHeartRate(interval)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.set24HourHeartRate(interval)
        }
    }

    /// 获取24⼩时定时测量状态
    /// - Parameter closure:
    func get24HourHeartRateInterval(_ closure: @escaping ((Int) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.get24HourHeartRateInterval { headtRateInterval, error in
                        closure(headtRateInterval)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.get24HourHeartRateInterval { headtRateInterval, error in
                closure(headtRateInterval)
            }
        }
    }

    /// 查询今天定时测量⼼率数据
    /// - Parameter closure:
    func get24HourHeartRate(_ closure: @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.get24HourHeartRate { heartRate, error in
                        closure(heartRate)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.get24HourHeartRate { heartRate, error in
                closure(heartRate)
            }
        }
    }

    /// 查询昨天定时测量⼼率数据
    /// - Parameter closure:
    func getAgo24HourHeartRate(_ closure: @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAgo24HourHeartRate { heartRate, error in
                        closure(heartRate)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAgo24HourHeartRate { heartRate, error in
                closure(heartRate)
            }
        }
    }

    /// 开启静态⼼率单次测量
    func setStartSingleHR() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStartSingleHR()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStartSingleHR()
        }
    }

    /// 结束静态⼼率单次测量
    /// 结束单次测量量。测量量时间过短，会导致⽆⽆测量量数据。测量结果通过receiveHeartRate(_ heartRate: Int)回调。
    func setStopSingleHR() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStopSingleHR()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStopSingleHR()
        }
    }


    /// 获取单次⼼率测量历史记录(部分⼿环⽀持)
    /// - Parameter closure:[CRPHeartRecordModel] 单次⼼率测量历史记录
    func getHeartRecordData(_ closure: @escaping (([CRPHeartRecordModel]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getHeartRecordData { heartRecordData, error in
                        closure(heartRecordData)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getHeartRecordData { heartRecordData, error in
                closure(heartRecordData)
            }
        }
    }
    
    /// 全天心率？
    /// - Parameter closure:
    func getFullDayHeartRate(_ closure: @escaping CRPSmartBand.intsHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayHeartRate { datas, error in
                        closure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayHeartRate { datas, error in
                closure(datas, error)
            }
        }
    }
    

    //MARK: - 血压
    /// 开始测量⾎压。
    func setStartBlood() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStartBlood()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStartBlood()
        }
    }

    /// 停⽌测量⾎压
    /// 停⽌测量⾎压，测量时间过短会导致⽆测量结果。测量结果通过receiveBloodPressure(_heartRate: Int, _ sbp: Int, _ dbp: Int)回调。
    func setStopBlood() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStopBlood()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStopBlood()
        }
    }


    /// 设置全天⾎压
    /// - Parameter open: Bool
    func setFullDayBPStatus(open: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setFullDayBPStatus(open: open)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFullDayBPStatus(open: open)
        }
    }

    /// 获取全天⾎压状态
    /// - Parameter closure: Int ⾎压状态
    func getFullDayBPStatus(_ closure: @escaping ((Int) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayBPStatus { status, error in
                        closure(status)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayBPStatus { status, error in
                closure(status)
            }
        }
    }

    /// 获取全天⾎压数据
    /// - Parameter closure: [int]全天⾎压数据
    func getFullDayBPData(_ closure: @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayBPData { data, error in
                        closure(data)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayBPData { data, error in
                closure(data)
            }
        }

    }


    /// 获取单次⾎压测量历史记录
    /// - Parameter closure: [CRPBPRecordModel]单次⾎压测量历史记录
    func getBPRecordData(_ closure: @escaping (([CRPBPRecordModel]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getBPRecordData { data, error in
                        closure(data)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getBPRecordData { data, error in
                closure(data)
            }
        }
    }

    //MARK: - 血氧
    /// 开始测量⾎氧。
    func setStartSpO2() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStartSpO2()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStartSpO2()
        }
    }

    /// 停止测量⾎氧。
    /// 停⽌测量⾎氧，测量时间过短会导致⽆测量结果。结果通过receiveSpO2(_ o2: Int)回调。
    func setStopSpO2() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setStopSpO2()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setStopSpO2()
        }
    }

    /// 设置全天⾎氧
    /// - Parameter open: bool
    func setFullDayO2Status(open: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setFullDayO2Status(open: open)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setFullDayO2Status(open: open)
        }
    }

    /// 获取全天⾎氧状态
    /// - Parameter closure: Int 全天⾎氧状态
    func getFullDayO2Status(_ closure: @escaping ((Int) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayO2Status { status, error in
                        closure(status)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayO2Status { status, error in
                closure(status)
            }
        }
    }

    /// 获取全天⾎氧数据
    /// - Parameter closure: [int]全天⾎氧数据
    func getFullDayO2Data(_ closure: @escaping (([Int]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFullDayO2Data { data, error in
                        closure(data)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFullDayO2Data { data, error in
                closure(data)
            }
        }
    }

    /// 获取单次⾎氧测量历史记录
    /// - Parameter closure: [CRPO2RecordModel]单次⾎氧测量历史记录
    func getO2RecordData(_ closure: @escaping (([CRPO2RecordModel]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getO2RecordData { data, error in
                        closure(data)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getO2RecordData { data, error in
                closure(data)
            }
        }
    }
    
    
    /// 开启定时测量血氧
    /// - Parameter interval: 测量周期 = interval * 5 (mins)
    func setAutoO2(_ interval: Int){
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setAutoO2(interval)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setAutoO2(interval)
        }
    }
    
    
    /// 查询定时测血氧状态
    /// - Parameter closure: 间隔
    func getAutoO2Interval(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)){
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAutoO2Interval { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAutoO2Interval { data, error in
                closure(data, error)
            }
        }
    }
    
    /// 查询定时测血氧
    /// - Parameters:
    ///   - todayClosure: 今天的数据
    ///   - yesterdayyClosure: 昨天的数据
    func getAutoO2Data(_ todayClosure: @escaping (([Int], CRPSmartBand.CRPError) -> Void), _ yesterdayyClosure: @escaping (([Int], CRPSmartBand.CRPError) -> Void)){
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAutoO2Data { datas, error in
                        todayClosure(datas, error)
                    } _: { datas, error in
                        yesterdayyClosure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAutoO2Data { datas, error in
                todayClosure(datas, error)
            } _: { datas, error in
                yesterdayyClosure(datas, error)
            }
        }
    }

    //MARK: - 闹钟

    /// 设置手环闹钟
    /// - Parameter alarm: 闹钟model
    func setAlarm(alarm: AlarmModel){
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setAlarm(alarm)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setAlarm(alarm)
        }
    }

    func getAlarms(_ closure: @escaping ((_ alarms :[CRPSmartBand.AlarmModel]) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getAlarms { alarms, error in
                        closure(alarms)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getAlarms { alarms, error in
                closure(alarms)
            }
        }
    }

    //MARK: - 快捷通讯（联系人）-

    /// 获取联系人配置项
    /// - Parameter closure: 联系人配置项
    func getContactProfile(_ closure: @escaping (CRPSmartBand.contactProfileModel, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getContactProfile { contactProfile, error in
                        closure(contactProfile,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getContactProfile { contactProfile, error in
                closure(contactProfile,error)
            }
        }
    }

    /// 设置联系人
    /// - Parameters:
    ///   - profile: 联系人配置项
    ///   - contacts: 联系人数组
    func setContact(profile: contactProfileModel, contacts: [CRPContact]) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setContact(profile: profile, contacts: contacts)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setContact(profile: profile, contacts: contacts)
        }
    }

    /// 清空联系人
    func cleanAllContact() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.cleanAllContact()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.cleanAllContact()
        }
    }

    /// 删除指定联系人
    /// - Parameter contactID: 要删除的联系人的id
    func deleteContact(contactID: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.deleteContact(contactID: contactID)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.deleteContact(contactID: contactID)
        }
    }

    /// 获取当前联系人个数
    /// - Parameter closure: 返回联系人个数，int
    func getContactCount(closure: @escaping (Int, CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getContactCount { contactCount, error in
                        closure(contactCount,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getContactCount { contactCount, error in
                closure(contactCount,error)
            }
        }
    }

    //MARK: - 消息推送 -

    /// 查询其他消息推送状态
    /// - Parameter closure: 返回int数组和error
    func getNotifications(closure: @escaping ([Int], CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getNotifications { datas, error in
                        closure(datas,error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getNotifications { datas, error in
                closure(datas,error)
            }
        }
    }

    /// 开启或者关闭其他消息推送
    /// - Parameter types: NotificationType数组
    func setNotification(WithTypes types: [NotificationType]) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setNotification(types)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setNotification(types)
        }
    }
    
    
    //MARK: - 部分没有注释的接口 -
    
    /// 获取特征？
    /// - Parameter closure:
    func getFeatures(_ closure: @escaping (([Int], CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getFeatures { datas, error in
                        closure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getFeatures { datas, error in
                closure(datas, error)
            }
        }
    }
    //MARK: - DominantHand -
    func setDominantHand(_ type: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setDominantHand(type)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setDominantHand(type)
        }
    }
    
    func getDominantHand(_ closure: @escaping ((Int, CRPSmartBand.CRPError) -> Void)) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getDominantHand { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getDominantHand { data, error in
                closure(data, error)
            }
        }
    }
    
    //MARK: - unit -
    
    func setUnit(_ unit: Int) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setUnit(unit)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setUnit(unit)
        }
    }
    
    
    /// 获取单位类型？
    /// - Parameter closure:
    func getUnit(_ closure: @escaping CRPSmartBand.intHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getUnit { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getUnit { data, error in
                closure(data, error)
            }
        }
    }
    
    //MARK: - mac -
    /// 获取mac地址？
    /// - Parameter closure:
    func getMac(_ closure: @escaping CRPSmartBand.stringHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getMac { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getMac { data, error in
                closure(data, error)
            }
        }
    }
    
    func getViews(_ closure: @escaping CRPSmartBand.intsHandler){
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getViews { datas, error in
                        closure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getViews { datas, error in
                closure(datas, error)
            }
        }
    }
    
    func getConnectedBand(_ closure: @escaping ([CBPeripheral], CRPSmartBand.CRPError) -> Void) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getConnectedBand { datas, error in
                        closure(datas, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getConnectedBand { datas, error in
                closure(datas, error)
            }
        }
    }
    
    func setCalibrationBlood(_ heartRate: Int = 0, _ SBP: Int = 0, _ DBP: Int = 0) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setCalibrationBlood(heartRate, SBP, DBP)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setCalibrationBlood(heartRate, SBP, DBP)
        }
    }
    
    func setMessage(_ message: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setMessage(message)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setMessage(message)
        }
    }
    
    func setViews(_ views: [Int]) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.setViews(views)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.setViews(views)
        }
    }
    
    func startUpgrede(info: CRPSmartBand.newVersionInfo) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startUpgrede(info: info)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startUpgrede(info: info)
        }
    }
    
    func startUpgradeFromFile(path: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startUpgradeFromFile(path: path)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startUpgradeFromFile(path: path)
        }
    }
    
    func startGoodixUpgradeFromFile(zipPath: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startGoodixUpgradeFromFile(zipPath: zipPath)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startGoodixUpgradeFromFile(zipPath: zipPath)
        }
    }
    
    func checkDFUState(_ closure: @escaping CRPSmartBand.stringHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.checkDFUState { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.checkDFUState { data, error in
                closure(data, error)
            }
        }
    }
    
    func stopUpgrade() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.stopUpgrade()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.stopUpgrade()
        }
    }
    
    func getOTAMac(_ closure: @escaping CRPSmartBand.stringHandler) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.getOTAMac { data, error in
                        closure(data, error)
                    }
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.getOTAMac { data, error in
                closure(data, error)
            }
        }
    }
    
    func startHTXOTA(info: CRPSmartBand.newVersionInfo, upgradeMac: String, isUser: Bool, _ isPatch: Bool = true) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startHTXOTA(info: newVersionInfo(), upgradeMac: upgradeMac, isUser: isUser, isPatch)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startHTXOTA(info: info, upgradeMac: upgradeMac, isUser: isUser, isPatch)
        }
    }
    
    func stopHTXOTA() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.stopHTXOTA()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.stopHTXOTA()
        }
    }
    
    func HTXConnect(discovery: CRPSmartBand.CRPDiscovery, isFromLocal: Bool, url: String, isUser: Bool) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.HTXConnect(discovery: discovery, isFromLocal: isFromLocal, url: url, isUser: isUser)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.HTXConnect(discovery: discovery, isFromLocal: isFromLocal, url: url, isUser: isUser)
        }
    }
    
    func startOTAFromFile(mac: String!, zipFilePath: String, isUser: Bool, _ isPatch: Bool = true) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startOTAFromFile(mac: mac, zipFilePath: zipFilePath, isUser: isUser, isPatch)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startOTAFromFile(mac: mac, zipFilePath: zipFilePath, isUser: isUser, isPatch)
        }
    }
    
    func reconnectHTX(OTAMac: String) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.reconnectHTX(OTAMac: OTAMac)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.reconnectHTX(OTAMac: OTAMac)
        }
    }
    
    func fatigueReminder() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.fatigueReminder()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.fatigueReminder()
        }
    }
    
    func sendFirstConnect() {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.sendFirstConnect()
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.sendFirstConnect()
        }
    }
    
    func startRealTekUpgrade(info: CRPSmartBand.newVersionInfo, timeoutInterval: TimeInterval = 5) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startRealTekUpgrade(info: info, timeoutInterval: timeoutInterval)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startRealTekUpgrade(info: info, timeoutInterval: timeoutInterval)
        }
    }
    
    func startRealTekUpgradeFromFile(path: String, timeoutInterval: TimeInterval = 5) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startRealTekUpgradeFromFile(path: path, timeoutInterval: timeoutInterval)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startRealTekUpgradeFromFile(path: path, timeoutInterval: timeoutInterval)
        }
    }
    
    func startTpUpgrade(tpInfo: CRPSmartBand.newVersionTpInfo?) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startTpUpgrade(tpInfo: tpInfo)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startTpUpgrade(tpInfo: tpInfo)
        }
    }
    
    func startTpUpgradeFromFile(path: String, _ offset: Int = 0x886000) {
        if self.deviceState != .connected {
            NKBluetoothManager.shared.returnDidStateClosure { deviceState in
                if deviceState == .connected {
                    CRPSmartBandSDK.sharedInstance.startTpUpgradeFromFile(path: path, offset)
                }
            }
        }
        else {
            CRPSmartBandSDK.sharedInstance.startTpUpgradeFromFile(path: path, offset)
        }
    }
}

//MARK: - SDK的回调

@available(iOS 10.0, *)
extension NKBluetoothManager: CRPManagerDelegate {

    /// 返回当前的⼿环的连接状态
    /// - Parameter closure: CRPState
    func didState(_ state: CRPState) {
        self.deviceState = state
        if self.didStateClosure != nil {
            self.didStateClosure(state)
        }
    }

    /// 返回当前蓝⽛状态
    /// - Parameter closure: CRPBluetoothState
    func didBluetoothState(_ state: CRPBluetoothState) {
//        if self.didBluetoothStateClosure != nil {
//            self.didBluetoothStateClosure(state)
//        }
    }

    /// 接收实时的运动计步数据
    /// - Parameter closure: StepModel
    func receiveSteps(_ model: StepModel) {
        if self.receiveStepsClosure != nil {
            self.receiveStepsClosure(model)
        }
    }

    /// 接收⼼率测量结果(单次测量⼼率)
    /// - Parameter closure: Int
    func receiveHeartRate(_ heartRate: Int) {
        if receiveHeartRateClosure != nil {
            self.receiveHeartRateClosure(heartRate)
        }
    }

    /// 接收实时⼼率数据(⼀般只⽤于显示不⽤于存储，部分⼿环⽀持返回实时RRI数据)
    /// - Parameter closure: HeartModel
    func receiveRealTimeHeartRate(_ heartRate: Int, _ rri: Int) {
        if self.receiveRealTimeHeartRateClosure != nil {
            self.receiveRealTimeHeartRateClosure(heartRate, rri)
        }
    }

    /// 查询上次动态⼼率测量结果
    /// - Parameter closure: HeartModel
    func receiveHeartRateAll(_ model: HeartModel) {
        if self.receiveHeartRateAllClosure != nil {
            self.receiveHeartRateAllClosure(model)
        }
        CRPSmartBandSDK.sharedInstance.getSportData {[weak self] sportModels, error in
            guard let self = self else { return }
            if self.receiveSportsClosure != nil{
                self.receiveSportsClosure(sportModels)
            }
        }
    }

    /// 接收⾎压测量结果
    /// - Parameter closure: (Int, Int, Int)
    func receiveBloodPressure(_ heartRate: Int, _ sbp: Int, _ dbp: Int) {
        if self.receiveBloodPressureClosure != nil {
            self.receiveBloodPressureClosure(heartRate, sbp, dbp)
        }
    }

    /// 接收⾎氧测量结果
    /// - Parameter closure: Int
    func receiveSpO2(_ o2: Int) {
        if self.receiveSpO2Closure != nil {
            self.receiveSpO2Closure(o2)
        }
    }

    func receiveUpgrede(_ state: CRPUpgradeState, _ progress: Int) {
        if self.receiveUpgradeClosure != nil {
            self.receiveUpgradeClosure(state, progress)
        }
    }

    /// 升级表盘文件/图片时的回调
    /// - closure:
    ///   - state: 状态
    ///   - progress: 进度
    /// 升级表盘文件/图片时的回调
    /// - Parameter closure: (CRPUpgradeState, Int)
    func receiveUpgradeScreen(_ state: CRPUpgradeState, _ progress: Int) {
        if self.receiveUpgradeScreenClosure != nil {
            self.receiveUpgradeScreenClosure(state, progress)
        }
    }

    /// 收到拍照请求
    /// ⻓按⼿环拍照界⾯，可以触发⼿环的拍照指令，回调在这里
    /// - Parameter closure:
    func recevieTakePhoto() {
        if self.receiveTakePhotoClosure != nil {
            self.receiveTakePhotoClosure()
        }
    }

    /// 收到天⽓获取请求
    /// - Parameter closure:
    func recevieWeather() {
        if receiveWeatherClosure != nil {
            self.receiveWeatherClosure()
        }
    }

    /// 收到查找⼿机请求
    /// - Parameter closure: state
    func recevieFindPhone(_ state: Int) {
        if self.receiveFindPhoneClosure != nil {
            self.receiveFindPhoneClosure(state)
        }
    }

    /// 收到实时的体温数值(
    /// - Parameter ⼿环收到实时体温数值后，保留最后⼀次收到的值，当收到测量结束状态时，最后的值就是测量结果
    func receiveRealTimeTemperature(_ temp: Double) {
        if self.receiveRealTimeTemperatureClosure != nil {
            self.receiveRealTimeTemperatureClosure(temp)
        }
    }

    /// 收到体温测量状态
    /// - Parameter closure: ⽤于判断单次体温测量的状态 收到state为1时为正在测量，收到state为0时为测量结束
    func receiveTemperature(_ state: Int) {
        if self.receiveTemperatureClosure != nil {
            self.receiveTemperatureClosure(state)
        }
    }

    /// 收到⼀键呼叫请求
    func receiveCalling() {
        if self.receiveCallingClosure != nil {
            self.receiveCallingClosure()
        }
    }

    /// 收到HRV实时数据
    /// - Parameter model: CRPHRVDataModel
    func receviceHRVRealTime(_ model: CRPHRVDataModel) {
        if self.receviceHRVRealTimeClosure != nil {
            self.receviceHRVRealTimeClosure(model)
        }
    }

    /// 收到当前来电号码
    /// - Parameter number: String
    func receivePhoneNumber(number: String) {
        if self.receivePhoneNumberClosure != nil {
            self.receivePhoneNumberClosure(number)
        }
    }

    /// 收到吃药提醒数据
    /// - Parameter closure: _ max: Int,_ model: CRPMedicineReminderModel
    func receiveMedicineInfo(_ max: Int, _ model: CRPMedicineReminderModel?) {
        if self.receiveMedicineInfoClosure != nil {
            self.receiveMedicineInfoClosure(max, model)
        }
    }

    /// 收到运动模式状态
    /// - Parameter state: SportType
    func receiveSportState(_ state: SportType) {
        if self.receiveSportStateClosure != nil {
            self.receiveSportStateClosure(state)
        }
    }



    func receiveECGDate(_ state: ecgState, _ data: [UInt32], completeTime: Int) {
        if self.receiveECGDateClosure != nil {
            self.receiveECGDateClosure(state, data, completeTime)
        }
    }


}
