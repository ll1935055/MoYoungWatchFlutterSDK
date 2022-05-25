// ignore_for_file: non_constant_identifier_names

class TimeSystemType {
  static const int TIME_SYSTEM_12 = 0;
  static const int TIME_SYSTEM_24 = 1;
}

class WeatherId {
  // Todo
  static const int CLOUDY = 0;
  static const int FOGGY = 1;
  static const int OVERCAST = 2;
  static const int RAINY = 3;
  static const int SNOWY = 4;
  static const int SUNNY = 5;
  static const int SANDSTORM = 6;
  static const int HAZE = 7;
}

class PastTimeType {
  static const int YESTERDAY_STEPS = 1;
  static const int DAY_BEFORE_YESTERDAY_STEPS = 2;
  static const int YESTERDAY_SLEEP = 3;
  static const int DAY_BEFORE_YESTERDAY_SLEEP = 4;
}

class StepsCategoryDateType {
  static const int TODAY_STEPS_CATEGORY = 0;
  static const int YESTERDAY_STEPS_CATEGORY = 2;
}

class TempTimeType {
  static const String TODAY = "TODAY";
  static const String YESTERDAY = "YESTERDAY";
}

class MetricSystemType {
  static const int METRIC_SYSTEM = 0;
  static const int IMPERIAL_SYSTEM = 1;
}

class WatchFaceType {
  static const int FIRST_WATCH_FACE = 1;
  static const int SECOND_WATCH_FACE = 2;
  static const int THIRD_WATCH_FACE = 3;
  static const int NEW_CUSTOMIZE_WATCH_FACE = 4;
}

class WatchFaceLayoutType {
  static const String DEFAULT_WATCH_FACE_BG_MD5 =
      "00000000000000000000000000000000";
  static const int WATCH_FACE_TIME_TOP = 0;
  static const int WATCH_FACE_TIME_BOTTOM = 1;
  static const int WATCH_FACE_CONTENT_CLOSE = 0;
  static const int WATCH_FACE_CONTENT_DATE = 1;
  static const int WATCH_FACE_CONTENT_SLEEP = 2;
  static const int WATCH_FACE_CONTENT_HEART_RATE = 3;
  static const int WATCH_FACE_CONTENT_STEP = 4;
}

class TodayHeartRateType {
  static const int TIMING_MEASURE_HEART_RATE = 1;
  static const int ALL_DAY_HEART_RATE = 2;
}

class BloodOxygenTimeType {
  static const String TODAY = 'TODAY';
  static const String YESTERDAY = 'YESTERDAY';
}

class OTAType {
  static const int NORMAL_UPGEADE_TYPE = 0;
  static const int BETA_UPGRADE_TYPE = 1;
  static const int FORCED_UPDATE_TYPE = 2;
}

enum CompressionType {
  LZO,
  RGB_DEDUPLICATION,
  RGB_LINE,
  ORIGINAL,
}

class EcgMeasureType {
  static const String TYHX = "TYHX";
  static const String TI = "TI";
}

class HistoryDynamicRateType {
  static const String FIRST_HEART_RATE = "FIRST_HEART_RATE";
  static const String SECOND_HEART_RATE = "SECOND_HEART_RATE";
  static const String THIRD_HEART_RATE = "THIRD_HEART_RATE";
}

class ActionHeartRateType {
  static const String PART_HEART_RATE = "PART_HEART_RATE";
  static const String TODAY_HEART_RATE = "TODAY_HEART_RATE";
  static const String YESTERDAY_HEART_RATE = "YESTERDAY_HEART_RATE";
}

class DeviceVersionType {
  static const int CHINESE_EDITION = 0;
  static const int INTERNATIONAL_EDITION = 1;
}

class DeviceLanguageType {
  static const  int LANGUAGE_ENGLISH = 0;
  static const  int LANGUAGE_CHINESE = 1;
  static const  int LANGUAGE_JAPANESE = 2;
  static const  int LANGUAGE_KOREAN = 3;
  static const  int LANGUAGE_GERMAN = 4;
  static const  int LANGUAGE_FRENCH = 5;
  static const  int LANGUAGE_SPANISH = 6;
  static const  int LANGUAGE_ARABIC = 7;
  static const  int LANGUAGE_RUSSIAN = 8;
  static const  int LANGUAGE_TRADITIONAL = 9;
  static const  int LANGUAGE_UKRAINIAN = 10;
  static const  int LANGUAGE_ITALIAN = 11;
  static const  int LANGUAGE_PORTUGUESE = 12;
  static const  int LANGUAGE_DUTCH = 13;
  static const  int LANGUAGE_POLISH = 14;
  static const  int LANGUAGE_SWEDISH = 15;
  static const  int LANGUAGE_FINNISH = 16;
  static const  int LANGUAGE_DANISH = 17;
  static const  int LANGUAGE_NORWEGIAN = 18;
  static const  int LANGUAGE_HUNGARIAN = 19;
  static const  int LANGUAGE_CZECH = 20;
  static const  int LANGUAGE_BULGARIAN = 21;
  static const  int LANGUAGE_ROMANIAN = 22;
  static const  int LANGUAGE_SLOVAK_LANGUAGE = 23;
  static const  int LANGUAGE_LATVIAN = 24;
}

class BleMessageType {
 static const int MESSAGE_PHONE = 0;
 static const int MESSAGE_SMS = 1;
 static const int MESSAGE_WECHAT = 2;
 static const int MESSAGE_QQ = 3;
 static const int MESSAGE_FACEBOOK = 34;
 static const int MESSAGE_TWITTER = 35;
 static const int MESSAGE_WHATSAPP = 4;
 static const int MESSAGE_WECHAT_IN = 5;
 static const int MESSAGE_INSTAGREM = 6;
 static const int MESSAGE_SKYPE = 7;
 static const int MESSAGE_KAKAOTALK = 8;
 static const int MESSAGE_LINE = 9;
 static const int MESSAGE_OTHER = 128;
}

class MusicPlayerStateType {
static const int MUSIC_PLAYER_PAUSE = 0;
static const int MUSIC_PLAYER_PLAY = 1;
}

class MovementHeartRateStateType {
  static const int MOVEMENT_PAUSE = -2;
  static const int MOVEMENT_CONTINUE = -3;
  static const int MOVEMENT_COMPLETE = -1;
}

class TempUnit {
  static const int CELSIUS = 0;
  static const int FAHRENHEIT = 1;
}