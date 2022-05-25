import 'dart:convert';

import 'dart:typed_data';

StepChange stepChangeFromJson(String str) => StepChange.fromJson(json.decode(str));
String stepChangeToJson(StepChange data) => json.encode(data.toJson());
class StepChange {
  StepChange({
    required this.calories,
    required this.distance,
    required this.steps,
    required this.time,
  });

  int calories;
  int distance;
  int steps;
  int time;

  factory StepChange.fromJson(Map<String, dynamic> json) => StepChange(
    calories: json["calories"],
    distance: json["distance"],
    steps: json["steps"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "calories": calories,
    "distance": distance,
    "steps": steps,
    "time": time,
  };
}

BleScanBean bleScanBeanFromJson(String str) => BleScanBean.fromJson(json.decode(str));
String bleScanEventToJson(BleScanBean data) => json.encode(data.toJson());
class BleScanBean {
  BleScanBean({
    required this.isCompleted,
    required this.address,
    required this.mRssi,
    required this.mScanRecord,
    required this.name,
  });

  bool isCompleted;
  String address;
  int mRssi;
  List<int> mScanRecord;
  String name;

  factory BleScanBean.fromJson(Map<String, dynamic> json) => BleScanBean(
    isCompleted: json["isCompleted"],
    address: json["address"],
    mRssi: json["mRssi"],
    mScanRecord: List<int>.from(json["mScanRecord"].map((x) => x)),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "isCompleted": isCompleted,
    "address": address,
    "mRssi": mRssi,
    "mScanRecord": List<dynamic>.from(mScanRecord.map((x) => x)),
    "name": name,
  };
}

CheckOtaBean checkOtaBeanFromJson(String str) => CheckOtaBean.fromJson(json.decode(str));

String checkOtaBeanToJson(CheckOtaBean data) => json.encode(data.toJson());

class CheckOtaBean {
  CheckOtaBean({
     required this.firmwareVersionInfo,
     required this.isLatestVersion,
  });

  FirmwareVersionBean firmwareVersionInfo;
  String isLatestVersion;

  factory CheckOtaBean.fromJson(Map<String, dynamic> json) => CheckOtaBean(
    firmwareVersionInfo: FirmwareVersionBean.fromJson(json["firmwareVersionInfo"]),
    isLatestVersion: json["isLatestVersion"],
  );

  Map<String, dynamic> toJson() => {
    "firmwareVersionInfo": firmwareVersionInfo.toJson(),
    "isLatestVersion": isLatestVersion,
  };
}


FirmwareVersionBean firmwareVersionInfoFromJson(String str) => FirmwareVersionBean.fromJson(json.decode(str));
String firmwareVersionInfoToJson(FirmwareVersionBean data) => json.encode(data.toJson());
class FirmwareVersionBean {
  FirmwareVersionBean({
    required this.changeNotes,
    required this.changeNotesEn,
    required this.mcu,
    required this.tpUpgrade,
    required this.type,
    required this.version,
  });

  String changeNotes;
  String changeNotesEn;
  int mcu;
  bool tpUpgrade;
  int type;
  String version;

  factory FirmwareVersionBean.fromJson(Map<String, dynamic> json) => FirmwareVersionBean(
    changeNotes: json["changeNotes"],
    changeNotesEn: json["changeNotesEn"],
    mcu: json["mcu"],
    tpUpgrade: json["tpUpgrade"],
    type: json["type"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "changeNotes": changeNotes,
    "changeNotesEn": changeNotesEn,
    "mcu": mcu,
    "tpUpgrade": tpUpgrade,
    "type": type,
    "version": version,
  };
}

UserBean userBeanFromJson(String str) =>
    UserBean.fromJson(json.decode(str));
String userBeanToJson(UserBean data) => json.encode(data.toJson());
class UserBean {
  static const int male = 0;
  static const int female = 1;

  UserBean({
    required this.weight,
    required this.height,
    required this.gender,
    required this.age,
  });

  int weight;
  int height;
  int gender;
  int age;

  factory UserBean.fromJson(Map<String, dynamic> json) => UserBean(
        weight: json["weight"],
        height: json["height"],
        gender: json["gender"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "weight": weight,
        "height": height,
        "gender": gender,
        "age": age,
      };
}

TodayWeatherBean todayWeatherBeanFromJson(String str) =>
    TodayWeatherBean.fromJson(json.decode(str));
String todayWeatherBeanToJson(TodayWeatherBean data) =>
    json.encode(data.toJson());
class TodayWeatherBean {
  TodayWeatherBean({
    required this.city,
    required this.lunar,
    required this.festival,
    required this.pm25,
    required this.temp,
    required this.weatherId,
  });

  String city;
  String lunar;
  String festival;
  int pm25;
  int temp;
  int weatherId;

  factory TodayWeatherBean.fromJson(Map<String, dynamic> json) =>
      TodayWeatherBean(
        city: json["city"],
        lunar: json["lunar"],
        festival: json["festival"],
        pm25: json["pm25"],
        temp: json["temp"],
        weatherId: json["weatherId"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "lunar": lunar,
        "festival": festival,
        "pm25": pm25,
        "temp": temp,
        "weatherId": weatherId,
      };
}

//余诗霞补充
StepsCategoryBean stepsCategoryBeanFromJson(String str) => StepsCategoryBean.fromJson(json.decode(str));
String stepsCategoryBeanToJson(StepsCategoryBean data) => json.encode(data.toJson());
class StepsCategoryBean {
  StepsCategoryBean({
    required this.dateType,
    required this.timeInterval,
    required this.stepsList,
  });

  int dateType;
  int timeInterval;
  List<int> stepsList;

