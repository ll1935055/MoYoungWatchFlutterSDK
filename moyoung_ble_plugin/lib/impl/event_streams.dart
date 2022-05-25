import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/impl/channel_names.dart';
import 'package:moyoung_ble_plugin/impl/moyoung_beans.dart';

class MYEventStreams {
  final Logger _logger = Logger();

  Stream<BleScanBean> get bleScanEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_BLE_SCAN)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.v(event.toString());

      return bleScanBeanFromJson(event.toString());
    });
  }

  Stream<int> get connStateEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_STATE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return event;
    });
  }

  Stream<StepChangeBean> get stepChangeEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_STEP_CHANGE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return stepChangeBeanFromJson(event.toString());
    });
  }
  //余诗霞补充
  Stream<Map<dynamic,dynamic>> get deviceBatteryEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_DEVICE_BATTERY)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return event;
    });
  }
  Stream<Map<dynamic,dynamic>> get weatherChangeEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_WEATHER_CHANGE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return event;
    });
  }
  Stream<StepsCategoryBean> get stepsCategoryEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_STEPS_CATEGORY)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return stepsCategoryBeanFromJson(event);
    });
  }
  Stream<SleepBean> get sleepChangeEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_SLEEP_CHANGE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return sleepBeanFromJson(event);
    });
  }

  Stream<Map<dynamic,dynamic>> get connFirmwareUpgradeEveStm {
    return const EventChannel(ChannelNames.LAZY_EVE_CHL_CONN_FIRMWARE_UPGRADE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());
      return event;
    });
  }

  Stream<HeartRateBean> get connHeartRateEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_HEART_RATE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connHeartRateEveStm:" + event.toString());

      return heartRateBeanFromJson(event);
    });
  }

  Stream<BloodPressureBean> get bloodPressureEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_BLOOD_PRESSURE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connBloodPressureEveStm:" + event.toString());

      return bloodPressureBeanFromJson(event);
    });
  }

  Stream<BloodOxygenBean> get connBloodOxygenEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_BLOOD_OXYGEN)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connBloodOxygenEveStm:" + event.toString());

      return bloodOxygenBeanFromJson(event);
    });
  }

  Stream<String> get cameraEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_CAMERA)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connCameraEveStm:" + event.toString());
      return event;
    });
  }

  Stream<int> get phoneEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_PHONE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connPhoneEveStm:" + event.toString());

      return event;
    });
  }

  Stream<int> get deviceRssiEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_DEVICE_RSSI)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connDeviceRssiEveStm:" + event.toString());

      return event;
    });
  }
  Stream<Map<dynamic, dynamic>> get connLazyFileTransEveStm {
    return const EventChannel(ChannelNames.LAZY_EVE_CHL_CONN_FILE_TRANS)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connLazyFileTransEveStm:" + event.toString());

      return event;
    });
  }
  Stream<WfFileTransLazyBean> get connLazyWFFileTransEveStm {
    return const EventChannel(ChannelNames.LAZY_EVE_CHL_CONN_WF_FILE_TRANS)
        .receiveBroadcastStream()
        .map((event) {
      _logger.d("connLazyWFFileTransEveStm:" + event.toString());

      return wfFileTransLazyBeanFromJson(event);
    });
  }
  Stream<EgcBean> get lazyEgcEveStm {
    return const EventChannel(ChannelNames.LAZY_EVE_CHL_CONN_EGC)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connLazyEgcEveStm:" + event.toString());

      return egcBeanFromJson(event);
    });
  }

//以下流是李宝忠的
  Stream<Map<dynamic, dynamic>> get lazyContactAvatarEveStm {
    return const EventChannel(ChannelNames.LAZY_EVE_CHL_CONN_CONTACT_AVATAR)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d("connLazyContactAvatarEveStm:" + event.toString());

      return event;
    });
  }

//余诗霞:end

  Stream<String> get connMovementStateEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_MOVEMENT_STATE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return event;
    });
  }

  Stream<String> get tempChangeEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_TEMP_CHANGE)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return event;
    });
  }

  Stream<Map<dynamic, dynamic>> get contactEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_CONTACT)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return event;
    });
  }

  Stream<bool> get batterySavingEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_BATTERY_SAVING)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return event;
    });
  }

  Stream<String> get trainingEveStm {
    return const EventChannel(ChannelNames.EVE_CHL_CONN_TRAIN)
        .receiveBroadcastStream()
        .map((dynamic event) {
      _logger.d(event.toString());

      return event;
    });
  }
}
