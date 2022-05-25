//
//  MYScanPlugin.swift
//  moyoung_ble_plugin
//
//  Created by 魔样科技 on 2022/5/21.
//

import Foundation
import Flutter
import CRPSmartBand

public class MYScanPlugin: NSObject {
    var myDiscovery:CRPDiscovery!
    lazy var discoverys: [CRPDiscovery] = [CRPDiscovery]()
    
    
    /// flutter:   接收 扫描到的设备的监听
    var scannedDevicesEventSink: FlutterEventSink?
    /// flutter:    接收设备连接状态的监听
    var connectionStateEventSink: FlutterEventSink?
    /// flutter:    接收实时的运动计步数据的监听
    var stepsEventSink: FlutterEventSink?
    /// flutter:    的监听
    var tainEventSink: FlutterEventSink?
    /// flutter:   体温的监听
    var temperatureEventSink: FlutterEventSink?
    /// flutter:    接收设备电量的监听
    var batteryEventSink: FlutterEventSink?
    /// flutter:    天气的监听
    var weatherEventSink: FlutterEventSink?
    /// flutter:    的监听
    var stepsCategoryEventSink: FlutterEventSink?
    /// flutter:    睡眠的监听
    var sleepEventSink: FlutterEventSink?
    /// flutter:    固件升级的监听
    var firmwareUpgradeEventSink: FlutterEventSink?
    /// flutter:    接收⼼率测量结果(单次测量⼼率)的监听
    var heartRateEventSink: FlutterEventSink?
    /// flutter:    接收⾎压测量结果
    var bloodPressureEventSink: FlutterEventSink?
    /// flutter:    接收⾎氧测量结果的监听
    var bloodOxygenEventSink: FlutterEventSink?
    /// flutter:    的监听
    var phoneEventSink: FlutterEventSink?
    /// flutter:    的监听
    var deviceRSSIEventSink: FlutterEventSink?
    /// flutter:    的监听
    var fileTransEventSink: FlutterEventSink?
    /// flutter:    电量的监听
    var wfFileTransEventSink: FlutterEventSink?
    /// flutter:    电量的监听
    var egcEventSink: FlutterEventSink?
    /// flutter:    联系人头像的监听
    var contactAvatarEventSink: FlutterEventSink?
}