  factory StepsCategoryBean.fromJson(Map<String, dynamic> json) => StepsCategoryBean(
    dateType: json["dateType"],
    timeInterval: json["timeInterval"],
    stepsList: List<int>.from(json["stepsList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "dateType": dateType,
    "timeInterval": timeInterval,
    "stepsList": List<dynamic>.from(stepsList.map((x) => x)),
  };
}

//睡眠
SleepBean sleepBeanFromJson(String str) => SleepBean.fromJson(json.decode(str));
String sleepBeanToJson(SleepBean data) => json.encode(data.toJson());
class SleepBean {
  SleepBean({
    required this.sleepInfo,
    required this.past,
    required this.pastSleepInfo,
  });

  SleepInfo sleepInfo;
  int past;
  SleepInfo pastSleepInfo;

  factory SleepBean.fromJson(Map<String, dynamic> json) => SleepBean(
    sleepInfo: SleepInfo.fromJson(json["sleepInfo"]),
    past: json["past"],
    pastSleepInfo: SleepInfo.fromJson(json["pastSleepInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "sleepInfo": sleepInfo.toJson(),
    "past": past,
    "pastSleepInfo": pastSleepInfo.toJson(),
  };
}

SleepInfo sleepInfoFromJson(String str) => SleepInfo.fromJson(json.decode(str));
String sleepInfoToJson(SleepInfo data) => json.encode(data.toJson());
class SleepInfo {
  SleepInfo({
    required this.totalTime,
    required this.restfulTime,
    required this.lightTime,
    required this.soberTime,
    required this.remTime,
    // required this.details,
  });

  int totalTime;
  int restfulTime;
  int lightTime;
  int soberTime;
  int remTime;
  // List<DetailBean> details;

  static const int sleepStateRem = 3;
  static const int sleepStateRestful = 2;
  static const int sleepStateLight = 1;
  static const int sleepStateSober = 0;

  factory SleepInfo.fromJson(Map<String, dynamic> json) => SleepInfo(
    totalTime: json["totalTime"],
    restfulTime: json["restfulTime"],
    lightTime: json["lightTime"],
    soberTime: json["soberTime"],
    remTime: json["remTime"],
    // details: List<DetailBean>.from(json["details"].map((x) => DetailBean.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalTime": totalTime,
    "restfulTime": restfulTime,
    "lightTime": lightTime,
    "soberTime": soberTime,
    "remTime": remTime,
    // "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

DetailBean detailBeanFromJson(String str) => DetailBean.fromJson(json.decode(str));
String detailBeanToJson(DetailBean data) => json.encode(data.toJson());
class DetailBean {
  DetailBean({
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.type,
  });

  int startTime;
  int endTime;
  int totalTime;
  int type;

  factory DetailBean.fromJson(Map<String, dynamic> json) => DetailBean(
    startTime: json["startTime"],
    endTime: json["endTime"],
    totalTime: json["totalTime"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "endTime": endTime,
    "totalTime": totalTime,
    "type": type,
  };
}

//yushixia:start
PeriodTimeBean periodTimeBeanFromJson(String str) =>
    PeriodTimeBean.fromJson(json.decode(str));
String periodTimeBeanToJson(PeriodTimeBean data) =>
    json.encode(data.toJson());
class PeriodTimeBean {
  PeriodTimeBean({
    required this.endHour,
    required this.endMinute,
    required this.startHour,
    required this.startMinute,
  });

  int endHour;
  int endMinute;
  int startHour;
  int startMinute;

  factory PeriodTimeBean.fromJson(Map<String, dynamic> json) =>
      PeriodTimeBean(
        endHour: json["endHour"],
        endMinute: json["endMinute"],
        startHour: json["startHour"],
        startMinute: json["startMinute"],
      );

  Map<String, dynamic> toJson() => {
        "endHour": endHour,
        "endMinute": endMinute,
        "startHour": startHour,
        "startMinute": startMinute,
      };
}

WatchFaceLayoutBean watchFaceLayoutBeanFromJson(String str) =>
    WatchFaceLayoutBean.fromJson(json.decode(str));
String watchFaceLayoutBeanToJson(WatchFaceLayoutBean data) =>
    json.encode(data.toJson());
class WatchFaceLayoutBean {
  WatchFaceLayoutBean({
    required this.backgroundPictureMd5,
    required this.compressionType,
    required this.height,
    required this.textColor,
    required this.thumHeight,
    required this.thumWidth,
    required this.timeBottomContent,
    required this.timePosition,
    required this.timeTopContent,
    required this.width,
  });

  String backgroundPictureMd5;
  String compressionType;
  int height;
  int textColor;
  int thumHeight;
  int thumWidth;
  int timeBottomContent;
  int timePosition;
  int timeTopContent;
  int width;

  factory WatchFaceLayoutBean.fromJson(Map<String, dynamic> json) =>
      WatchFaceLayoutBean(
        backgroundPictureMd5: json["backgroundPictureMd5"],
        compressionType: json["compressionType"],
        height: json["height"],
        textColor: json["textColor"],
        thumHeight: json["thumHeight"],
        thumWidth: json["thumWidth"],
        timeBottomContent: json["timeBottomContent"],
        timePosition: json["timePosition"],
        timeTopContent: json["timeTopContent"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "backgroundPictureMd5": backgroundPictureMd5,
        "compressionType": compressionType,
        "height": height,
        "textColor": textColor,
        "thumHeight": thumHeight,
        "thumWidth": thumWidth,
        "timeBottomContent": timeBottomContent,
        "timePosition": timePosition,
        "timeTopContent": timeTopContent,
        "width": width,
      };
}

AlarmClockBean alarmClockBeanFromJson(String str) =>
    AlarmClockBean.fromJson(json.decode(str));
String alarmClockBeanToJson(AlarmClockBean data) =>
    json.encode(data.toJson());
class AlarmClockBean {
  AlarmClockBean({
    required this.enable,
    required this.hour,
    required this.id,
    required this.minute,
    required this.repeatMode,
  });

  bool enable;
  int hour;
  int id;
  int minute;
  int repeatMode;

  static const int firstClock = 0;
  static const int secondClock = 1;
  static const int thirdClock = 2;

  static const int single = 0;
  static const int sunday = 1;
  static const int monday = 2;
  static const int tuesday = 4;
  static const int wednesday = 8;
  static const int thursday = 16;
  static const int friday = 32;
  static const int saturday = 64;
  static const int everyday = 127;

  factory AlarmClockBean.fromJson(Map<String, dynamic> json) =>
      AlarmClockBean(
        enable: json["enable"],
        hour: json["hour"],
        id: json["id"],
        minute: json["minute"],
        repeatMode: json["repeatMode"],
      );

  Map<String, dynamic> toJson() => {
        "enable": enable,
        "hour": hour,
        "id": id,
        "minute": minute,
        "repeatMode": repeatMode,
      };
}

SupportWatchFaceBean supportWatchFaceBeanFromJson(String str) => SupportWatchFaceBean.fromJson(json.decode(str));
String supportWatchFaceBeanToJson(SupportWatchFaceBean data) => json.encode(data.toJson());
class SupportWatchFaceBean {
  SupportWatchFaceBean({
    required this.displayWatchFace,
    required this.supportWatchFaceList,
  });

  int displayWatchFace;
  List<int> supportWatchFaceList;

  factory SupportWatchFaceBean.fromJson(Map<String, dynamic> json) => SupportWatchFaceBean(
    displayWatchFace: json["displayWatchFace"],
    supportWatchFaceList: List<int>.from(json["supportWatchFaceList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "displayWatchFace": displayWatchFace,
    "supportWatchFaceList": List<dynamic>.from(supportWatchFaceList.map((x) => x)),
  };
}

WatchFaceStoreBean watchFaceStoreBeanFromJson(String str) => WatchFaceStoreBean.fromJson(json.decode(str));
String watchFaceStoreBeanToJson(WatchFaceStoreBean data) => json.encode(data.toJson());
class WatchFaceStoreBean {
  WatchFaceStoreBean({
    required this.watchFaceSupportList,
    required this.firmwareVersion,
    required this.pageCount,
    required this.pageIndex,
  });

  List<int> watchFaceSupportList;
  String firmwareVersion;
  int pageCount;
  int pageIndex;

  factory WatchFaceStoreBean.fromJson(Map<String, dynamic> json) => WatchFaceStoreBean(
    watchFaceSupportList: List<int>.from(json["list"].map((x) => x)),
    firmwareVersion: json["firmwareVersion"],
    pageCount: json["pageCount"],
    pageIndex: json["pageIndex"],
  );

  Map<String, dynamic> toJson() => {
    "watchFaceSupportList": List<dynamic>.from(watchFaceSupportList.map((x) => x)),
    "firmwareVersion": firmwareVersion,
    "pageCount": pageCount,
    "pageIndex": pageIndex,
  };
}

WatchFaceBean watchFaceBeanFromJson(String str) => WatchFaceBean.fromJson(json.decode(str));
String watchFaceBeanToJson(WatchFaceBean data) => json.encode(data.toJson());
class WatchFaceBean {
  WatchFaceBean({
    required this.id,
    required this.preview,
    required this.file,
  });

  int id;
  String preview;
  String file;

  factory WatchFaceBean.fromJson(Map<String, dynamic> json) => WatchFaceBean(
    id: json["id"],
    preview: json["preview"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preview": preview,
    "file": file,
  };
}

WatchFaceBackgroundBean watchFaceBackgroundBeanFromJson(String str) => WatchFaceBackgroundBean.fromJson(json.decode(str));
String watchFaceBackgroundBeanToJson(WatchFaceBackgroundBean data) => json.encode(data.toJson());
class WatchFaceBackgroundBean {
  WatchFaceBackgroundBean({
    required this.bitmap,
    required this.thumbBitmap,
    required this.type,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.width,
    required this.height,
    // required this.map5
  });

  Uint8List bitmap;
  Uint8List thumbBitmap;
  String type;
  int thumbWidth;
  int thumbHeight;
  int width;
  int height;
  static const int defaultTimeout = 30;
  static const int timeout = 30;

  factory WatchFaceBackgroundBean.fromJson(Map<String, dynamic> json) => WatchFaceBackgroundBean(
    bitmap: json["bitmap"],
    thumbBitmap: json["thumbBitmap"],
    type: json["type"],
      thumbWidth: json["thumbWidth"],
    thumbHeight: json["thumbHeight"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "bitmap": bitmap,
    "thumbBitmap": thumbBitmap,
    "type": type,
    "thumbWidth": thumbWidth,
    "thumbHeight": thumbHeight,
    "width": width,
    "height": height,
  };
}

CustomizeWatchFaceBean customizeWatchFaceBeanFromJson(String str) => CustomizeWatchFaceBean.fromJson(json.decode(str));
String customizeWatchFaceBeanToJson(CustomizeWatchFaceBean data) => json.encode(data.toJson());
class CustomizeWatchFaceBean {
  CustomizeWatchFaceBean({
    required this.index,
    required this.file,
  });

  int index;
  String file;

  factory CustomizeWatchFaceBean.fromJson(Map<String, dynamic> json) => CustomizeWatchFaceBean(
    index: json["index"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "index": index,
    "file": file,
  };
}


WatchFaceInfo watchFaceInfoFromJson(String str) => WatchFaceInfo.fromJson(json.decode(str));
String watchFaceInfoToJson(WatchFaceInfo data) => json.encode(data.toJson());
class WatchFaceInfo {
  WatchFaceInfo({
    required this.total,
    required this.prePage,
    required this.pageIndex,
    required this.list,
  });

  int total;
  int prePage;
  int pageIndex;
  List<WatchFaceBean> list;

  factory WatchFaceInfo.fromJson(Map<String, dynamic> json) => WatchFaceInfo(
    total: json["total"],
    prePage: json["prePage"],
    pageIndex: json["pageIndex"],
    list: List<WatchFaceBean>.from(json["list"].map((x) => WatchFaceBean.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "prePage": prePage,
    "pageIndex": pageIndex,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

StepChangeBean stepChangeBeanFromJson(String str) => StepChangeBean.fromJson(json.decode(str));
String stepChangeBeanToJson(StepChangeBean data) => json.encode(data.toJson());
class StepChangeBean {
  StepChangeBean({
    required this.stepInfo,
    required this.past,
    required this.pastStepInfo,
  });

  StepChange stepInfo;
  int past;
  StepChange pastStepInfo;

  factory StepChangeBean.fromJson(Map<String, dynamic> json) => StepChangeBean(
    stepInfo: StepChange.fromJson(json["stepInfo"]),
    past: json["past"],
    pastStepInfo: StepChange.fromJson(json["pastStepInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "stepInfo": stepInfo.toJson(),
    "past": past,
    "pastStepInfo": pastStepInfo.toJson(),
  };
}

//心率
HistoryHeartRateBean historyHeartRateBeanFromJson(String str) => HistoryHeartRateBean.fromJson(json.decode(str));
String historyHeartRateBeanToJson(HistoryHeartRateBean data) => json.encode(data.toJson());
class HistoryHeartRateBean {
  HistoryHeartRateBean({
    required this.date,
    required this.hr,
  });

  String date;
  int hr;

  factory HistoryHeartRateBean.fromJson(Map<String, dynamic> json) => HistoryHeartRateBean(
    date: json["date"],
    hr: json["hr"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "hr": hr,
  };
}

HeartRateInfo heartRateInfoFromJson(String str) => HeartRateInfo.fromJson(json.decode(str));
String heartRateInfoToJson(HeartRateInfo data) => json.encode(data.toJson());
class HeartRateInfo {
  HeartRateInfo({
    required this.startTime,
    required this.heartRateList,
    required this.timeInterval,
    required this.heartRateType,
  });

  int startTime;
  List<int> heartRateList;
  int timeInterval;
  String heartRateType;

  factory HeartRateInfo.fromJson(Map<String, dynamic> json) => HeartRateInfo(
    startTime: json["startTime"],
    heartRateList: List<int>.from(json["heartRateList"].map((x) => x)),
    timeInterval: json["timeInterval"],
    heartRateType: json["heartRateType"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "heartRateList": List<dynamic>.from(heartRateList.map((x) => x)),
    "timeInterval": timeInterval,
    "heartRateType": heartRateType,
  };
}

MovementHeartRateBean movementHeartRateBeanFromJson(String str) => MovementHeartRateBean.fromJson(json.decode(str));
String movementHeartRateBeanToJson(MovementHeartRateBean data) => json.encode(data.toJson());
class MovementHeartRateBean {
  MovementHeartRateBean({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.validTime,
    required this.steps,
    required this.distance,
    required this.calories,
  });

  int type;
  int startTime;
  int endTime;
  int validTime;
  int steps;
  int distance;
  int calories;

  factory MovementHeartRateBean.fromJson(Map<String, dynamic> json) => MovementHeartRateBean(
    type: json["type"],
    startTime: json["startTime"],
    endTime: json["endTime"],
    validTime: json["validTime"],
    steps: json["steps"],
    distance: json["distance"],
    calories: json["calories"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "startTime": startTime,
    "endTime": endTime,
    "validTime": validTime,
    "steps": steps,
    "distance": distance,
    "calories": calories,
  };
}

HeartRateBean heartRateBeanFromJson(String str) => HeartRateBean.fromJson(json.decode(str));
String heartRateBeanToJson(HeartRateBean data) => json.encode(data.toJson());
class HeartRateBean {
  HeartRateBean({
    required this.measuring,
    required this.onceMeasureComplete,
    required this.historyHrList,
    required this.historyDynamicRateType,
    required this.measureComplete,
    required this.hour24MeasureResult,
    required this.movementList,
  });

  int measuring;
  int onceMeasureComplete;
  List<HistoryHeartRateBean> historyHrList;
  String historyDynamicRateType;
  HeartRateInfo measureComplete;
  HeartRateInfo hour24MeasureResult;
  List<MovementHeartRateBean> movementList;

  factory HeartRateBean.fromJson(Map<String, dynamic> json) => HeartRateBean(
    measuring: json["measuring"],
    onceMeasureComplete: json["onceMeasureComplete"],
    historyHrList: List<HistoryHeartRateBean>.from(json["historyHRList"].map((x) => HistoryHeartRateBean.fromJson(x))),
    historyDynamicRateType: json["historyDynamicRateType"],
    measureComplete: HeartRateInfo.fromJson(json["measureComplete"]),
    hour24MeasureResult: HeartRateInfo.fromJson(json["hour24MeasureResult"]),
    movementList: List<MovementHeartRateBean>.from(json["movementList"].map((x) => MovementHeartRateBean.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "measuring": measuring,
    "onceMeasureComplete": onceMeasureComplete,
    "historyHRList": List<dynamic>.from(historyHrList.map((x) => x.toJson())),
    "historyDynamicRateType": historyDynamicRateType,
    "measureComplete": measureComplete.toJson(),
    "hour24MeasureResult": hour24MeasureResult.toJson(),
    "movementList": List<dynamic>.from(movementList.map((x) => x.toJson())),
  };
}

//血压
BloodPressureBean bloodPressureBeanFromJson(String str) => BloodPressureBean.fromJson(json.decode(str));
String bloodPressureBeanToJson(BloodPressureBean data) => json.encode(data.toJson());
class BloodPressureBean {
  BloodPressureBean({
    required this.continueState,
    required this.bloodPressureChange,
    required this.bloodPressureChange1,
    required this.historyBpList,
    required this.continueBp,
  });

  bool continueState;
  int bloodPressureChange;
  int bloodPressureChange1;
  List<HistoryBloodPressureBean> historyBpList;
  BloodPressureInfo continueBp;

  factory BloodPressureBean.fromJson(Map<String, dynamic> json) => BloodPressureBean(
    continueState: json["continueState"],
    bloodPressureChange: json["bloodPressureChange"],
    bloodPressureChange1: json["bloodPressureChange1"],
    historyBpList: List<HistoryBloodPressureBean>.from(json["historyBPList"].map((x) => HistoryBloodPressureBean.fromJson(x))),
    continueBp: BloodPressureInfo.fromJson(json["continueBP"]),
  );

  Map<String, dynamic> toJson() => {
    "continueState": continueState,
    "bloodPressureChange": bloodPressureChange,
    "bloodPressureChange1": bloodPressureChange1,
    "historyBPList": List<dynamic>.from(historyBpList.map((x) => x.toJson())),
    "continueBP": continueBp.toJson(),
  };
}

HistoryBloodPressureBean historyBloodPressureBeanFromJson(String str) => HistoryBloodPressureBean.fromJson(json.decode(str));
String historyBloodPressureBeanToJson(HistoryBloodPressureBean data) => json.encode(data.toJson());
class HistoryBloodPressureBean {
  HistoryBloodPressureBean({
    required this.date,
    required this.sbp,
    required this.dbp,
  });

  String date;
  int sbp;
  int dbp;

  factory HistoryBloodPressureBean.fromJson(Map<String, dynamic> json) => HistoryBloodPressureBean(
    date: json["date"],
    sbp: json["sbp"],
    dbp: json["dbp"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "sbp": sbp,
    "dbp": dbp,
  };
}

BloodPressureInfo bloodPressureInfoFromJson(String str) => BloodPressureInfo.fromJson(json.decode(str));
String bloodPressureInfoToJson(BloodPressureInfo data) => json.encode(data.toJson());
class BloodPressureInfo {
  BloodPressureInfo({
    required this.startTime,
    required this.timeInterval,
  });

  int startTime;
  int timeInterval;

  factory BloodPressureInfo.fromJson(Map<String, dynamic> json) => BloodPressureInfo(
    startTime: json["startTime"],
    timeInterval: json["timeInterval"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    "timeInterval": timeInterval,
  };
}

//血氧
BloodOxygenBean bloodOxygenBeanFromJson(String str) => BloodOxygenBean.fromJson(json.decode(str));
String bloodOxygenBeanToJson(BloodOxygenBean data) => json.encode(data.toJson());
class BloodOxygenBean {
  BloodOxygenBean({
    required this.continueState,
    required this.timingMeasure,
    required this.bloodOxygen,
    required this.historyList,
    required this.continueBo,
  });

  bool continueState;
  int timingMeasure;
  int bloodOxygen;
  List<HistoryBloodOxygenBean> historyList;
  BloodOxygenInfo continueBo;

  factory BloodOxygenBean.fromJson(Map<String, dynamic> json) => BloodOxygenBean(
    continueState: json["continueState"],
    timingMeasure: json["timingMeasure"],
    bloodOxygen: json["bloodOxygen"],
    historyList: List<HistoryBloodOxygenBean>.from(json["historyList"].map((x) => HistoryBloodOxygenBean.fromJson(x))),
    continueBo: BloodOxygenInfo.fromJson(json["continueBO"]),
  );

  Map<String, dynamic> toJson() => {
    "continueState": continueState,
    "timingMeasure": timingMeasure,
    "bloodOxygen": bloodOxygen,
    "historyList": List<dynamic>.from(historyList.map((x) => x.toJson())),
    "continueBO": continueBo.toJson(),
  };
}

HistoryBloodOxygenBean historyBloodOxygenBeanFromJson(String str) => HistoryBloodOxygenBean.fromJson(json.decode(str));
String historyBloodOxygenBeanToJson(HistoryBloodOxygenBean data) => json.encode(data.toJson());
class HistoryBloodOxygenBean {
  HistoryBloodOxygenBean({
    required this.date,
    required this.bo,
  });

  String date;
  int bo;

  factory HistoryBloodOxygenBean.fromJson(Map<String, dynamic> json) => HistoryBloodOxygenBean(
    date: json["date"],
    bo: json["bo"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "bo": bo,
  };
}

BloodOxygenInfo bloodOxygenInfoFromJson(String str) => BloodOxygenInfo.fromJson(json.decode(str));
String bloodOxygenInfoToJson(BloodOxygenInfo data) => json.encode(data.toJson());
class BloodOxygenInfo {
  BloodOxygenInfo({
    required this.startTime,
    // required this.type,
    // required this.list,
    required this.timeInterval,
  });

  int startTime;
  // String type;
  // List<int> list;
  int timeInterval;

  factory BloodOxygenInfo.fromJson(Map<String, dynamic> json) => BloodOxygenInfo(
    startTime: json["startTime"],
    // type: json["type"],
    // list: List<int>.from(json["list"].map((x) => x)),
    timeInterval: json["timeInterval"],
  );

  Map<String, dynamic> toJson() => {
    "startTime": startTime,
    // "type": type,
    // "list": List<dynamic>.from(list.map((x) => x)),
    "timeInterval": timeInterval,
  };
}

//egc
EgcBean egcBeanFromJson(String str) => EgcBean.fromJson(json.decode(str));
String egcBeanToJson(EgcBean data) => json.encode(data.toJson());
class EgcBean {
  EgcBean({
    required this.ints,
    required this.measureComplete,
    required this.date,
    required this.isCancel,
    required this.isFail,
  });

  List<int> ints;
  int measureComplete;
  String date;
  bool isCancel;
  bool isFail;

  factory EgcBean.fromJson(Map<String, dynamic> json) => EgcBean(
    ints: List<int>.from(json["ints"].map((x) => x)),
    measureComplete: json["measureComplete"],
    date: json["date"],
    isCancel: json["isCancel"],
    isFail: json["isFail"],
  );

  Map<String, dynamic> toJson() => {
    "ints": List<dynamic>.from(ints.map((x) => x)),
    "measureComplete": measureComplete,
    "date": date,
    "isCancel": isCancel,
    "isFail": isFail,
  };
}

//以下实体是李宝忠的
FileTransBean fileTransBeanFromJson(String str) =>
    FileTransBean.fromJson(json.decode(str));
String fileTransBeanToJson(FileTransBean data) => json.encode(data.toJson());
class FileTransBean {
  FileTransBean({
    required this.var1,
    required this.image,
    required this.var2,
  });

  int var1;
  String image;
  int var2;

  factory FileTransBean.fromJson(Map<String, dynamic> json) => FileTransBean(
        var1: json["var1"],
        image: json["image"],
        var2: json["var2"],
      );

  Map<String, dynamic> toJson() => {
        "var1": var1,
        "image": image,
        "var2": var2,
      };
}
//yushixia:end

//xulei:start
MessageBean messageBeanFromJson(String str) => MessageBean.fromJson(json.decode(str));
String messageBeanToJson(MessageBean data) => json.encode(data.toJson());
class MessageBean {
  MessageBean({
    required this.message,
    required this.type,
    required this.versionCode,
    required this.isHs,
    required this.isSmallScreen,
  });

  String message;
  int type;
  int versionCode;
  bool isHs;
  bool isSmallScreen;

  factory MessageBean.fromJson(Map<String, dynamic> json) => MessageBean(
    message: json["message"],
    type: json["type"],
    versionCode: json["versionCode"],
    isHs: json["isHs"],
    isSmallScreen: json["isSmallScreen"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "type": type,
    "versionCode": versionCode,
    "isHs": isHs,
    "isSmallScreen": isSmallScreen,
  };
}

SedentaryReminderPeriodBean sedentaryReminderPeriodBeanFromJson(String str) => SedentaryReminderPeriodBean.fromJson(json.decode(str));
String sedentaryReminderPeriodBeanToJson(SedentaryReminderPeriodBean data) => json.encode(data.toJson());
class SedentaryReminderPeriodBean {
  SedentaryReminderPeriodBean({
    required this.endHour,
    required this.period,
    required this.startHour,
    required this.steps,
  });

  int endHour;
  int period;
  int startHour;
  int steps;

  factory SedentaryReminderPeriodBean.fromJson(Map<String, dynamic> json) => SedentaryReminderPeriodBean(
    endHour: json["endHour"],
    period: json["period"],
    startHour: json["startHour"],
    steps: json["steps"],
  );

  Map<String, dynamic> toJson() => {
    "endHour": endHour,
    "period": period,
    "startHour": startHour,
    "steps": steps,
  };
}

//xulei:end

// libaozhong: start
PhysiologcalPeriodBean physiologcalPeriodBeanFromJson(String str) => PhysiologcalPeriodBean.fromJson(json.decode(str));
String physiologcalPeriodBeanToJson(PhysiologcalPeriodBean data) => json.encode(data.toJson());
class PhysiologcalPeriodBean {
  PhysiologcalPeriodBean({
    required this.physiologcalPeriod,
    required this.menstrualPeriod,
    required this.startDate,
    required this.menstrualReminder,
    required this.ovulationReminder,
    required this.ovulationDayReminder,
    required this.ovulationEndReminder,
    required this.reminderHour,
    required this.reminderMinute,
  });

  int physiologcalPeriod;
  int menstrualPeriod;
  int startDate;
  bool menstrualReminder;
  bool ovulationReminder;
  bool ovulationDayReminder;
  bool ovulationEndReminder;
  int reminderHour;
  int reminderMinute;

  factory PhysiologcalPeriodBean.fromJson(Map<String, dynamic> json) => PhysiologcalPeriodBean(
    physiologcalPeriod: json["physiologcalPeriod"],
    menstrualPeriod: json["menstrualPeriod"],
    startDate: json["startDate"],
    menstrualReminder: json["menstrualReminder"],
    ovulationReminder: json["ovulationReminder"],
    ovulationDayReminder: json["ovulationDayReminder"],
    ovulationEndReminder: json["ovulationEndReminder"],
    reminderHour: json["reminderHour"],
    reminderMinute: json["reminderMinute"],
  );

  Map<String, dynamic> toJson() => {
    "physiologcalPeriod": physiologcalPeriod,
    "menstrualPeriod": menstrualPeriod,
    "startDate": startDate,
    "menstrualReminder": menstrualReminder,
    "ovulationReminder": ovulationReminder,
    "ovulationDayReminder": ovulationDayReminder,
    "ovulationEndReminder": ovulationEndReminder,
    "reminderHour": reminderHour,
    "reminderMinute": reminderMinute,
  };
}

DrinkWaterPeriodBean drinkWaterPeriodBeanFromJson(String str) => DrinkWaterPeriodBean.fromJson(json.decode(str));
String drinkWaterPeriodBeanToJson(DrinkWaterPeriodBean data) => json.encode(data.toJson());
class DrinkWaterPeriodBean {
  DrinkWaterPeriodBean({
    required this.enable,
    required this.startHour,
    required this.startMinute,
    required this.count,
    required this.period,
    required this.currentCups,
  });

  bool enable;
  int startHour;
  int startMinute;
  int count;
  int period;
  int currentCups;

  factory DrinkWaterPeriodBean.fromJson(Map<String, dynamic> json) => DrinkWaterPeriodBean(
    enable: json["enable"],
    startHour: json["startHour"],
    startMinute: json["startMinute"],
    count: json["count"],
    period: json["period"],
    currentCups: json["currentCups"],
  );

  Map<String, dynamic> toJson() => {
    "enable": enable,
    "startHour": startHour,
    "startMinute": startMinute,
    "count": count,
    "period": period,
    "currentCups": currentCups,
  };
}

HandWashingPeriodBean handWashingPeriodBeanFromJson(String str) => HandWashingPeriodBean.fromJson(json.decode(str));
String handWashingPeriodBeanToJson(HandWashingPeriodBean data) => json.encode(data.toJson());
class HandWashingPeriodBean {
  HandWashingPeriodBean({
    required this.enable,
    required this.startHour,
    required this.startMinute,
    required this.count,
    required this.period,
  });

  bool enable;
  int startHour;
  int startMinute;
  int count;
  int period;

  factory HandWashingPeriodBean.fromJson(Map<String, dynamic> json) => HandWashingPeriodBean(
    enable: json["enable"],
    startHour: json["startHour"],
    startMinute: json["startMinute"],
    count: json["count"],
    period: json["period"],
  );

  Map<String, dynamic> toJson() => {
    "enable": enable,
    "startHour": startHour,
    "startMinute": startMinute,
    "count": count,
    "period": period,
  };
}

PillReminderBean pillReminderBeanFromJson(String str) => PillReminderBean.fromJson(json.decode(str));
String pillReminderBeanToJson(PillReminderBean data) => json.encode(data.toJson());
class PillReminderBean {
  PillReminderBean({
    required this.id,
    required this.dateOffset,
    required this.name,
    required this.repeat,
    required this.reminderTimeList,
  });

  int id;
  int dateOffset;
  String name;
  int repeat;
  List<dynamic> reminderTimeList;

  factory PillReminderBean.fromJson(Map<String, dynamic> json) => PillReminderBean(
    id: json["id"],
    dateOffset: json["dateOffset"],
    name: json["name"],
    repeat: json["repeat"],
    reminderTimeList: List<dynamic>.from(json["reminderTimeList"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "dateOffset": dateOffset,
    "name": name,
    "repeat": repeat,
    "reminderTimeList": List<dynamic>.from(reminderTimeList.map((x) => x)),
  };
}

ContactBean contactBeanFromJson(String str) => ContactBean.fromJson(json.decode(str));
String contactBeanToJson(ContactBean data) => json.encode(data.toJson());
class ContactBean {
  ContactBean({
    required this.id,
    required this.width,
    required this.height,
    required this.address,
    required this.name,
    required this.number,
    required this.avatar,
    required this.timeout,
  });

  int id;
  int width;
  int height;
  int address;
  String name;
  String number;
  Uint8List? avatar;
  int timeout;

  factory ContactBean.fromJson(Map<String, dynamic> json) => ContactBean(
    id: json["id"],
    width: json["width"],
    height: json["height"],
    address: json["address"],
    name: json["name"],
    number: json["number"],
    avatar: json["avatar"],
    timeout: json["timeout"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "width": width,
    "height": height,
    "address": address,
    "name": name,
    "number": number,
    "avatar": avatar,
    "timeout": timeout,
  };
}


// libaozhong: end

//许蕾补充

DeviceLanguageBean deviceLanguageBeanFromJson(String str) => DeviceLanguageBean.fromJson(json.decode(str));

String deviceLanguageBeanToJson(DeviceLanguageBean data) => json.encode(data.toJson());

class DeviceLanguageBean {
  DeviceLanguageBean({
    required this.languageType,
    required this.type,
  });

  List<int> languageType;
  int type;

  factory DeviceLanguageBean.fromJson(Map<String, dynamic> json) => DeviceLanguageBean(
    languageType: List<int>.from(json["languageType"].map((x) => x)),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "languageType": List<dynamic>.from(languageType.map((x) => x)),
    "type": type,
  };
}

PeriodTimeResultBean periodTimeResultBeanFromJson(String str) => PeriodTimeResultBean.fromJson(json.decode(str));

String periodTimeResultBeanToJson(PeriodTimeResultBean data) => json.encode(data.toJson());

class PeriodTimeResultBean {
  PeriodTimeResultBean({
    required this.periodTimeType,
    required this.periodTimeInfo,
  });

  int periodTimeType;
  PeriodTimeInfo periodTimeInfo;

  factory PeriodTimeResultBean.fromJson(Map<String, dynamic> json) => PeriodTimeResultBean(
    periodTimeType: json["periodTimeType"],
    periodTimeInfo: PeriodTimeInfo.fromJson(json["periodTimeInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "periodTimeType": periodTimeType,
    "periodTimeInfo": periodTimeInfo.toJson(),
  };
}

class PeriodTimeInfo {
  PeriodTimeInfo({
    required this.endHour,
    required this.endMinute,
    required this.startHour,
    required this.startMinute,
  });

  int endHour;
  int endMinute;
  int startHour;
  int startMinute;

  factory PeriodTimeInfo.fromJson(Map<String, dynamic> json) => PeriodTimeInfo(
    endHour: json["endHour"],
    endMinute: json["endMinute"],
    startHour: json["startHour"],
    startMinute: json["startMinute"],
  );

  Map<String, dynamic> toJson() => {
    "endHour": endHour,
    "endMinute": endMinute,
    "startHour": startHour,
    "startMinute": startMinute,
  };
}

BrightnessBean brightnessBeanFromJson(String str) => BrightnessBean.fromJson(json.decode(str));

String brightnessBeanToJson(BrightnessBean data) => json.encode(data.toJson());

class BrightnessBean {
  BrightnessBean({
    required this.current,
    required this.max,
  });

  int current;
  int max;

  factory BrightnessBean.fromJson(Map<String, dynamic> json) => BrightnessBean(
    current: json["current"],
    max: json["max"],
  );

  Map<String, dynamic> toJson() => {
    "current": current,
    "max": max,
  };
}

MaxHeartRateBean maxHeartRateBeanFromJson(String str) => MaxHeartRateBean.fromJson(json.decode(str));

String maxHeartRateBeanToJson(MaxHeartRateBean data) => json.encode(data.toJson());

class MaxHeartRateBean {
  MaxHeartRateBean({
    required this.heartRate,
    required this.enable,
  });

  int heartRate;
  bool enable;

  factory MaxHeartRateBean.fromJson(Map<String, dynamic> json) => MaxHeartRateBean(
    heartRate: json["heartRate"],
    enable: json["enable"],
  );

  Map<String, dynamic> toJson() => {
    "heartRate": heartRate,
    "enable": enable,
  };
}

WatchFaceIdBean watchFaceIdBeanFromJson(String str) => WatchFaceIdBean.fromJson(json.decode(str));

String watchFaceIdBeanToJson(WatchFaceIdBean data) => json.encode(data.toJson());

class WatchFaceIdBean {
  WatchFaceIdBean({
    required this.watchFace,
    required this.error,
    required this.code,
  });

  WatchFace watchFace;
  String? error;
  int code;

  factory WatchFaceIdBean.fromJson(Map<String, dynamic> json) => WatchFaceIdBean(
    watchFace: WatchFace.fromJson(json["watchFace"]),
    error: json["error"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "watchFace": watchFace.toJson(),
    "error": error,
    "code": code,
  };
}

class WatchFace {
  WatchFace({
    required this.id,
    required this.preview,
    required this.file,
  });

  int? id;
  String? preview;
  String? file;

  factory WatchFace.fromJson(Map<String, dynamic> json) => WatchFace(
    id: json["id"],
    preview: json["preview"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preview": preview,
    "file": file,
  };
}



WatchFaceStoreListBean watchFaceStoreListBeanFromJson(String str) => WatchFaceStoreListBean.fromJson(json.decode(str));

String watchFaceStoreListBeanToJson(WatchFaceStoreListBean data) => json.encode(data.toJson());

class WatchFaceStoreListBean {
  WatchFaceStoreListBean({
   required this.watchFaceStore,
   required this.error,
  });

  WatchFaceStore watchFaceStore;
  String? error;

  factory WatchFaceStoreListBean.fromJson(Map<String, dynamic> json) => WatchFaceStoreListBean(
    watchFaceStore: WatchFaceStore.fromJson(json["watchFaceStore"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "watchFaceStore": watchFaceStore.toJson(),
    "error": error,
  };
}

class WatchFaceStore {
  WatchFaceStore({
    required this.total,
    required this.prePage,
    required this.pageIndex,
    required this.list,
  });

  int total;
  int prePage;
  int pageIndex;
  List<WatchFaceBean> list;

  factory WatchFaceStore.fromJson(Map<String, dynamic> json) => WatchFaceStore(
    total: json["total"],
    prePage: json["prePage"],
    pageIndex: json["pageIndex"],
    list: List<WatchFaceBean>.from(json["list"].map((x) => WatchFaceBean.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "prePage": prePage,
    "pageIndex": pageIndex,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListClass {
  ListClass({
    required this.id,
    required this.preview,
    required this.file,
  });

  int id;
  String preview;
  String file;

  factory ListClass.fromJson(Map<String, dynamic> json) => ListClass(
    id: json["id"],
    preview: json["preview"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "preview": preview,
    "file": file,
  };
}

WfFileTransLazyBean wfFileTransLazyBeanFromJson(String str) => WfFileTransLazyBean.fromJson(json.decode(str));

String wfFileTransLazyBeanToJson(WfFileTransLazyBean data) => json.encode(data.toJson());

class WfFileTransLazyBean {
  WfFileTransLazyBean({
    required this.progress,
    required this.error,
  });

  int progress;
  int error;

  factory WfFileTransLazyBean.fromJson(Map<String, dynamic> json) => WfFileTransLazyBean(
    progress: json["progress"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "progress": progress,
    "error": error,
  };
}


//补充结束