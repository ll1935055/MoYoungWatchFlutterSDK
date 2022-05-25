//
//  MYDataInteractionManager.swift
//  moyoung_ble_plugin
//
//  Created by 魔样科技 on 2022/5/24.
//

import Foundation
import Flutter
import CRPSmartBand

class MYDataInteractionManager: NSObject {
    //监听
    var eventSink: FlutterEventSink?
    lazy var discoverys: [CRPDiscovery] = [CRPDiscovery]()
    
    
}

extension MYDataInteractionManager: FlutterPlugin, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        //方法的通道
        let scanChannel = FlutterMethodChannel(name: METHOD_CHL_BLE_SCAN, binaryMessenger: registrar.messenger())
        //创建类对象
        let instance = MYScanPlugin()
        //添加注册
        registrar.addMethodCallDelegate(instance, channel: scanChannel)
        
        let eventChannel = FlutterEventChannel(name: EVE_CHL_BLE_SCAN, binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var message: String?
        if let args = call.arguments as? Dictionary<String, Any?> {
            message = args["message"] as? String
        }
        print("flutter发送过来的是：\(call.method)")
        //MARK: - 扫描连接 -
        
        //开始扫描
        if call.method == "startScan" {
            NKSimpleAlertController.presentOnlyOKAlertVC(message: "Is scanning")
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
                    self.eventSink?(str)
                }
                
            } completionHandler: { (success, error) in
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
                self.eventSink?(str)
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
        else if call.method == "cancelScan" {
            //取消扫描
            CRPSmartBandSDK.sharedInstance.interruptScan()
        }
        else if call.method == "isConnected" {
            print("address:\(String(describing: message))")
        }
        else if call.method == "connect" {
            print("address:\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(jsonString: message)
//            for p in self.discoverys {
//                p.mac = dic["address"]
//                CRPSmartBandSDK.sharedInstance.connet(dic)
//                return
//            }
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
        else if call.method == "timeSystemType" {
            //设置时间制
            print("timeType:\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setTimeFormat(dic["timeSystemType"] as! Int)
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
                result(battery)
            }
        }
        else if call.method == "subscribeDeviceBattery" {
            //订阅手环电量
        }
        //MARK: - 固件升级 -
        else if call.method == "queryFirmwareVersion" {
            //查询固件版本
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
//            print("接收到的userinfo\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setProfile(dic["userInfo"])
        }
        else if call.method == "sendStepLength" {
            //设置步⻓
//            print("接收到的stepLength\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setStepLength(length: dic["stepLength"])
        }
        //MARK: - 天气 -
        else if call.method == "sendTodayWeather" {
            //设置今⽇天⽓
//            print("接收到的TodayWeather\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            let todayWeather:CRPSmartBand.weather = weather.init(type: dic["weatherId"], temp: dic["temp"], pm25: dic["pm25"], festival: dic["festival"], city: dic["city"])
//            CRPSmartBandSDK.sharedInstance.setWeather(todayWeather)
        }
        else if call.method == "sendFutureWeather" {
            //设置未来7⽇天⽓
//            print("接收到的FutureWeather\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            let todayWeather:CRPSmartBand.forecastWeather = forecastWeather.init(type: dic["weatherId"], maxTemp: dic["temp"], minTemp: dic["temp"])
//            CRPSmartBandSDK.sharedInstance.setForecastWeather([forecastWeather()])
        }
        else if call.method == "sendLocalCity" {
            //设置本地城市
//            print("接收到的LocalCity\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.sendCityName(dic["city"])
        }
        //MARK: - 体温 -
        else if call.method == "queryMetricSystem" {
            //获取体温单位
//            CRPSmartBandSDK.sharedInstance.getTemperatureUnit { temperature, error in
//                print("要传给Flutter的MetricSystem\(temperature)")
//                result(temperature)
//
//            }
        }
        else if call.method == "sendMetricSystem" {
            //设置体温单位
//            print("接收到的设置体温单位\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setTemperatureUnit(dic["metricSystemType"])
        }
        //MARK: - 翻腕亮屏 -
        else if call.method == "sendQuickView" {
            //设置翻腕亮屏状态
//            print("接收到的翻腕亮屏状态\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setQuickView(dic["quickViewState"])
        }
        else if call.method == "queryQuickView" {
            //查询⼿环翻腕亮屏开启状态,0: 关闭 1： 开启
//            CRPSmartBandSDK.sharedInstance.getQuickView { state, error in
//                print("要传给Flutter的⼿环翻腕亮屏开启状态\(state)")
//                result(state)
//            }
        }
        else if call.method == "sendQuickViewTime" {
            //设置翻腕亮屏时间
//            print("接收到的翻腕亮屏时间\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            let model = periodTimeModel.init(startHour: dic["periodTimeInfo"]["startHour"], startMin: dic["periodTimeInfo"]["startMinute"], endHour: dic["periodTimeInfo"]["endHour"], endMin: dic["periodTimeInfo"]["endMinute"])
//            CRPSmartBandSDK.sharedInstance.setQuickViewTime(model)
        }
        else if call.method == "queryQuickViewTime" {
            //获取翻腕亮屏时间
            CRPSmartBandSDK.sharedInstance.getQuickViewTime { model, error in
                print("要传给Flutter的翻腕亮屏时间\(model)")
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
        else if call.method == "sendGoalSteps" {
            //设置目标步数
//            print("接收到的目标步数\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setGoal(dic["goalSteps"])
        }
        else if call.method == "queryGoalStep" {
            //查询⽬标步数
            CRPSmartBandSDK.sharedInstance.getGoal { goal, error in
                print("要传给flutter的⽬标步数\(goal)")
                result(goal)
            }
        }
        //MARK: - 表盘 -
        else if call.method == "sendDisplayWatchFace" {
            //切换⼿环表盘
//            print("接收到的切换⼿环表盘\(String(describing: message))")
//            let dic = SystemAuth.getDictionaryFromJSONString(message)
//            CRPSmartBandSDK.sharedInstance.setDial(dic["watchFaceType"])
        }
        else if call.method == "queryDisplayWatchFace" {
            //查询⼿环正在使⽤的表盘序号
            CRPSmartBandSDK.sharedInstance.getDial { number, error in
                print("要传给flutter的battery\(number)")
                result(number)
            }
        }
        else if call.method == "queryWatchFaceLayout" {
            //获取指定表盘布局
            CRPSmartBandSDK.sharedInstance.getScreenContent { content, imageSize, i, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendWatchFaceLayout" {
            //修改⾃定义表盘布局
            CRPSmartBandSDK.sharedInstance.setupScreenContent(content: ScreenContent())
        }
        else if call.method == "querySupportWatchFace" {
            //获取⽀持摆盘类型
            CRPSmartBandSDK.sharedInstance.getWatchFaceSupportModel { model, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryWatchFaceStore" {
            //获取表盘市场,根据表盘的⽀持类型获取能可以更换的表盘列表(分⻚获取)
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfo([1,2], currentPage: 1, perPage: 18) { datas, currentPage, perPage, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "queryWatchFaceOfID" {
            //获取表盘ID的表盘信息
            CRPSmartBandSDK.sharedInstance.getWatchFaceInfoByID(0) { datas, currentPage, perPage, error in
                result("要传给Flutter的数据")
            }
        }
        
        //MARK: - 闹钟 -
        else if call.method == "sendAlarmClock" {
            //设置手环闹钟
            CRPSmartBandSDK.sharedInstance.setAlarm(AlarmModel())
        }
        else if call.method == "queryAllAlarmClock" {
            //查询所有闹钟
            CRPSmartBandSDK.sharedInstance.getAlarms { alarms, error in
                result(alarms)
            }
        }
        //MARK: - 心率 -
        else if call.method == "queryLastDynamicRate" {
            //查询上次动态⼼率测量结果,receiveHeartRateAll回调
            CRPSmartBandSDK.sharedInstance.getHeartData()
        }
        else if call.method == "enableTimingMeasureHeartRate" {
            //开始定时测量心率，正数为开启
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
            }
        }
        else if call.method == "queryTodayHeartRate" {
            //查询今天定时测量⼼率数据
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
            CRPSmartBandSDK.sharedInstance.getSportData {[weak self] sportModels, error in
                guard let self = self else { return }
                result(sportModels)
            }
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
            CRPSmartBandSDK.sharedInstance.getHeartRecordData { heartRecordData, error in
                result(heartRecordData)
            }
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
        }
        else if call.method == "queryLastMeasureECGData" {
            //查询上次⼼电数据
            CRPSmartBandSDK.sharedInstance.getLastMeasureECGData()
        }
        else if call.method == "sendECGHeartRate" {
            //设置⼼电测量期间⼼率,⽤测量所得到的数据，通过⼼电算法库计算出瞬时⼼率，发送⾄⼿环。
            CRPSmartBandSDK.sharedInstance.sendECGHeartRate(heartRate: 0)
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
            CRPSmartBandSDK.sharedInstance.setLanguage(0)
        }
        else if call.method == "queryDeviceLanguage" {
            //获取当前⼿环语⾔
            CRPSmartBandSDK.sharedInstance.getLanguage { language, error in
                
            } _: { languages, error in
                
            }
        }
        //MARK: - 通知 -
        else if call.method == "sendOtherMessageState" {
            //设置其它消息推送状态,开启或者关闭其它消息推送。
            CRPSmartBandSDK.sharedInstance.setNotification([.facebook,.gmail])
        }
        else if call.method == "queryOtherMessageState" {
            //查询其它消息推送状态,查询其它消息推送状态
            CRPSmartBandSDK.sharedInstance.getNotifications { datas, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendMessage" {
            //向手表发送各类消息内容。
            CRPSmartBandSDK.sharedInstance.setMessage("")
        }
        else if call.method == "sendCall0ffHook" {
            //当手表接收到手机类型的信息推送，手表将振动一个固定的时间。调用这个接口来停止手表手表接通或电话挂断时震动。
            
        }
        //MARK: - 久坐提醒 -
        else if call.method == "sendDeviceLanguage" {
            //开启或者关闭久坐提醒。
            CRPSmartBandSDK.sharedInstance.setRemindersToMove(true)
        }
        else if call.method == "querySedentaryReminder" {
            //查询久坐提醒状态
            CRPSmartBandSDK.sharedInstance.getRemindersToMove { state, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendSedentaryReminderPeriod" {
            //设置久坐提醒有效时间段
            CRPSmartBandSDK.sharedInstance.setSitRemind(SitRemindModel())
        }
        else if call.method == "querySedentaryReminderPeriod" {
            //获取久坐提醒时间段
            CRPSmartBandSDK.sharedInstance.getSitRemindInfo { data, error in
                result("要传给Flutter的数据")
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
        else if call.method == "sendDoNotDistrubTime" {
            //设置勿扰时段,⼿环⽀持勿扰时段，勿扰时段内不显示消息推送
            CRPSmartBandSDK.sharedInstance.setDisturbTime(periodTimeModel())
        }
        else if call.method == "queryDoNotDistrubTime" {
            //查询⼿环设置的勿扰时段
            CRPSmartBandSDK.sharedInstance.getDisturbTime { model, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 呼吸灯 -
        else if call.method == "sendBreathingLight" {
            //设置呼吸灯,一些手表支持呼吸灯，并打开或关闭呼吸灯。
            
        }
        else if call.method == "queryBreathingLight" {
            //获取呼吸灯的状态
            
        }
        //MARK: - 生理周期 -
        else if call.method == "sendPhysiologcalPeriod" {
            //设置⽣理周期提醒
            CRPSmartBandSDK.sharedInstance.setPhysiological(Physiological())
        }
        else if call.method == "queryPhysiologcalPeriod" {
            //查询⽣理周期提醒
            CRPSmartBandSDK.sharedInstance.getPhysiological { data, error in
                
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
            
        }
        else if call.method == "sendSongTitle" {
            //设置歌的标题
            
        }
        else if call.method == "sendLyrics" {
            //设置歌词
            
        }
        else if call.method == "closeMusicControl" {
            //关闭音乐控制
            
        }
        else if call.method == "sendMaxVolume" {
            //设置最大音量
            
        }
        else if call.method == "sendCurrentVolume" {
            //设置当前音量
            
        }
        //MARK: - 喝水提醒 -
        else if call.method == "enableDrinkWaterReminder" {
            //设置喝⽔提醒数据
            CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(drinkWaterRemind())
        }
        else if call.method == "disableDrinkWaterReminder" {
            //设置喝⽔提醒数据
            CRPSmartBandSDK.sharedInstance.sendDrinkWaterRemind(drinkWaterRemind())
        }
        else if call.method == "queryDrinkWaterReminderPeriod" {
            //获取喝⽔提醒数据
            CRPSmartBandSDK.sharedInstance.getDrinkWaterRemind { data, error in
                
            }
        }
        //MARK: - 心率预警 -
        else if call.method == "setMaxHeartRate" {
            //设置⼼率预警值
            CRPSmartBandSDK.sharedInstance.sendHeartRateRemind(hrRemind())
        }
        else if call.method == "queryMaxHeartRate" {
            //获取⼼率预警值
            CRPSmartBandSDK.sharedInstance.getHeartRateRemind { data, error in
                
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
            CRPSmartBandSDK.sharedInstance.getAutoTemperatureData { datas, error in
                
            } _: { datas, error in
                
            }
        }
        //MARK: - 显示的时间
        else if call.method == "sendDisplayTime" {
            //设置亮屏时间
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
        //MARK: -温度 -
        else if call.method == "sendTempUnit" {
            //切换手环的温度系统。
            
        }
        else if call.method == "queryTempUnit" {
            //查询系统温度
            
        }
        //MARK: - 蓝牙地址 -
        else if call.method == "queryBtAddress" {
            //获取经典的蓝牙地址
            
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
        else if call.method == "checkSupportQuickContact" {
            //获取联系⼈配置项
            CRPSmartBandSDK.sharedInstance.getContactProfile { model, error in
                result("要传给Flutter的数据")
            }
        }
        else if call.method == "sendContact" {
            //设置联系⼈
            CRPSmartBandSDK.sharedInstance.setContact(profile: contactProfileModel(), contacts: [CRPContact()])
        }
        else if call.method == "sendContactAvatar" {
            //设置联系人头像
            CRPSmartBandSDK.sharedInstance.setContact(profile: contactProfileModel(), contacts: [CRPContact()])
        }
        else if call.method == "deleteContact" {
            //删除联系人
            CRPSmartBandSDK.sharedInstance.deleteContact(contactID: 0)
        }
        else if call.method == "deleteContactAvatar" {
            //删除联系人头像
            CRPSmartBandSDK.sharedInstance.deleteContact(contactID: 0)
        }
        //MARK: - 省电模式 -
        else if call.method == "sendBatterySaving" {
            //设置省电状态
            CRPSmartBandSDK.sharedInstance.setPowerSaveState(open: true)
        }
        else if call.method == "queryBatterySaving" {
            //获取省电状态
            CRPSmartBandSDK.sharedInstance.getPowerSaveState { data, error in
                result("要传给Flutter的数据")
            }
        }
        //MARK: - 吃药提醒 -
        else if call.method == "queryPillReminder" {
            //获取当前吃药提醒信息,通过receiveMedicineInfo⽅法返回数据
            CRPSmartBandSDK.sharedInstance.getMedicineInfo()
        }
        else if call.method == "sendPillReminder" {
            //设置吃药提醒
            CRPSmartBandSDK.sharedInstance.setMedicine(medicine: CRPMedicineReminderModel())
        }
        else if call.method == "deletePillReminder" {
            //删除指定id的吃药提醒
            CRPSmartBandSDK.sharedInstance.deleteMedicine(id: 0)
        }
        else if call.method == "clearPillReminder" {
            //删除所有吃药提醒设置
            CRPSmartBandSDK.sharedInstance.deleteAllMedicine()
        }
        //MARK: - 唤醒 -
        else if call.method == "sendTapToWakeState" {
            //设置屏幕轻触唤醒
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
            
        }
        
    }
}