extension MYScanPlugin: FlutterPlugin, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        scannedDevicesEventSink = events
        batteryEventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        scannedDevicesEventSink = nil
        batteryEventSink = nil
        return nil
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        //方法的通道
        let scanChannel = FlutterMethodChannel(name: METHOD_CHL_BLE_SCAN, binaryMessenger: registrar.messenger())
        let connectChannel = FlutterMethodChannel(name: METHOD_CHL_CONN, binaryMessenger: registrar.messenger())
        //创建类对象
        let instance = MYScanPlugin()
        //添加注册
        registrar.addMethodCallDelegate(instance, channel: scanChannel)
        registrar.addMethodCallDelegate(instance, channel: connectChannel)
        //
        let scanEventChannel = FlutterEventChannel(name: EVE_CHL_BLE_SCAN, binaryMessenger: registrar.messenger())
        scanEventChannel.setStreamHandler(instance)
        //电量监听
        let batteryEventChannel = FlutterEventChannel(name: EVE_CHL_CONN_BATTERY_SAVING, binaryMessenger: registrar.messenger())
        batteryEventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var receivedDic: [String: Any] = [:]
        if call.arguments is [String: Any] {
            receivedDic = call.arguments as! [String : Any]
        }
 
        print("flutter方法是：\(call.method)，flutter发送过来的数据是：\(receivedDic)")
        
        //MARK: - 扫描连接 -

        //开始扫描
        if call.method == "startScan" {
            CRPSmartBandSDK.sharedInstance.scan {[weak self] datas in
                guard let self = self else { return  }
                for p in datas {
                    if p.localName?.isEmpty == true {
                        return
                    }
                    self.discoverys.append(p)
                    var param: [String: Any] = [:]
                    param["isCompleted"] = false
                    param["address"] = p.mac
                    param["mRssi"] = p.RSSI
                    param["mScanRecord"] = [Int]()
                    param["name"] = p.localName
                    let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                    result(true)
                    print("扫描到的设备为：\(str)")
                    self.scannedDevicesEventSink?(str)
                }
                
            } completionHandler: {[weak self] (datas, error) in
                guard let self = self else { return  }
                print("error = \(error)")
                var param: [String: Any] = [:]
                param["isCompleted"] = true
                param["address"] = ""
                param["mRssi"] = ""
                param["mScanRecord"] = [Int]()
                param["name"] = ""
                let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                result(true)
                print("扫描到的设备为：\(str)")
                self.scannedDevicesEventSink?(str)
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
        else if call.method == "startScanWithPeriod" {
            //取消扫描
            CRPSmartBandSDK.sharedInstance.scan(10) {[weak self] datas in
                guard let self = self else { return  }
                for p in datas {
                    if p.localName?.isEmpty == true {
                        return
                    }
                    self.discoverys.append(p)
                    var param: [String: Any] = [:]
                    param["isCompleted"] = false
                    param["address"] = p.mac
                    param["mRssi"] = p.RSSI
                    param["mScanRecord"] = [Int]()
                    param["name"] = p.localName
                    let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                    result(true)
                    print("扫描到的设备为：\(str)")
                    self.scannedDevicesEventSink?(str)
                }
            } completionHandler: {[weak self] datas, error in
                guard let self = self else { return  }
                print("error = \(error)")
                var param: [String: Any] = [:]
                param["isCompleted"] = true
                param["address"] = ""
                param["mRssi"] = ""
                param["mScanRecord"] = [Int]()
                param["name"] = ""
                let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                result(true)
                print("扫描到的设备为：\(str)")
                self.scannedDevicesEventSink?(str)
            }

        }
        else if call.method == "cancelScan" {
            //取消扫描
            CRPSmartBandSDK.sharedInstance.interruptScan()
        }
        else if call.method == "isConnected" {
            print("address:\(receivedDic)")
        }
        else if call.method == "connect" {
            //连接
            print("address:\(receivedDic)")
            for p in self.discoverys {
                if p.mac == receivedDic["address"] as? String {
                    myDiscovery = p
                    CRPSmartBandSDK.sharedInstance.connet(p)
                    return
                }
            }
        }
        else if call.method == "disconnect" {
            //断开连接
            CRPSmartBandSDK.sharedInstance.disConnet()
        }
        //MARK: - 同步时间 -
        else if call.method == "syncTime" {
            //同步时间
            CRPSmartBandSDK.sharedInstance.setTime()
        }
        //MARK: - 设置时间制式 -
        else if call.method == "sendTimeSystem" {
            //设置时间制
            print("timeSystemType:\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setTimeFormat(receivedDic["timeSystemType"] as! Int)
        }
        else if call.method == "queryTimeSystem" {
            //查询时间制式
            CRPSmartBandSDK.sharedInstance.getTimeformat { timeFormat, error in
                print("要传给flutter的timeFormat\(timeFormat)")
                result(timeFormat)
            }
        }
        //MARK: - 查询手环电量 -
        else if call.method == "queryDeviceBattery" {
            //查询手环电量
            CRPSmartBandSDK.sharedInstance.getBattery { battery, error in
                print("要传给flutter的battery\(battery)")
                self.batteryEventSink?(battery)
            }
        }
        else if call.method == "subscribeDeviceBattery" {
            //订阅手环电量
        }
        //MARK: - 固件升级 -
        else if call.method == "firmwareUpgrade" {
            print("接收到的firmwareUpgradeFlag\(receivedDic)")
            
        }
        else if call.method == "firmwareAbort" {
            
        }
        else if call.method == "queryDeviceDfuStatus" {
            print("要传给flutter的queryDeviceDfuStatus\("")")
        }
        else if call.method == "queryHsDfuAddress" {
            print("要传给flutter的queryHsDfuAddress\("")")
        }
        else if call.method == "enableHsDfu" {
            
        }
        else if call.method == "queryDfuType" {
            print("要传给flutter的queryDfuType\("")")
        }
        else if call.method == "firmwareUpgradeByHsDfu" {
            print("接收到的address\(receivedDic)")
        }
        else if call.method == "firmwareUpgradeByRtkDfu" {
            print("接收到的address\(receivedDic)")
        }
        else if call.method == "firmwareAbortByHsDfu" {
            
        }
        else if call.method == "firmwareAbortByRtkDfu" {
            
        }
        
        
        
        
        
        else if call.method == "queryFirmwareVersion" {
            //查询⼿环当前固件版本
            CRPSmartBandSDK.sharedInstance.getSoftver {(softver, error) in
                result(softver)
            }
        }
        else if call.method == "checkFirmwareVersion" {
            //查询新固件
            CRPSmartBandSDK.sharedInstance.checkLatest("", "") { newVerInfo, newVerTpInfo, error in
                result(newVerInfo)
            }
        }
        //MARK: - 用户信息 -
        else if call.method == "sendUserInfo" {
            //设置⽤户信息
            print("接收到的userinfo\(receivedDic)")
            let userInfoDic: Dictionary = SystemAuth.getDictionaryFromJSONString(jsonString: receivedDic["userInfo"] as! String)
            let model: ProfileModel = ProfileModel(height: userInfoDic["height"] as! Int, weight: userInfoDic["weight"] as! Int, age: userInfoDic["age"] as! Int, gender: GenderOption(rawValue: GenderOption.RawValue(userInfoDic["gender"] as! Int)) ?? .male)
            CRPSmartBandSDK.sharedInstance.setProfile(model)
        }
        else if call.method == "sendStepLength" {
            //设置步⻓
            print("接收到的stepLength\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setStepLength(length: receivedDic["stepLength"] as! Int)
        }
        //MARK: - 天气 -
        else if call.method == "sendTodayWeather" {
            //设置今⽇天⽓
            print("接收到的todayWeatherInfo\(receivedDic)")
            let weatherDic: Dictionary = SystemAuth.getDictionaryFromJSONString(jsonString: receivedDic["todayWeatherInfo"] as! String)
            let todayWeather:CRPSmartBand.weather = weather.init(type: weatherDic["weatherId"] as! Int, temp: weatherDic["temp"] as! Int , pm25: weatherDic["pm25"] as! Int, festival: weatherDic["festival"] as! String, city: weatherDic["city"] as! String)
            CRPSmartBandSDK.sharedInstance.setWeather(todayWeather)
        }
        else if call.method == "sendFutureWeather" {
            //设置未来7⽇天⽓
            print("接收到的futureWeatherInfo\(receivedDic)")
            let weatherDic: Dictionary = SystemAuth.getDictionaryFromJSONString(jsonString: receivedDic["futureWeatherInfo"] as! String)
            let futureWeather:CRPSmartBand.forecastWeather = forecastWeather.init(type: weatherDic["weatherId"] as! Int, maxTemp: weatherDic["temp"] as! Int, minTemp: weatherDic["temp"] as! Int)
            CRPSmartBandSDK.sharedInstance.setForecastWeather([futureWeather])
        }
        else if call.method == "sendLocalCity" {
            //设置本地城市
            print("接收到的city\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendCityName(receivedDic["city"] as! String)
        }
        //MARK: - 体温 -
        else if call.method == "queryMetricSystem" {
            //获取体温单位
            CRPSmartBandSDK.sharedInstance.getTemperatureUnit { temperature, error in
                print("要传给Flutter的queryMetricSystem\(temperature)")
                result(temperature)

            }
        }
        else if call.method == "sendMetricSystem" {
            //设置体温单位
            print("接收到的设置体温单位metricSystemType\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setTemperatureUnit(receivedDic["metricSystemType"] as! Int)
        }
        //MARK: - 翻腕亮屏 -
        else if call.method == "sendQuickView" {
            //设置翻腕亮屏状态
            print("接收到的翻腕亮屏状态quickViewState\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setQuickView((receivedDic["quickViewState"] != nil))
        }
        else if call.method == "queryQuickView" {
            //查询⼿环翻腕亮屏开启状态,0: 关闭 1： 开启
            CRPSmartBandSDK.sharedInstance.getQuickView { state, error in
                print("要传给Flutter的⼿环翻腕亮屏开启状态queryQuickView\(state)")
                result(state)
            }
        }
        else if call.method == "sendQuickViewTime" {
            //设置翻腕亮屏时间
            print("接收到的翻腕亮屏时间periodTimeInfo\(receivedDic)")
            let periodTimeDic: [String: Any] = receivedDic["periodTimeInfo"] as! [String : Any]
            let model = periodTimeModel.init(startHour: periodTimeDic["startHour"] as! Int, startMin: periodTimeDic["startMinute"] as! Int, endHour: periodTimeDic["endHour"] as! Int, endMin: periodTimeDic["endMinute"] as! Int)
            CRPSmartBandSDK.sharedInstance.setQuickViewTime(model)
        }
        else if call.method == "queryQuickViewTime" {
            //获取翻腕亮屏时间
            CRPSmartBandSDK.sharedInstance.getQuickViewTime { model, error in
                print("要传给Flutter的翻腕亮屏时间queryQuickViewTime\(model)")
                var param: [String: Any] = [:]
                param["startHour"] = model.startHour
                param["startMinute"] = model.startMin
                param["endHour"] = model.endHour
                param["endMinute"] = model.endMin
                let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                result(str)
                
            }
        }
        //MARK: - 目标步数 -
        else if call.method == "syncStep" {
            //同步步数
            
        }
        else if call.method == "syncPastStep" {
            //同步过去的步数

        }
        else if call.method == "queryStepsCategory" {
            //查询步数类别
            print("接收到的stepsCategoryDateType\(receivedDic)")
        }
        else if call.method == "sendGoalSteps" {
            //设置目标步数
            print("接收到的目标步数goalSteps\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setGoal(receivedDic["goalSteps"] as! Int)
        }
        else if call.method == "queryGoalStep" {
            //查询⽬标步数
            CRPSmartBandSDK.sharedInstance.getGoal { goal, error in
                print("要传给flutter的⽬标步数queryGoalStep\(goal)")
                result(goal)
            }
        }
        //MARK: - 表盘 -
        else if call.method == "sendDisplayWatchFace" {
            //切换⼿环表盘
            print("接收到的切换⼿环表盘watchFaceType\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setDial(receivedDic["watchFaceType"] as! Int)
        }
        else if call.method == "queryDisplayWatchFace" {
            //查询⼿环正在使⽤的表盘序号
            CRPSmartBandSDK.sharedInstance.getDial { number, error in
                print("要传给flutter的number\(number)")
                result(number)
            }
        }
        else if call.method == "queryWatchFaceLayout" {
            //获取指定表盘布局
            CRPSmartBandSDK.sharedInstance.getScreenContent { content, imageSize, i, error in
                result("要传给Flutter的数据queryWatchFaceLayout")
            }
        }
        else if call.method == "sendWatchFaceLayout" {
            //修改⾃定义表盘布局
            print("接收到的watchFaceLayoutInfo:\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setupScreenContent(content: ScreenContent())
        }
        else if call.method == "querySupportWatchFace" {
            //获取⽀持摆盘类型
            CRPSmartBandSDK.sharedInstance.getWatchFaceSupportModel { model, error in
                result("要传给Flutter的数据querySupportWatchFace")
            }
        }
        else if call.method == "queryWatchFaceStore" {
            //获取表盘市场,根据表盘的⽀持类型获取能可以更换的表盘列表(分⻚获取)
            print("接收到的数据：watchFaceStoreBean\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfo([1,2], currentPage: 1, perPage: 18) { datas, currentPage, perPage, error in
                result("要传给Flutter的数据WatchFaceStore")
            }
        }
        else if call.method == "queryWatchFaceOfID" {
            //获取表盘ID的表盘信息
            print("接收到的queryWatchFaceOfID:\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfoByID(0) { datas, currentPage, perPage, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendWatchFaceBackground" {
            //设置表盘背景
            print("接收到的watchFaceBackgroundInfo：\(receivedDic)")
            
        }
        else if call.method == "sendWatchFace" {
            //
            print("接收到的watchFaceFlutterBean和timeout：\(receivedDic)")
            
        }
        
        
        
        
        //MARK: - 闹钟 -
        else if call.method == "sendAlarmClock" {
            //设置手环闹钟
            print("接收到的alarmClockInfo：\(receivedDic)")
            
            CRPSmartBandSDK.sharedInstance.setAlarm(AlarmModel())
        }
        else if call.method == "queryAllAlarmClock" {
            //查询所有闹钟
            CRPSmartBandSDK.sharedInstance.getAlarms { alarms, error in
                result(alarms)
                print("要传给flutter的queryAllAlarmClock\(alarms)")
            }
        }
        //MARK: - 心率 -
        else if call.method == "queryLastDynamicRate" {
            //查询上次动态⼼率测量结果,receiveHeartRateAll回调
            print("接收到的type\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.getHeartData()
        }
        else if call.method == "enableTimingMeasureHeartRate" {
            //开始定时测量心率，正数为开启
            print("接收到的interval\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.set24HourHeartRate(1)
        }
        else if call.method == "disableTimingMeasureHeartRate" {
            //关闭定时测量心率，0为关闭
            CRPSmartBandSDK.sharedInstance.set24HourHeartRate(0)
        }
        else if call.method == "queryTimingMeasureHeartRate" {
            //获取24⼩时定时测量状态
            CRPSmartBandSDK.sharedInstance.get24HourHeartRateInterval { headtRateInterval, error in
                result(headtRateInterval)
                print("要传给flutter的queryTimingMeasureHeartRate\(headtRateInterval)")
            }
        }
        else if call.method == "queryTodayHeartRate" {
            //查询今天定时测量⼼率数据
            print("接收到的heartRateType\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.get24HourHeartRate { heartRate, error in
                result(heartRate)
            }
        }
        else if call.method == "queryPastHeartRate" {
            //查询昨天定时测量⼼率数据
            CRPSmartBandSDK.sharedInstance.getAgo24HourHeartRate { heartRate, error in
                result(heartRate)
            }
        }
        else if call.method == "queryMovementHeartRate" {
            //获取运动数据,测量量结果包括⼼⼼率和卡路⾥等其它运动相关数据,保存最近三次
            //这个方法没有传值，没有返回
//            CRPSmartBandSDK.sharedInstance.getSportData {[weak self] sportModels, error in
//                guard let self = self else { return }
//                result(sportModels)
//            }
        }
        else if call.method == "startMeasureOnceHeartRate" {
            //开启静态⼼率单次测量
            CRPSmartBandSDK.sharedInstance.setStartSingleHR()
        }
        else if call.method == "stopMeasureOnceHeartRate" {
            //结束静态⼼率单次测量,测量结果通过receiveHeartRate(_ heartRate: Int)回调
            CRPSmartBandSDK.sharedInstance.setStopSingleHR()
        }
        else if call.method == "queryHistoryHeartRate" {
            //获取单次⼼率测量历史记录
//            CRPSmartBandSDK.sharedInstance.getHeartRecordData { heartRecordData, error in
//                result(heartRecordData)
//            }
        }
        //MARK: - 血压 -
        else if call.method == "startMeasureBloodPressure" {
            //开始测量⾎压
            CRPSmartBandSDK.sharedInstance.setStartBlood()
        }
        else if call.method == "stopMeasureBloodPressure" {
            //停⽌测量⾎压,测量结果通过receiveBloodPressure(_heartRate: Int, _ sbp: Int, _ dbp: Int)回调
            CRPSmartBandSDK.sharedInstance.setStopBlood()
        }
        else if call.method == "enableContinueBloodPressure" {
            //设置全天⾎压
            CRPSmartBandSDK.sharedInstance.setFullDayBPStatus(open: true)
        }
        else if call.method == "disableContinueBloodPressure" {
            //设置全天⾎压
            CRPSmartBandSDK.sharedInstance.setFullDayBPStatus(open: false)
        }
        else if call.method == "queryContinueBloodPressureState" {
            //获取全天⾎压状态
            CRPSmartBandSDK.sharedInstance.getFullDayBPStatus { status, error in
                
            }
        }
        else if call.method == "queryLast24HourBloodPressure" {
            //获取全天⾎压数据
            CRPSmartBandSDK.sharedInstance.getFullDayBPData { data, error in
                
            }
        }
        else if call.method == "queryHistoryBloodPressure" {
            //获取单次⾎压测量历史记录
            CRPSmartBandSDK.sharedInstance.getBPRecordData { data, error in
                
            }
        }
        //MARK: - 血氧 -
        else if call.method == "startMeasureBloodOxygen" {
            //开始测量⾎氧
            CRPSmartBandSDK.sharedInstance.setStartSpO2()
        }
        else if call.method == "stopMeasureBloodOxygen" {
            //停⽌测量⾎氧
            CRPSmartBandSDK.sharedInstance.setStopSpO2()
        }
        else if call.method == "enableTimingMeasureBloodOxygen" {
            //开启定时测量血氧
            print("接收到的interval\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setAutoO2(1)
        }
        else if call.method == "disableTimingMeasureBloodOxygen" {
            //禁用计时测量血氧
            CRPSmartBandSDK.sharedInstance.setAutoO2(0)
        }
        else if call.method == "queryTimingBloodOxygenMeasureState" {
            //查询定时测血氧状态
            CRPSmartBandSDK.sharedInstance.getAutoO2Interval { data, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryTimingBloodOxygen" {
            //查询定时测血氧
            print("接收到的bloodOxygenTimeType\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.getAutoO2Data { todayData, error in
                
            } _: { yesterdayData, error in
                
            }
        }
        else if call.method == "enableContinueBloodOxygen" {
            //设置全天⾎氧
            CRPSmartBandSDK.sharedInstance.setFullDayO2Status(open: true)
        }
        else if call.method == "disableContinueBloodOxygen" {
            //设置全天⾎氧
            CRPSmartBandSDK.sharedInstance.setFullDayO2Status(open: false)
        }
        else if call.method == "queryContinueBloodOxygenState" {
            //查询持续的血氧状态
            //             CRPSmartBandSDK.sharedInstance.returnReceiveSpO2Closure { state in
            //                 result("要传给Flutter的数据")
            //             }
        }
        else if call.method == "queryLast24HourBloodOxygen" {
            //查询最近24小时血氧
            CRPSmartBandSDK.sharedInstance.getFullDayO2Data { data, error in
                
            }
        }
        else if call.method == "queryHistoryBloodOxygen" {
            //获取单次⾎氧测量历史记录
            CRPSmartBandSDK.sharedInstance.getO2RecordData { data, error in
                
            }
        }
        //MARK: - 拍照 - iOS端暂时没有
        else if call.method == "enterCameraView" {
            //进入相机
            CRPSmartBandSDK.sharedInstance.switchCameraView()
        }
        else if call.method == "exitCameraView" {
            //退出相机
            CRPSmartBandSDK.sharedInstance.exitCameraView()
        }
        //MARK: - RSSI - iOS端暂时没有
        else if call.method == "readDeviceRssi" {
            //读取手表的实时RSSI
            
        }
        //MARK: - 心电图测量 -
        else if call.method == "startECGMeasure" {
            //开始测量心电图
            CRPSmartBandSDK.sharedInstance.startECGMeasure()
        }
        else if call.method == "stopECGMeasure" {
            //停⽌⼼电测量
            CRPSmartBandSDK.sharedInstance.stopECGMeasure()
        }
        else if call.method == "isNewECGMeasurementVersion" {
            //检测是否是新的⼼电测量⽅式
            CRPSmartBandSDK.sharedInstance.isNewECGMeasurementVersion()
            print("要传给flutter的isNewECGMeasurementVersion\("")")
            
        }
        else if call.method == "queryLastMeasureECGData" {
            //查询上次⼼电数据
            CRPSmartBandSDK.sharedInstance.getLastMeasureECGData()
        }
        else if call.method == "sendECGHeartRate" {
            //设置⼼电测量期间⼼率,⽤测量所得到的数据，通过⼼电算法库计算出瞬时⼼率，发送⾄⼿环。
            print("接收到的heartRate\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendECGHeartRate(heartRate: 0)
        }
        else if call.method == "setECGChangeListener" {
            //
            print("接收到的ecgMeasureType\(receivedDic)")
        }
        //MARK: - 语言 -
        else if call.method == "sendDeviceVersion" {
            //设置⼿环当前语⾔版本,⼿环语⾔版本分中⽂版和国际版，中⽂版只显示中⽂，国际版才能切换外语
            CRPSmartBandSDK.sharedInstance.setLanguageVersion(true)
        }
        else if call.method == "queryDeviceVersion" {
            //获取手表版本
            
        }
        else if call.method == "sendDeviceLanguage" {
            //设置⼿环语⾔
            print("接收到的language\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setLanguage(receivedDic["language"] as! Int)
        }
        else if call.method == "queryDeviceLanguage" {
            //获取当前⼿环语⾔
            CRPSmartBandSDK.sharedInstance.getLanguage { language, error in
                print("要传给flutter的queryDeviceLanguage\(language as! Int)")
            } _: { languages, error in
                
            }
        }
        //MARK: - 通知 -
        else if call.method == "sendOtherMessageState" {
            //设置其它消息推送状态,开启或者关闭其它消息推送。
            print("接收到的messageState\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setNotification([.facebook,.gmail])
        }
        else if call.method == "queryOtherMessageState" {
            //查询其它消息推送状态,查询其它消息推送状态
            CRPSmartBandSDK.sharedInstance.getNotifications { datas, error in
                result("要传给Flutter的数据queryOtherMessageState")
            }
        }
        else if call.method == "sendMessage" {
            //向手表发送各类消息内容。
            print("接收到的messageInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setMessage("")
        }
        else if call.method == "sendCall0ffHook" {
            //当手表接收到手机类型的信息推送，手表将振动一个固定的时间。调用这个接口来停止手表手表接通或电话挂断时震动。
            
        }
        //MARK: - 久坐提醒 -
//        else if call.method == "" {
//            //开启或者关闭久坐提醒。
//            CRPSmartBandSDK.sharedInstance.setRemindersToMove(true)
//        }
        else if call.method == "sendSedentaryReminder" {
            //设置久坐提醒有效时间段
            print("接收到的sedentaryReminder\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setSitRemind(SitRemindModel())
        }
        else if call.method == "querySedentaryReminder" {
            //查询久坐提醒状态
            CRPSmartBandSDK.sharedInstance.getRemindersToMove { state, error in
                result("要传给Flutter的数据querySedentaryReminder")
            }
            //获取久坐提醒时间段
//            CRPSmartBandSDK.sharedInstance.getSitRemindInfo { data, error in
//                result("要传给Flutter的数据querySedentaryReminder")
//            }
        }

        else if call.method == "sendSedentaryReminderPeriod" {
            //设置久坐提醒有效时间段
            print("接收到的crpSedentaryReminderPeriodInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setSitRemind(SitRemindModel())
        }
        else if call.method == "querySedentaryReminderPeriod" {
            //获取久坐提醒时间段
            CRPSmartBandSDK.sharedInstance.getSitRemindInfo { data, error in
                result("要传给Flutter的数据querySedentaryReminderPeriod")
            }
        }
        //MARK: - 找寻设备 -
        else if call.method == "findDevice" {
            //查找⼿环，⼿环收到此指令以后会震动⼏秒。
            CRPSmartBandSDK.sharedInstance.setFindDevice()
        }
        //MARK: - 关机 -
        else if call.method == "shutDown" {
            //⼿环关机
            CRPSmartBandSDK.sharedInstance.shutDown()
        }
        //MARK: - 勿扰时段 -
        else if call.method == "sendDoNotDisturbTime" {
            //设置勿扰时段,⼿环⽀持勿扰时段，勿扰时段内不显示消息推送
            print("接收到的crpPeriodTimeInfo\(receivedDic)")
            let dic = SystemAuth.getDictionaryFromJSONString(jsonString: receivedDic["crpPeriodTimeInfo"] as! String)
            let model = periodTimeModel(startHour: dic["startHour"] as! Int, startMin: dic["startMinute"] as! Int, endHour: dic["endHour"] as! Int, endMin: dic["endMinute"] as! Int)
            
            CRPSmartBandSDK.sharedInstance.setDisturbTime(model)
        }
        else if call.method == "queryDoNotDisturbTime" {
            //查询⼿环设置的勿扰时段
            CRPSmartBandSDK.sharedInstance.getDisturbTime { model, error in
                var param: [String: Any] = [:]
                param["startHour"] = model.startHour
                param["startMinute"] = model.startMin
                param["endHour"] = model.endHour
                param["endMinute"] = model.endMin
                let jsonData = try! JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                let str = String(data: jsonData, encoding: String.Encoding.utf8)!
                result(str)
                result("要传给Flutter的数据queryDoNotDisturbTime")
            }
        }
        //MARK: - 呼吸灯 -
        else if call.method == "sendBreathingLight" {
            //设置呼吸灯,一些手表支持呼吸灯，并打开或关闭呼吸灯。
            print("接收到的breathingLight\(receivedDic)")
        }
        else if call.method == "queryBreathingLight" {
            //获取呼吸灯的状态
            result("要传给Flutter的数据queryBreathingLight")
        }
        //MARK: - 生理周期 -
        else if call.method == "sendPhysiologcalPeriod" {
            //设置⽣理周期提醒
            print("接收到的futureWeatherInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setPhysiological(Physiological())
        }
        else if call.method == "queryPhysiologcalPeriod" {
            //查询⽣理周期提醒
            CRPSmartBandSDK.sharedInstance.getPhysiological { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 查找手机 -
        else if call.method == "startFindPhone" {
            //开始找寻手机
            CRPSmartBandSDK.sharedInstance.sendFindingPhone()
        }
        else if call.method == "stopFindPhone" {
            //结束找寻手机
            CRPSmartBandSDK.sharedInstance.stopFindPhone()
        }
        //MARK: - 播放器 -
        else if call.method == "setMusicPlayerState" {
            //设置播放器状态
            print("接收到的CRPMusicPlayerStateType\(receivedDic)")
        }
        else if call.method == "sendSongTitle" {
            //设置歌的标题
            print("接收到的title\(receivedDic)")
        }
        else if call.method == "sendLyrics" {
            //设置歌词
            print("接收到的lyrics\(receivedDic)")
        }
        else if call.method == "closeMusicControl" {
            //关闭音乐控制
            
        }
        else if call.method == "sendMaxVolume" {
            //设置最大音量
            print("接收到的volume\(receivedDic)")
        }
        else if call.method == "sendCurrentVolume" {
            //设置当前音量
            print("接收到的volume\(receivedDic)")
        }
        //MARK: - 喝水提醒 -
        else if call.method == "enableDrinkWaterReminder" {
            //设置喝⽔提醒数据
            print("接收到的drinkWaterPeriodInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(drinkWaterRemind())
        }
        else if call.method == "disableDrinkWaterReminder" {
            //设置喝⽔提醒数据
            CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(drinkWaterRemind())
        }
        else if call.method == "queryDrinkWaterReminderPeriod" {
            //获取喝⽔提醒数据
            CRPSmartBandSDK.sharedInstance.getDrinkWaterRemind { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 心率预警 -
        else if call.method == "setMaxHeartRate" {
            //设置⼼率预警值
            print("接收到的heartRate和enable\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendHeartRateRemind(hrRemind())
        }
        else if call.method == "queryMaxHeartRate" {
            //获取⼼率预警值
            CRPSmartBandSDK.sharedInstance.getHeartRateRemind { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 锻炼 -
        else if call.method == "startMovement" {
            //开启锻炼
            
        }
        else if call.method == "setMovementState" {
            //设置锻炼状态
            
        }
        else if call.method == "connTainStateEveStm" {
            //监控锻炼状态
            
        }
        //MARK: - 协议版本 -
        else if call.method == "getProtocolVersion" {
            //获取协议版本
            result("要传给Flutter的数据")
        }
        //MARK: - 温度 -
        else if call.method == "startMeasureTemp" {
            //开始单次体温测量
            CRPSmartBandSDK.sharedInstance.sendSingleTemperatureStart()
        }
        else if call.method == "stopMeasureTemp" {
            //结束单次体温测量
            CRPSmartBandSDK.sharedInstance.sendSingleTemperatureEnd()
        }
        else if call.method == "enableTimingMeasureTemp" {
            //开启定时温度测量
            CRPSmartBandSDK.sharedInstance.sendAutoTemperature(true)
        }
        else if call.method == "disableTimingMeasureTemp" {
            //禁用定时温度测量
            CRPSmartBandSDK.sharedInstance.sendAutoTemperature(false)
        }
        else if call.method == "queryTimingMeasureTempState" {
            //获取⾃动体温测量开关
            CRPSmartBandSDK.sharedInstance.getAutoTemperatureState { data, error in
                //1：开启；0：关闭
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryTimingMeasureTemp" {
            //获取⾃动体温测量数据,每半⼩时⼀个数据
            print("接收到的tempTimeType\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.getAutoTemperatureData { datas, error in
                
            } _: { datas, error in
                
            }
        }
        //MARK: - 显示的时间
        else if call.method == "sendDisplayTime" {
            //设置亮屏时间
            print("接收到的time\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendAutoLockTime(1)
        }
        else if call.method == "queryDisplayTime" {
            //获取亮屏时间
            CRPSmartBandSDK.sharedInstance.getAutoLockTime { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 洗手提醒 -
        else if call.method == "enableHandWashingReminder" {
            //开启洗⼿提醒
            print("接收到的handWashingPeriodInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.sendHandWashRemind(eventRemind())
        }
        else if call.method == "disableHandWashingReminder" {
            //禁用洗手提醒
            CRPSmartBandSDK.sharedInstance.sendHandWashRemind(eventRemind())
        }
        else if call.method == "queryHandWashingReminderPeriod" {
            //获取洗⼿提醒数据
            CRPSmartBandSDK.sharedInstance.getHandWashRemind { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 温度 -
        else if call.method == "sendTempUnit" {
            //切换手环的温度系统。
            print("接收到的temp\(receivedDic)")
        }
        else if call.method == "queryTempUnit" {
            //查询系统温度
            
        }
        //MARK: - 亮度 -
        else if call.method == "sendBrightness" {
            //设置亮度
            print("接收到的brightness\(receivedDic)")
        }
        else if call.method == "queryBrightness" {
            //设置亮度
            result("要传给Flutter的数据")
        }
        //MARK: - 蓝牙地址 -
        else if call.method == "queryBtAddress" {
            //获取经典的蓝牙地址
            result("要传给Flutter的数据")
        }
        //MARK: - 联系人 -
        else if call.method == "checkSupportQuickContact" {
            //获取联系⼈配置项
            CRPSmartBandSDK.sharedInstance.getContactProfile { model, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryContactCount" {
            //获取当前联系⼈个数
            CRPSmartBandSDK.sharedInstance.getContactCount { data, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendContact" {
            //设置联系⼈
            print("接收到的contactBean\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setContact(profile: contactProfileModel(), contacts: [CRPContact()])
        }
        else if call.method == "deleteContact" {
            //删除联系人
            print("接收到的id\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.deleteContact(contactID: 0)
        }
        //MARK: - 省电模式 -
        else if call.method == "sendBatterySaving" {
            //设置省电状态
            print("接收到的enable\(receivedDic)")
            let enable = receivedDic["enable"] as! Bool
            CRPSmartBandSDK.sharedInstance.setPowerSaveState(open: enable)
        }
        else if call.method == "queryBatterySaving" {
            //获取省电状态
            CRPSmartBandSDK.sharedInstance.getPowerSaveState { data, error in
                result(Bool(truncating: data as NSNumber))
            }
        }
        //MARK: - 吃药提醒 -
        else if call.method == "queryPillReminder" {
            //获取当前吃药提醒信息,通过receiveMedicineInfo⽅法返回数据
            CRPSmartBandSDK.sharedInstance.getMedicineInfo()
        }
        else if call.method == "sendPillReminder" {
            //设置吃药提醒
            print("接收到的pillReminderInfo\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setMedicine(medicine: CRPMedicineReminderModel())
        }
        else if call.method == "deletePillReminder" {
            //删除指定id的吃药提醒
            print("接收到的id\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.deleteMedicine(id: 0)
        }
        else if call.method == "clearPillReminder" {
            //删除所有吃药提醒设置
            CRPSmartBandSDK.sharedInstance.deleteAllMedicine()
        }
        //MARK: - 唤醒 -
        else if call.method == "sendTapToWakeState" {
            //设置屏幕轻触唤醒
            print("接收到的enable\(receivedDic)")
            CRPSmartBandSDK.sharedInstance.setTapToWake(open: true)
        }
        else if call.method == "queryTapToWakeState" {
            //获取屏幕轻触唤醒设置(0: 关闭，1: 开启)
            CRPSmartBandSDK.sharedInstance.readTapToWake { data, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryHistoryTraining" {
            //查询历史锻炼
            
        }
        else if call.method == "queryTraining" {
            //查询锻炼细节
            print("接收到的id\(receivedDic)")
            
        }
        //MARK: - 睡眠 -
        else if call.method == "syncSleep" {
            //同步睡眠
            
        }
        else if call.method == "syncRemSleep" {
            //同步rem睡眠
            
        }
        else if call.method == "syncPastSleep" {
            //同步过去的睡眠
            //会传<String, int>{"pastTimeType": pastTimeType}过来
            print("接收到的pastTimeType\(receivedDic)")
        }
        
    }
}

