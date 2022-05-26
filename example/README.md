Development guide

## 2 Usage

### **2.1 Environment configuration**

### 2.1 Initialization

MoYoungBle is the entrance of the SDK. The client needs to maintain the instance of MoYoungBle, and it needs to initialize the instance of MoYoungBle when using it.

```dart
final MoYoungBle _blePlugin = MoYoungBle();
```

### 2.2 Scan BLE device

1. **Start scan**

   When scanning Bluetooth devices, it will first obtain the open status of Bluetooth, and only when the  permission is allowed and the Bluetooth is turned on can start normal scanning. 

   Clicking the scan button will trigger the scan event listener stream bleScanEveStm, and the scan result will be returned through the bleScanEveStm listener stream and stored in the event as a BleScanEvent object.

   ```dart
   _blePlugin.startScan(10*1000).then((value) => {
        /// Do something with new state 
       }).onError((error, stackTrace) => {
       });
   ```
   
   Parameter Description :
   
   - The scan duration can be set in milliseconds. 
   - When the Bluetooth scan time is not set, the default scan time is 10 seconds
   - Since Bluetooth scanning is a time-consuming operation, it is recommended to set the scanning time to about 10 seconds.
   
   Add event stream listener.
   
   ```dart
   _blePlugin.bleScanEveStm.listen(
     (BleScanEvent event) async {
       /// Do something with new state 
     });
   ```
   
   Callback Description:
   
   BleScanEvent
   
   | callback value | callback value type | callback value description   |
   | -------------- | ------------------- | ---------------------------- |
   | isCompleted    | bool                | is completed                 |
   | address        | String              | Device address               |
   | mRssi          | int                 | equipment rssi               |
   | mScanRecord    | List<int>           | Bluetooth scan device record |
   | name           | String              | Equipment name               |


   2. **Cancel scan**

      Turn off the bluetooth scan, and the result listens to the callback through the bleScanEveStm data stream.

      ```
      _blePlugin.cancelScan();
      ```


### 2.3 Connect

1. **Connect**

   Get the watch's Mac address by scanning the received CRPScanDevice. Click the Bluetooth connection to connect the device, and the Bluetooth connection monitoring will be triggered at the same time. Monitor connection and callback status via the connStateEveStm data stream. The result is saved in "event". It is recommended to add an appropriate delay when disconnecting and reconnecting, so that the system can recover resources and ensure the connection success rate.

   ```dart
   _blePlugin.connect(String address);
   ```

   Add event stream listener.

   ```dart
   _blePlugin.connStateEveStm.listen(
     (int event) {
      // Do something with new state
     }),
   ```
   
   ConnectionState:
   
   | value               | value type | value description |
   | ------------------- | ---------- | ----------------- |
   | STATE_DISCONNECTED  | int        | 0,disconnected    |
   | STATE_CONNECTING    | int        | 1,connecting      |
   | STATE_CONNECTED     | int        | 2,connected       |
   | STATE_DISCONNECTING | int        | 3,disconnecting   |
   
2. **isConnected**

   Get the current status of the watch's successful connection according to the watch's mac address.

   ```dart
   bool connectedState = await _blePlugin.isConnected(String address);
   ```

3. **disconnect**

   Disconnected watch,disconnect returns true

   ```dart
   bool disconnect=await _blePlugin.disconnect();
   ```

### 2.4 Time

1. **sync Time**

   Synchronize the time of your phone and watch

   ```
   _blePlugin.syncTime();
   ```

2. **Sets Time System**

   Sets the system time of the watch

   ```
   _blePlugin.sendTimeSystem(TimeSystemType);
   ```

   Parameter Description :

   TimeSystemType:

   | value          | value type | value description |
   | -------------- | ---------- | ----------------- |
   | TIME_SYSTEM_12 | int        | 12-Hour Time      |
   | TIME_SYSTEM_24 | int        | 24-Hour Time      |

3. **Gets Time System**

   Gets  the time system of the watch.

   ```
   int imeSystemType = await _blePlugin.queryTimeSystem();
   ```

### 2.5 Firmware

1. **Gets firmware version**

   Gets the current firmware version of the watch.

   ```dart
   String firmwareVersion = await _blePlugin.queryFirmwareVersion();
   ```

2. **Check firmware**

   Get the latest version information.

   ```
   CheckOtaBean info = await _blePlugin.checkFirmwareVersion();
   ```

   Callback Description:

   CheckOtaBean:

   | callback value      | callback value type | callback value description           |
   | ------------------- | ------------------- | ------------------------------------ |
   | firmwareVersionInfo | FirmwareVersionBean | The latest version information       |
   | isLatestVersion     | String              | Is it the latest version information |

   FirmwareVersionBean：

   | ack value     | callback value type | callback value description                   |
   | ------------- | ------------------- | -------------------------------------------- |
   | version       | String              | Current firmware version number of the watch |
   | changeNotes   | String              | change note                                  |
   | changeNotesEn | int                 | english change note                          |
   | type          | bool                | Upgrade type, same as OTAType                |
   | mcu           | int                 | MCU type, used to distinguish upgrade mode   |
   | tpUpgrade     | String              |                                              |

   OTAType：

   | value               | value type | value description |
   | ------------------- | ---------- | ----------------- |
   | NORMAL_UPGEADE_TYPE | int        | 0                 |
   | BETA_UPGRADE_TYPE   | int        | 1                 |
   | FORCED_UPDATE_TYPE  | int        | 2                 |

3. **Firmware upgrade**

   The firmware upgrade is divided into four upgrade methods.

   ```dart
   ///The first way to upgrade
   _platform.hsStartOTA(String address);
   ///The second way to upgrade
   _platform.rtStartOTA(String address);
   ///The third way to upgrade,firmwareUpgradeFlag is true
   _platform.startOTA(bool firmwareUpgradeFlag);
   ///The four way to upgrade,firmwareUpgradeFlag is false
   _platform.startOTA(bool firmwareUpgradeFlag);
   ```

   Parameter Description :

   | value               | value type | value description                |
   | ------------------- | ---------- | -------------------------------- |
   | address             | String     | Device address                   |
   | firmwareUpgradeFlag | bool       | Firmware version update judgment |

   the upgrade method is determined according to the mcu value in the firmware version information of the current watch.

   The mcu value of the firmware version is obtained by the checkFirmwareVersion method.

   ```
   switch (mcu) {
         case 4:
         case 8:
         case 9:
           oTAType = "OTA_FIRST";
           String hsDfuAddress = await _blePlugin.queryHsDfuAddress;
           await _blePlugin.hsStartOTA(hsDfuAddress);
           break;
         case 7:
         case 11:
         case 71:
         case 72:
           oTAType = "OTA_SECOND";
           await _blePlugin.rtStartOTA(address);
           break;
         case 10:
           oTAType = "OTA_THIRD";
           await _blePlugin.startOTA(true);
           break;
         default:
           oTAType = "OTA_FOUR";
           await _blePlugin.startOTA(false);
           break;
       }
   ```

4. **Abort upgrade**

   Firmware abort is divided into three methods.

   ```dart
   ///First Termination Method
   _platform.hsAbortOTA();
   ///Second abort method
   _platform.rtAbortOTA();
   ///Third abort method
   _platform.abortOTA();
   ```

   The abort method is determined according to the oTAType saved when the current watch firmware version is upgraded.

   ```
   switch (oTAType) {
         case "OTA_FIRST":
           await _blePlugin.hsAbortOTA();
           break;
         case "OTA_SECOND":
           await _blePlugin.rtAbortOTA();
           break;
         default:
           await _blePlugin.abortOTA();
           break;
      }
   ```
   
5. **Watch DFU status**

   ```dart
   int deviceDfuStatus = await _platform.queryDeviceDfuStatus();
   ```

6. **Query Hs dfu address**

   ```dart
   String hsDfuAddress = await _platform.queryHsDfuAddress();
   ```

7. **Enable Hs Dfu**

   ```dart
   _platform.enableHsDfu();
   ```

8. **Query Goodix dfu type**

   ```dart
   int type = await _platform.queryDfuType();
   ```
   


### 2.6 Battery

1. **Set Device Battery**

   Set the watch battery monitoring stream connDeviceBatteryEveStm to return data about the watch battery.

   ```dart
   _blePlugin.deviceBatteryEveStm.listen(
           (DeviceBatteryBean event) {
             // Do something with new state
           });
   ```

   Callback Description(event):

   DeviceBatteryBean:

   | callback value | callback value type | callback value description                     |
   | -------------- | ------------------- | ---------------------------------------------- |
   | enable         | bool                | Whether the battery subscription is successful |
   | deviceBattery  | int                 | watch battery                                  |

2. **Gets Device Battery**

   Gets the current battery of the watch. When the battery level of the watch exceeds 100, it means the watch is charging.

   The result is returned through the data stream deviceBatteryEveStmand stored in the deviceBattery field in "event"

   ```dart
   _blePlugin.queryDeviceBattery();
   ```

3. **Subscription battery**

   When the battery of the watch changes, the result is returned through the data stream deviceBatteryEveStmand saved in the subscribe field in "event".

   ```
   _blePlugin.subscribeDeviceBattery();
   ```


### 2.7 User Info

1. **sendUserInfo**

   Set the user's personal information to the watch.

   ```
   _blePlugin.sendUserInfo(UserBean info);
   ```

   Parameter Description :

   UserBean:

   | value  | value type | value description                                       |
   | ------ | ---------- | ------------------------------------------------------- |
   | weight | int        | Weight (used to calculate calories)                     |
   | height | int        | Height (used to calculate the distance of the activity) |
   | gender | int        | Gender (used to measure blood pressure or blood oxygen) |
   | age    | int        | Age (for measuring blood pressure or blood oxygen)      |

2. **Sets step length**

   In the watch firmware 1.6.6 and above, you can set the step length to the watch to calculate the activity data more accurately

   ```dart
   _blePlugin.sendStepLength(int stepLength);
   ```

   Parameter Description :

   | value      | value type | value description                           |
   | ---------- | ---------- | ------------------------------------------- |
   | stepLength | int        | Distance between each step, in centimeters. |


### 2.8 Weather

1. **Weather listener**

   The watch can save real-time weather for 2 hours, and the weather information will be cleared after 2 hours. When the watch does not have today's weather information, the watch will reset the weather when it switches to the weather interface.

   Set up a weather listener weatherChangeEveStm, and the update result of the weather state is returned through the data stream and saved in the "event".

   ```dart
   _blePlugin.weatherChangeEveStm.listen(
           (int event) {
              // Do something with new state
           });
   ```

2. **Today's weather**

   Set the watch's weather for today

   ```
   _blePlugin.sendTodayWeather(TodayWeatherBean info);
   ```

   Parameter Description :

   TodayWeatherBean:

   | value     | value type | value description                         |
   | --------- | ---------- | ----------------------------------------- |
   | city      | String     | City                                      |
   | lunar     | String     | Lunar Festival (not necessary)            |
   | festival  | String     | festival(not necessary)                   |
   | pm25      | int        | PM2.5                                     |
   | temp      | int        | Real-time temperature                     |
   | weatherId | int        | Weather status,Parameter source WeatherId |

   WeatherId：

   | value     | value type    | value description |
   | --------- | ------------- | ----------------- |
   | CLOUDY    | partly cloudy | 0                 |
   | FOGGY     | fog           | 1                 |
   | OVERCAST  | overcast      | 2                 |
   | RAINY     | rainy         | 3                 |
   | SNOWY     | snowy         | 4                 |
   | SUNNY     | sunny         | 5                 |
   | SANDSTORM | sandstorm     | 6                 |
   | HAZE      | haze          | 7                 |

3. **Weather in the next 7 days**

   Sets the weather for the next 7 days to the watch.

   ```dart
   _blePlugin.sendFutureWeather(FutureWeatherListBean info);
   ```

Parameter Description :

FutureWeatherListBean:

| value  | value type              | value description |
| ------ | ----------------------- | ----------------- |
| future | List<FutureWeatherBean> | future weather    |

FutureWeatherBean:

| value           | value type | value description   |
| --------------- | ---------- | ------------------- |
| weatherId       | int        | weather Id          |
| lowTemperature  | int        | lowest temperature  |
| highTemperature | int        | maximum temperature |

### 2.9 Steps

1. **Sets steps listeners**

   Set a step change listener connStepChangeEveStm, the result is returned through the data stream, and saved in "event" as the EventConnStepChange object.

   ```dart
   _blePlugin.stepsChangeEveStm.listen(
           (StepChangeBean event) {
               // Do something with new state
     });
   ```

   Callback Description(event):

   StepChangeBean：

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | stepInfo       | StepChange          | Current step information   |
   | past           | int                 | days                       |
   | pastStepInfo   | StepChange          | Past step information      |

   StepChange:

   | callback value | callback value type | callback value description                                   |
   | -------------- | ------------------- | ------------------------------------------------------------ |
   | steps          | int                 | steps                                                        |
   | distance       | int                 | Distance (in meters)                                         |
   | calories       | int                 | Calories (units of kilocalories)                             |
   | time           | int                 | Activity duration, (the default value is 0, which means the watch does not support) |

2. **Today's steps**

   Query today's step count data. The query result will be obtained through the stepsChangeEveStm listening stream and saved in the StepChangeBean.stepInfo field.

   ```
   _platform.syncSteps;
   ```

3. **Historical steps**

   The watch can save the number of activity steps in the past three days, and can query the number of activity steps in a certain day.

   Query the activity steps data in a certain day. The query result will be obtained through the trainingEveStm listening stream and saved in the trainingInfo.past field and trainingInfo.pastStepInfo field.

   ```
   _platform.syncHistorySteps(PastTimeType);
   ```

   Parameter Description :

   PastTimeType:

   | value                      | value type | value description |
   | -------------------------- | ---------- | ----------------- |
   | YESTERDAY_STEPS            | int        | 1                 |
   | DAY_BEFORE_YESTERDAY_STEPS | int        | 2                 |
   | YESTERDAY_SLEEP            | int        | 3                 |
   | DAY_BEFORE_YESTERDAY_SLEEP | int        | 4                 |

4. **Step statistics listener**

   Set a step category listener stepsCategoryEveStm, and the result is returned through the data stream and saved in the "event" as the StepsCategoryBean object.

   ```dart
   _blePlugin.stepsCategoryEveStm.listen(
           (StepsCategoryBean event) {
       /// Do something with new state
     });
   ```

   Callback Description(event):

   StepsCategoryBean：

   | callback value | callback value type | callback value description    |
   | -------------- | ------------------- | ----------------------------- |
   | dateType       | int                 | Date type, today or yesterday |
   | timeInterval   | int                 | time interval, in minutes     |
   | stepsList      | List<Integer>       | steps list                    |

5. **Get step statistics**

   Some watches support categorical statistics for the past two days.

   Query classification statistics for the past two days. The query result will be obtained through the stepsCategoryEveStm listening stream and saved in "event" as the StepsCategoryBean object.

   ```dart
   _platform.queryStepsCategory(StepsCategoryDateType);
   ```

   Parameter Description :

   StepsCategoryDateType:

   | value                    | value type | value description |
   | ------------------------ | ---------- | ----------------- |
   | TODAY_STEPS_CATEGORY     | int        | 0                 |
   | YESTERDAY_STEPS_CATEGORY | int        | 2                 |


### 2.10 Sleep

1. **Sleep listener**

   Set up a sleep monitor connSleepChangeEveStm, and save the returned value in "event" with the value of the ConnSleepBean object.

   ```dart
   _blePlugin.sleepChangeEveStm.listen(
           (SleepBean event) {
        // Do something with new state
     });
   ```

   Callback Description(event):

   SleepBean：

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | sleepInfo      | CRPSleepInfo        | Current sleep information  |
   | past           | int                 | days                       |
   | pastSleepInfo  | CRPSleepInfo        | Past sleep information     |

   SleepInfo：

   | callback value      | callback value type | callback value description |
   | ------------------- | ------------------- | -------------------------- |
   | SLEEP_STATE_REM     | int                 | 3                          |
   | SLEEP_STATE_RESTFUL | int                 | 2                          |
   | SLEEP_STATE_LIGHT   | int                 | 1                          |
   | SLEEP_STATE_SOBER   | int                 | 0                          |
   | totalTime           | int                 | Total sleep time           |
   | restfulTime         | int                 | restful time               |
   | lightTime           | int                 | light time                 |
   | soberTime           | int                 | awake time                 |
   | remTime             | int                 | rem time                   |

   CRPSleepInfo.DetailBean:

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | startTime      | int                 | start time                 |
   | endTime        | int                 | end time                   |
   | totalTime      | int                 | total time                 |
   | type           | int                 | sleep state                |

2. **Today's sleep**

   The sleep clear time of the watch is 8 pm, and the sleep time recorded by the watch is from 8 pm to 10 am the next day.

   Query detailed data for a training. The query result will be obtained through the sleepChangeEveStm listening stream and saved in the SleepBean.sleepInfo field

   ```dart
   _platform.syncSleep;
   ```
   
3. **Historical sleep**

   The watch can save the sleep data of the past three days, and can query the sleep data of a certain day.

   Query the sleep data of a certain day. The query result will be obtained through the connSleepChangeEveStm listening stream and saved in the ConnSleepBean.past field and the ConnSleepBean.pastSleepInfo field.

   ```dart
   _platform.syncHistorySleep(PastTimeType);
   ```

   Parameter Description :

   PastTimeType:

   | value                      | value type | value description |
   | -------------------------- | ---------- | ----------------- |
   | YESTERDAY_STEPS            | int        | 1                 |
   | DAY_BEFORE_YESTERDAY_STEPS | int        | 2                 |
   | YESTERDAY_SLEEP            | int        | 3                 |
   | DAY_BEFORE_YESTERDAY_SLEEP | int        | 4                 |


### 2.11 Unit system

1. **Sets the unit system**

   The watch supports setting the time system to metric and imperial

   ```dart
   /// type see UnitSystemType
   _blePlugin.sendUnitSystem(UnitSystemType);
   ```

   Parameter Description :

    UnitSystemType:

   | value           | value type | value description |
   | --------------- | ---------- | ----------------- |
   | METRIC_SYSTEM   | byte       | 0                 |
   | IMPERIAL_SYSTEM | byte       | 1                 |

2. **Gets the unit system**

   ```dart
   int unitSystemType = await _blePlugin.queryUnitSystem();
   ```

### 2.12 Quick view

1. **Sets the quick view**

   Turns the quick view on or off.

   ```dart
   /// quickViewState: true enable; false otherwise.
   _blePlugin.sendQuickView(bool enable);
   ```

2. **Gets the quick view**

   Gets the quick view state of the device.

   ```dart
   bool quickViewState = await _blePlugin.queryQuickView();
   ```

3. **Sets the effective time for quick view**

   The watch supports setting the effective time period for turning the wrist and turning on the screen, and it is only valid when turning the wrist and turning on the screen within the set time period

   ```dart
   _blePlugin.sendQuickViewTime(PeriodTimeBean info);
   ```

   Parameter Description :

   PeriodTimeBean:

   | value       | value type | value description     |
   | ----------- | ---------- | --------------------- |
   | endHour     | int        | end time hours        |
   | endMinute   | int        | end time in minutes   |
   | startHour   | int        | start time hours      |
   | startMinute | int        | start time in minutes |

4. **Gets the effective time for quick view**

   ```dart
   PeriodTimeResultBean info = await _blePlugin.queryQuickViewTime();
   ```

   Callback Description:

   PeriodTimeResultBean:
   
   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | periodTimeType | int                 | type of event              |
   | periodTimeInfo | PeriodTimeInfo      | specific event             |


### 2.13 Goal steps

1. **Sets goal steps**

   Push the user's target step number to the watch. When the number of activity steps on the day reaches the target number of steps, the watch will remind you to reach the target.

   ```dart
   _blePlugin.sendGoalSteps(int goalSteps);
   ```

2. **Gets goal steps**

   Gets the target number of steps set in the watch

   ```dart
   int goalSteps = await _blePlugin.queryGoalSteps();
   ```


### 2.14 Watchface

1. **Sets watchface index**

   The watch supports a variety of different watchfaces, which can be switched freely.

   Send watchface type,Parameters provided by WatchFaceType

   ```dart
   /// type see CRPWatchFaceType
   _blePlugin.sendDisplayWatchFace(WatchFaceType);
   ```

   WatchFaceType:

   | **FIRST_WATCH_FACE** | **SECOND_WATCH_FACE** | **THIRD_WATCH_FACE** |
   | -------------------- | --------------------- | -------------------- |
   | 0x01                 | 0x02                  | 0x03                 |

2. **Gets the watchface**

   Gets the type that the watch face is currently using.

   ```
   int watchFaceType = await _blePlugin.queryDisplayWatchFace();
   ```

3. **Gets the watchface layout**

   ```dart
   WatchFaceLayoutBean info = await _blePlugin.queryWatchFaceLayout();
   ```

   Parameter Description :

   WatchFaceLayoutBean：

   | backgroundPictureMd5                                         | compressionType                                              | height                                | textColor       | thumHeight                                                   | thumWidth                                                    | timeBottomContent | timePosition  | timeTopContent | width                                |
   | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------- | --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------- | ------------- | -------------- | ------------------------------------ |
   | The background image MD5 has a length of 32 bits. When padded with 0, the background image  restores the default background. | The compression type(LZO,RGB_DEDUPLICATION,RGB_LINE, ORIGINAL) | The watch face height default 240 px. | font color(RGB) | The thum watch face width,The default is 0, which means it is not supported | The thum watch face width,The default is 0, which means it is not supported | content displayed | time position | content        | The watch face width default 240 px. |

   WatchFaceLayoutType:

   | **WATCH_FACE_TIME_TOP**       | **Time is at the top right** |
   | ----------------------------- | ---------------------------- |
   | WATCH_FACE_TIME_BOTTOM        | Time is at the bottom right  |
   | WATCH_FACE_CONTENT_CLOSE      | Do not display anything      |
   | WATCH_FACE_CONTENT_DATE       | Date                         |
   | WATCH_FACE_CONTENT_SLEEP      | Sleep                        |
   | WATCH_FACE_CONTENT_HEART_RATE | Heart Rate                   |
   | WATCH_FACE_CONTENT_STEP       | Steps                        |

4. **Sets the watchface layout**

   ```dart
   _blePlugin.sendWatchFaceLayout(WatchFaceLayoutBean info);
   ```

5. **Sets the watchface background**

   The dial of the 1.3-inch color screen supports the replacement of the background image with a picture size of 240 * 240 px. Compressed indicates whether the picture needs to be compressed (the watch with the master control of 52840 does not support compression and is fixed to false); timeout indicates the timeout period, in seconds. The progress is called back by _blePlugin.connLazyFileTransEveStm.listen

   ```dart
   await _blePlugin.sendWatchFaceBackground(WatchFaceBackgroundBean info);
   ```


Parameter Description :

WatchFaceBackgroundBean:

| callback value | callback value type | callback value description              |
| -------------- | ------------------- | --------------------------------------- |
| bitmap         | Uint8List           | The bitmap of background image          |
| thumbBitmap    | Uint8List           | The bitmap of thumbnail                 |
| type           | String              | WatchFaceLayoutBean.WatchFaceLayoutType |
| thumbWidth     | int                 | width of thumbBitmap                    |
| thumbHeight    | int                 | height of thumbBitmap                   |
| width          | int                 | width of bitmap                         |
| height         | int                 | height of bitmap                        |

6.**Watchface background Listener**

Monitor the process of sending the dial background.

```dart
var lazyFileTransEveStm = _blePlugin.lazyFileTransEveStm.listen(
          (WatchFaceBgProgressBean event) {
        /// Do something with new state
      },
    );
    lazyFileTransEveStm.onError((error) {
      print(error.toString());
    });
```

Callback Description:

WatchFaceBgProgressBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| isError        | bool                | Is it wrong                |
| progress       | int                 | transfer progress          |

7.**Get support watchface type**

When the watch switches dials, it needs to query the type supported by the dial.

```dart
SupportWatchFaceBean info = await _blePlugin.querySupportWatchFace();
```

Return value description：

SupportWatchFaceBean:

| displayWatchFace                    | supportWatchFaceList |
| ----------------------------------- | -------------------- |
| The currently displayed dial number | Types of watch faces |

8.**Gets the watchface store**

According to the watchface type supported by the watch, obtain a list of watchfaces that the watch can be replaced. 

Gets the list of available watch faces by way of paging query.

```dart
List<WatchFaceBean> listInfo= await _blePlugin.queryWatchFaceStore(WatchFaceStoreBean);
```

WatchFaceStoreBean :

String firmwareVersion = await _blePlugin.queryFirmwareVersion();

| watchFaceSupportList   | firmwareVersion              | pageCount                      | pageIndex           |
| ---------------------- | ---------------------------- | ------------------------------ | ------------------- |
| watchface support type | Dial firmware version number | Number of watch faces per page | current page number |

Precautions:

watchFaceSupportList:parameters are obtained by the _blePlugin.querySupportWatchFace.

firmwareVersion:Get the firmware version number through _blePlugin.queryFirmwareVersion.

9.**Get the watchface information of the watchface ID**

```dart
WatchFaceIdBean info = await _blePlugin.queryWatchFaceOfID(id);
```

Parameter Description :

WatchFaceIdBean:

| value | value type | value description                                            |
| ----- | ---------- | ------------------------------------------------------------ |
| id    | int        | The information of the dial is obtained by the id of the dial, and the parameters are obtained by the _blePlugin.queryDisplayWatchFace |

Return value description：

WatchFaceIdBean:

| callback value | callback value type | callback value description |
| -------------- | ------------------- | -------------------------- |
| watchFace      | WatchFace           | watch face file            |
| error          | String              | error message              |
| code           | int                 | return code                |

WatchFace:

| id      | preview                       | file                         |
| ------- | ----------------------------- | ---------------------------- |
| file id | Watchface  Image preview link | Watchface file download link |

10.**Sending a watchface file**

Send the watchface file of the new watchface to the watch, during which the watch will restart. 

```dart
_blePlugin.sendWatchFace(CustomizeWatchFaceBean,timeout);
```

Parameter Description :

CustomizeWatchFaceBean:

| value | value type | value description                               |
| ----- | ---------- | ----------------------------------------------- |
| index | int        | file id                                         |
| file  | String     | The address where the watch face file is stored |

### 2.15 Alarm

1. **Sets alarm**

   The watch supports three alarm clocks, and the alarm clock information can be set according to the alarm clock serial number. Single alarm clock supports setting date.

   ```dart
   _blePlugin.sendAlarm(AlarmClockBean info);
   ```

   Parameter Description :

   AlarmClockBean:

   | id       | hour                  | minute | repeatMode  | enable |
   | -------- | --------------------- | ------ | ----------- | ------ |
   | Alarm id | hour (24-hour format) | minute | Repeat mode | enable |

   Alarm id：

   | FIRST_CLOCK       | **SECOND_CLOCK**   | THIRD_CLOCK       |
   | ----------------- | ------------------ | ----------------- |
   | First alarm clock | Second alarm clock | Third alarm clock |

   Repeat mode：

   | SINGLE                    | SUNDAY           | MONDAY           | TUESDAY           | WEDNESDAY           | THURSDAY           | FRIDAY           | SATURDAY           | EVERYDAY |
   | ------------------------- | ---------------- | ---------------- | ----------------- | ------------------- | ------------------ | ---------------- | ------------------ | -------- |
   | Single, only valid today. | Repeat on Sunday | Repeat on Monday | Repeat on Tuesday | Repeat on Wednesday | Repeat on Thursday | Repeat on Friday | Repeat on Saturday | Everyday |

2. **Gets all alarm**

   Gets all alarm clock information saved by the watch.

   ```dart
   List<AlarmClockBean> listInfo = await _blePlugin.queryAllAlarm();
   ```

### 2.16 Language

1. **Sets the watch language**

   Set the language of the watch. When setting the language, the language version will be set. Simplified Chinese is set to the Chinese version, and non-simplified Chinese is set to the international version.

   ```dart
   _blePlugin.sendDeviceLanguage(DeviceLanguageType);
   ```

   Parameter Description :

   DeviceLanguageType:

   | LANGUAGE_ENGLISH | LANGUAGE_CHINESE   | LANGUAGE_JAPANESE | LANGUAGE_KOREAN | LANGUAGE_GERMAN | LANGUAGE_FRENCH | LANGUAGE_SPANISH | LANGUAGE_ARABIC | LANGUAGE_RUSSIAN | LANGUAGE_TRADITIONAL |
   | ---------------- | ------------------ | ----------------- | --------------- | --------------- | --------------- | ---------------- | --------------- | ---------------- | -------------------- |
   | English          | Chinese Simplified | Japanese          | Korean          | German          | French          | Spanish          | Arabic          | Russian          | traditional Chinese  |

    Precautions: Italian and Portuguese only support watch firmware 1.7.1 and above.

2. **Gets the watch language**

   Gets the language that the watch is using and the list of languages supported by the watch. 

   ```dart 
   DeviceLanguageBean info = await _blePlugin.queryDeviceLanguage();
   ```

Callback Description:

| callback value | callback value type | callback  value description |
| -------------- | ------------------- | --------------------------- |
| languageType   | List<int>           | All language types          |
| type           | int                 | current language type       |

### 2.17 Notification

1. **Sets other message**

   Enable or disable other push notifications.

   ```dart
   _blePlugin.sendOtherMessageState(bool enable);
   ```

   Parameter Description :

   | value        | value type | value description            |
   | ------------ | ---------- | ---------------------------- |
   | messageState | bool       | true:enable    false:disable |

2. **Gets other message**

   Gets other message push status.

   ```dart
   bool enable = await _blePlugin.queryOtherMessageState();
   ```

3. **Send message**

   Send various types of message content to the watch.

   ```dart
   _blePlugin.sendMessage(MessageBean info);
   ```

   Parameter Description :

   MessageBean:

   | message         | type                        | versionCode                                                | isHs                                          | isSmallScreen                    |
   | --------------- | --------------------------- | ---------------------------------------------------------- | --------------------------------------------- | -------------------------------- |
   | Message content | Messagetype(BleMessageType) | Firmware version (for example: MOY-AA2-1.7.6,which is 176) | Whether the MCU is HS, please confirm the MCU | Is the watch screen smaller than |

   BleMessageType:

   | **value**         | value description              |
   | ----------------- | ------------------------------ |
   | MESSAGE_PHONE     | phone                          |
   | MESSAGE_SMS       | SMS                            |
   | MESSAGE_WECHAT    | WeChat (Chinese Edition)       |
   | MESSAGE_QQ        | QQ                             |
   | MESSAGE_FACEBOOK  | FACEBOOK                       |
   | MESSAGE_TWITTER   | TWITTER                        |
   | MESSAGE_WHATSAPP  | WHATSAPP                       |
   | MESSAGE_WECHAT_IN | WeChat (International Edition) |
   | MESSAGE_INSTAGREM | INSTAGREM                      |
   | MESSAGE_SKYPE     | SKYPE                          |
   | MESSAGE_KAKAOTALK | KAKAOTALK                      |
   | MESSAGE_LINE      | LINE                           |
   | MESSAGE_OTHER     | Other                          |

4. **End call**

   When the watch receives a push of a phone type message, the watch will vibrate for a fixed time. Call this interface to stop the watch from vibrating when the watch answers the call or hangs up the call.

   ```dart
   _blePlugin.endCall();
   ```

### 2.19 Sedentary reminder

1. **Sets sedentary reminder**

   Turn sedentary reminders on or off.

   ```dart
   _blePlugin.sendSedentaryReminder(bool enable);
   ```

   Parameter Description :

   | value  | value type | value description            |
   | ------ | ---------- | ---------------------------- |
   | enable | bool       | true:enable    false:disable |

2. **Gets sedentary reminder**

   Query sedentary reminder status

   ```darrt
   bool enable = await _blePlugin.querySedentaryReminder();
   ```

3. **Set sedentary reminder time**

   Set the effective period of sedentary reminder.

   ```dart
   _blePlugin.sendSedentaryReminderPeriod(SedentaryReminderPeriodBean info);
   ```

   Parameter Description :

   SedentaryReminderPeriodBean:

   | period                                   | steps                   | startHour                  | endHour                  |
   | ---------------------------------------- | ----------------------- | -------------------------- | ------------------------ |
   | Sedentary reminder period (unit: minute) | Maximum number of steps | Start time (24-hour clock) | End time (24-hour clock) |

4. **Get sedentary reminder time**

   Query the watch for sedentary reminder valid period.

   ```dart
   SedentaryReminderPeriodBean info = await _blePlugin.querySedentaryReminderPeriod()
   ```

### 2.20 **Find the watch**

Find the watch, the watch will vibrate for a few seconds after receiving this command

```dart
_blePlugin.findDevice();
```

### 2.21 **Heart rate**

1.**Set heart rate listener**

All heart rate related data will pass the _blePlugin.connHeartRateEveStm.listen callback

```dart
 _blePlugin.heartRateEveStm.listen(
        (event) {
          /// Do something with new state
        }),
```

Callback Description:

HeartRateBean：

| callback value         | callback value type         | callback  value description                               |
| ---------------------- | --------------------------- | --------------------------------------------------------- |
| measuring              | int                         | The last dynamic heart rate measurement result            |
| onceMeasureComplete    | int                         | Take a heart rate measurement                             |
| historyHRList          | List<HistoryHeartRateBean>  | Historical heart rate data                                |
| historyDynamicRateType | HistoryDynamicRateType      | Heart rate type, exercise heart rate                      |
| measureComplete        | HeartRateInfo               | Heart rate data                                           |
| hour24MeasureResult    | HeartRateInfo               | Heart rate measurement data for today or the previous day |
| movementList           | List<MovementHeartRateBean> | Dynamic heart rate data                                   |

HistoryHeartRateBean：

| callback value | callback value type | callback  value description |
| -------------- | ------------------- | --------------------------- |
| date           | String              | date                        |
| hr             | int                 | heart rate                  |

MovementHeartRateBean：

| type  | startTime | endTime                        | validTime                    | steps                                         | distance                                               | calories |
| ----- | --------- | ------------------------------ | ---------------------------- | --------------------------------------------- | ------------------------------------------------------ | -------- |
| Sport | mode      | Start time (unit:milliseconds) | End time (unit:milliseconds) | Effective duration of exercise (unit: second) | Number of steps (partial motion mode is not supported) | Calories |

Sport mode：

| **WALK_TYPE** | **RUN_TYPE** | **BIKING_TYPE** | **ROPE_TYPE** | **BADMINTON_TYPE** | **BASKETBALL_TYPE** | **FOOTBALL_TYPE** | **SWIM_TYPE** |
| ------------- | ------------ | --------------- | ------------- | ------------------ | ------------------- | ----------------- | ------------- |
| Walking       | Run          | bicycle         | rope skipping | badminton          | basketball          | football          | Swim          |

2.**Query last dynamic heart rate measurement**

The dynamic heart rate is measured in an unconnected state and the watch can save the last measurement. 

Query the last measured heart rate record saved by the watch. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.measuring field.

```dart
await _blePlugin.queryLastDynamicRate(HistoryDynamicRateType);
```

HistoryDynamicRateType:

Parameter Description :

| value             | value type | value description |
| ----------------- | ---------- | ----------------- |
| FIRST_HEART_RATE  | String     | first             |
| SECOND_HEART_RATE | String     | second            |
| THIRD_HEART_RATE  | String     | third             |

3.**Enable timing to measure heart rate**

The watch supports 24-hour timed measurement of heart rate, starting from 00:00, you can set the measurement interval, the time interval is a multiple of 5 minutes.

```dart
_blePlugin.enableTimingMeasureHeartRate(int interval);
```

4.**Disable timing to measure heart rate**

Turn off the timing to measure the heart rate.

```
await _blePlugin.disableTimingMeasureHeartRate();
```

5.**Query timing to measure heart rate status**

The query timing measures the heart rate on state,

```dart
int timeHR = await _blePlugin.queryTimingMeasureHeartRate();
```

6.**Query today's heart rate measurement data**

Today's heart rate measurement is divided into two types, which are obtained according to the measurement method supported by the corresponding watch. 

Query today's measured heart rate value. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.hour24MeasureResult field.

```dart
await _blePlugin.queryTodayHeartRate(TodayHeartRateType);
```

TodayHeartRateType：

| TIMING_MEASURE_HEART_RATE    | **ALL_DAY_HEART_RATE**         |
| ---------------------------- | ------------------------------ |
| Timed heart rate measurement | 24-hour continuous measurement |

7.**Query historical heart rate data**

Query the heart rate data of the previous day. The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.hour24MeasureResult field.

```dart
await _blePlugin.queryPastHeartRate();
```

8.**Query Action data**

Some watchs support heart rate measurement in a variety of motion modes. The measurements include other motion-related data such as heart rate and calories. This interface is used to obtain data such as calories. The watch can save the last three sports data. Supporting 24-hour continuous measurement of the watch, the exercise heart rate can be obtained from the 24-hour heart rate data according to the movement up time; other watch exercise heart rate and dynamic heart rate acquisition methods are consistent.

The query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.movementList field.

```
await _blePlugin.queryMovementHeartRate();
```

9.**Measuring once heart rate**

Start measuring a single heart rate, the query result will be obtained through the heartRateEveStm listening stream and saved in the HeartRateBean.onceMeasureComplete field.

```
await _blePlugin.startMeasureOnceHeartRate();
```

10.**Stop once heart rate**

End a once measurement. A measurement time that is too short will result in no measurement data.

```
await _blePlugin.stopMeasureOnceHeartRate();
```

11.**Query history once heart rate**

To query the historical heart rate, the query result will be obtained through the heartRateEveStm monitoring stream and saved in the HeartRateBean.historyHRList field.

```
await _blePlugin.queryHistoryHeartRate();
```

### **2.22 Blood pressure**

1. **Set blood pressure listener**

   ```dart
    _blePlugin.bloodPressureEveStm.listen(
           (event) {
       // Do something with new state
     });
   ```

   Callback Description(event):

   BloodPressureBean：

   | callback value       | callback value type            | callback value description                |
   | -------------------- | ------------------------------ | ----------------------------------------- |
   | continueState        | bool                           | Continue to display blood pressure status |
   | bloodPressureChange  | int                            | blood pressure change                     |
   | bloodPressureChange1 | int                            | blood pressure change                     |
   | historyBPList        | List<HistoryBloodPressureBean> | historical blood pressure                 |
   | continueBP           | BloodPressureInfo              | 24 hour blood pressure                    |

   HistoryBloodPressureBean:

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | date           | String              | date of measurement        |
   | sbp            | int                 | systolic blood pressure    |
   | dbp            | int                 | diastolic blood pressure   |

   BloodPressureInfo:

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | startTime      | int                 | Start measuring time       |
   | timeInterval   | int                 | Intervals                  |

   TimeType:

   | TODAY | YESTERDAY |
   | ----- | --------- |
   | today | yesterday |

2. **Measuring blood pressure**

   ```
   _blePlugin.startMeasureBloodPressure;
   ```

3. **Stop measuring blood pressure**

   Stop measuring blood pressure, too short a measurement time will result in no measurement results.The measurement results are monitored through the connBloodPressureEveStm data stream, and the value is stored in BloodPressureBean.bloodPressureChange and ConnBloodOxygenBean.bloodPressureChange1.

   ```
   _blePlugin.stopMeasureBloodPressure;
   ```

4. **Enable continue blood pressure**

   ```
   _blePlugin.enableContinueBloodPressure;
   ```

5. **Disable continue blood pressure**

   ```
    _blePlugin.disableContinueBloodPressure;
   ```

6. **Query continue blood pressure state**

   The measurement results are monitored through the bloodPressureEveStmdata stream, and the value is stored in BloodPressureBean.continueState

   ```
   _blePlugin.queryContinueBloodPressureState;
   ```

7. **Query last 24 hour blood pressure**

   The measurement results are monitored through the bloodPressureEveStmdata stream, and the value is stored in BloodPressureBean.continueBP

   ```
   _blePlugin.queryLast24HourBloodPressure;
   ```

8. **Query history once blood pressure**

   The measurement results are monitored through the bloodPressureEveStmdata stream, and the value is stored in BloodPressureBean.historyBPList

   ```
   _blePlugin.queryHistoryBloodPressure;
   ```


### **2.23 Blood oxygen**

1. **1. Set blood oxygen listener**

   ```dart
   _blePlugin.bloodOxygenEveStm.listen(
     (event) {
       // Do something with new state
     })；
   ```

   Callback Description:

   BloodOxygenBean：

   | callback value | callback value type          | callback value description     |
   | -------------- | ---------------------------- | ------------------------------ |
   | continueState  | bool                         | Timed blood oxygen status      |
   | timingMeasure  | int                          | Timed oximetry status          |
   | bloodOxygen    | int                          | Measure blood oxygen results   |
   | historyList    | List<HistoryBloodOxygenBean> | Historical SpO2 information    |
   | continueBO     | BloodOxygenInfo              | Timed blood oxygen information |

   HistoryBloodOxygenBean:

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | date           | String              | date                       |
   | bo             | int                 | blood oxygen               |

   BloodOxygenInfo：

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | startTime      | int                 | Start measuring time       |
   | timeInterval   | int                 | time interval              |

2. **Measuring blood oxygen**

   ```
   _blePlugin.startMeasureBloodOxygen;
   ```

3. **Stop measuring blood oxygen**

   When the blood oxygen measurement is stopped, if the measurement time is too short, there will be no measurement results. The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.bloodOxygen.

   ```
   _blePlugin.stopMeasureBloodOxygen;
   ```

4. **Enable timing measure blood oxygen**

   measure period = interval * 5 (mins)

   ```
   _blePlugin.enableTimingMeasureBloodOxygen(int interval);
   ```

5. **Disable timing measure blood oxygen**

   ```
   _blePlugin.disableTimingMeasureBloodOxygen;
   ```

6. **Query timing measure blood oxygen state**

    The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.timingMeasure.

   ```
   _blePlugin.queryTimingBloodOxygenMeasureState;
   ```

7. **Query timing blood oxygen**

   The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueBO.

   ```
   _blePlugin.queryTimingBloodOxygen(BloodOxygenTimeType);
   ```

   Parameter Description :

   BloodOxygenTimeType:

   | value     | value type | value description |
   | --------- | ---------- | ----------------- |
   | TODAY     | String     | today             |
   | YESTERDAY | String     | yesterday         |

8. **Enable continue blood oxygen**

   ```
   _blePlugin.enableContinueBloodOxygen;
   ```

9. **Disable continue blood oxygen**

   ```
   _blePlugin.disableContinueBloodOxygen;
   ```

10. **Query continue blood oxygen state**

     The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueState.

    ```
    _blePlugin.queryContinueBloodOxygenState;
    ```

11. **Query last 24 hour blood oxygen**

     The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.continueBO.

    ```
    _blePlugin.queryLast24HourBloodOxygen;
    ```

12. **Query history once blood oxygen**

     The measurement results are monitored through the bloodOxygenEveStm data stream, and the value is stored in BloodOxygenBean.historyList.

    ```
    _blePlugin.queryHistoryBloodOxygen;
    ```


### **2.24 Take a photo**

1. **Set photo monitor**

   Long press the watch photo interface to trigger the camera's camera command.

   ```dart
   _blePlugin.cameraEveStm.listen(
     (event) {
       // Do something with new state
     });
   ```

1. **Enable camera view**

   ```
   _blePlugin.enterCameraView;
   ```

3. **Exit camera view**

   ```
   _blePlugin.exitCameraView;
   ```

### **2.25 Mobile phone related operations**

```dart
_blePlugin.phoneEveStm.listen(
  (event) {
    // Do something with new state
  })；
```

Callback Description(event):

| callback value | callback value type | callback value description                                   |
| -------------- | ------------------- | ------------------------------------------------------------ |
| event          | int                 | The value data comes from CRPPhoneOperationType and matches it |

CRPPhoneOperationType:

| value               | value type | value description                                            |
| ------------------- | ---------- | ------------------------------------------------------------ |
| MUSIC_PLAY_OR_PAUSE | byte       | Play / Pause                                                 |
| MUSIC_PREVIOUS      | byte       | Previous                                                     |
| MUSIC_NEXT          | byte       | Next                                                         |
| REJECT_INCOMING     | byte       | Hang up the phone. You can press and hold the trigger on the call alert interface. |
| VOLUME_UP           | byte       | Turn up the volume                                           |
| VOLUME_DOWN         | byte       | Turn down the volume                                         |
| MUSIC_PLAY          | byte       | Play                                                         |
| MUSIC_PAUSE         | byte       | Pause                                                        |

### 2.26 RSSI

1. **Set RSSI listening**

   ```dart
   _blePlugin.deviceRssiEveStm.listen(
     (event) {
       // Do something with new state
     });
   ```

2. **Read the watch RSSI**

   Read the real-time RSSI value of the watch. The query result will be obtained through the deviceRssiEveStm listening stream and saved in the "event" field.

   ```
   _blePlugin.readDeviceRssi;
   ```

### **2.27 Shut down**

```dart
 _blePlugin.shutDown;
```

### **2.28 Do not disturb**

1. **Set the do not disturb time**

   The watch supports the Do Not Disturb period. Do not display message push and sedentary reminders during the time.

   ```dart
    _blePlugin.sendDoNotDisturbTime(PeriodTimeBean);
   ```

   Parameter Description :

   | value       | value type | value description                |
   | ----------- | ---------- | -------------------------------- |
   | startHour   | int        | Start time hours (24-hour clock) |
   | startMinute | int        | Start time minutes               |
   | endHour     | int        | End time hours (24-hour clock)   |
   | endMinute   | int        | End time minutes                 |


2. **Get the do not disturb time**

   Check if do not disturb the time set by the watch.

   ```dart
   PeriodTimeResultBean  info =await _blePlugin.queryDoNotDisturbTime;
   ```

   Callback Description(event):

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | periodTimeType | int                 | type of event              |
   | periodTimeInfo | PeriodTimeInfo      | specific event             |


### **2.29 Breathing light**

1. **Sets the breathing light**

   ```dart
   _blePlugin.sendBreathingLight(bool enable);
   ```

2. **Gets the status of the breathing light**

   ```dart
   bool isEable=await _blePlugin.queryBreathingLight;
   ```

### 2.30 ECG

1. **Set ECG listener**

   Set the ECG monitor and get the return value through connLazyEgcEveStm.

   ```dart
   _blePlugin.lazyEcgEveStm.listen(
     (event) {
       // Do something with new state
     })；
   ```

   Callback Description(event):

   EgcBean:

   | callback value  | callback value type | callback value description       |
   | --------------- | ------------------- | -------------------------------- |
   | ints            | int[]               | ECG information                  |
   | measureComplete | int                 | ECG measurement completed        |
   | date            | Date                | date                             |
   | isCancel        | bool                | Whether to turn off the ECG test |
   | isFail          | bool                | Whether the ECG test failed      |

2. **Measuring ECG**

   Start to measure the ECG, the ECG measurement time is 30 seconds, and the user needs to touch the left and right electrodes of the watch with both hands. The value is obtained by listening to the lazyEcgEveStm data stream, and the value is saved in EgcBean.ints

   ```dart
   _blePlugin.startECGMeasure;
   ```

3. **Stop measuring ECG**

   ```dart
   _blePlugin.stopECGMeasure;
   ```

4. **Detect new ECG measurement methods**

   In the new measurement mode, the watch can save the last unsent measurement result; the old version does not.

   ```
   bool newMeasurementVersion =await _blePlugin.isNewECGMeasurementVersion;
   ```

5. **Get the last ECG data**

   Query the ECG data saved by the watch, monitor the data stream through lazyEcgEveStm, and save the value in EgcBean.ints

   ```dart
   _blePlugin.queryLastMeasureECGData;
   ```

6. **Send heart rate during ECG measurement**

   Using the measured data, the instantaneous heart rate is calculated through the ECG algorithm library and sent to the watch.

   ```
   _blePlugin.sendECGHeartRate(int heartRate);
   ```

### **2.31 Physiological cycle**

1. **Set the physiological cycle reminder**

   ```
   _blePlugin.sendMenstrualCycle(PhysiologcalPeriodBean info);
   ```

   Parameter Description :

   PhysiologcalPeriodBean：

   | value                | value type | value description                                            |
   | -------------------- | ---------- | ------------------------------------------------------------ |
   | physiologcalPeriod   | int        | Physiological cycle (unit: day)1，play                       |
   | menstrualPeriod      | int        | Menstrual period (unit: day)                                 |
   | startDate            | DateTime   | menstrual cycle start time                                   |
   | menstrualReminder    | bool       | Menstrual start reminder time (the day before the menstrual cycle reminder) |
   | ovulationReminder    | bool       | Ovulation reminder (a reminder the day before ovulation)     |
   | ovulationDayReminder | bool       | Ovulation Day Reminder (Reminder the day before ovulation)   |
   | ovulationEndReminder | bool       | Reminder when ovulation is over (a reminder the day before the end of ovulation) |
   | reminderHour         | int        | Reminder time (hours, 24 hours)                              |
   | reminderMinute       | int        | Reminder time (minutes)                                      |

2. **Query physiological cycle reminder**

   ```dart
   PhysiologcalPeriodBean info=await _blePlugin.queryMenstrualCycle;
   ```

   Callback Description :

   | callback value | callback value type    | callback value description               |
   | -------------- | ---------------------- | ---------------------------------------- |
   | info           | PhysiologcalPeriodBean | Gets Menstrual Cycle Reminders for Girls |


### **2.32 Find phone**

1. **Start find phone**

   When receiving a callback to find the bracelet phone, the app vibrates and plays a ringtone reminder.

   ```dart
   _blePlugin.startFindPhone;
   ```

2. **End finding phone**

   When the user retrieves the phone, the vibrate and ringtone reminder ends, returning to the watch with this command

   ```dart
   _blePlugin.stopFindPhone;
   ```


### **2.33 Music player**

1. **Set player state**

   Set music player state.

   ```dart
   _blePlugin.setPlayerState(MusicPlayerStateType);
   ```

   Parameter Description :

   MusicPlayerStateType：

   | value              | value type | value description |
   | ------------------ | ---------- | ----------------- |
   | MUSIC_PLAYER_PAUSE | byte       | 0，pause          |
   | MUSIC_PLAYER_PLAY  | byte       | 1，play           |

2. **Set song name**

   ```
   _blePlugin.sendSongTitle(String title);
   ```

3. **Set lyrics**

   ```dart
   _blePlugin.sendLyrics(String lyrics);
   ```

4. **Close Music Control**

   ```dart
   _blePlugin.closePlayerControl;
   ```

5. **Set max volume**

   ```dart
   _blePlugin.sendCurrentVolume(int volume);
   ```

6. **Set Current volumed**

   ```
   _blePlugin.sendMaxVolume(int volume);
   ```



### **2.34 Drink water reminder**

1. **Enable drinking reminder**

   Set the information of drinking water reminder.

   ```
   _blePlugin.enableDrinkWaterReminder(DrinkWaterPeriodBean info);
   ```

   Parameter Description :

   DrinkWaterPeriodBean:

   | value       | value type | value description           |
   | ----------- | ---------- | --------------------------- |
   | enable      | bool       | Drink water reminder status |
   | startHour   | int        | start time hours            |
   | startMinute | int        | start time in minutes       |
   | count       | int        | Number of reminders         |
   | period      | int        | reminder interval           |
   | currentCups | int        |                             |

2. **Disable water reminder**

   ```dart
   _blePlugin.disableDrinkWaterReminder;
   ```

3. **Query drinking reminder**

   ```dart
   DrinkWaterPeriodBean info =await _blePlugin.queryDrinkWaterReminderPeriod;
   ```

   Callback Description:

   DrinkWaterPeriodBean:

   | Callback  value | Callback value type | Callback value description |
   | --------------- | ------------------- | -------------------------- |
   | enable          | bool                | Whether to open            |
   | startHour       | int                 | hours                      |
   | startMinute     | intminutes          | minutes                    |
   | count           | int                 | reminders                  |
   | period          | int                 | reminder interval          |
   | currentCups     | int                 | the current water intake   |


### **2.35 Heart rate alarm**

1. **Sets the heart rate alarm value**

   ```dart
   _blePlugin.setMaxHeartRate(int heartRate,bool enable);
   ```

   Parameter Description :

   | value     | value type | value description |
   | --------- | ---------- | ----------------- |
   | heartRate | int        | heart rate        |
   | enable    | bool       | enable            |

2. **Gets the heart rate alarm value**

   Gets the status of the wristband heart rate alarm and the value of the heart rate alarm.

   ```
   MaxHeartRateBean info=await _blePlugin.queryMaxHeartRate;
   ```

   Callback Description:

   MaxHeartRateBean:
   
   
   
   | Callback  value | Callback value type | Callback value description               |
   | --------------- | ------------------- | ---------------------------------------- |
   | heartRate       | int                 | Heart rate alarm value                   |
   | enable          | bool                | Status of the wristband heart rate alarm |


### **2.36 Movement Training**

1. **Monitor training state**

   Modify the training state on the bracelet, and obtain the current measurement state by monitoring the data stream movementStateEveStm.

   ```dart
   _blePlugin.movementStateEveStm.listen(
     (event) {
      // Do something with new state
     })；
   ```

   Callback Description (event):

   | callback value | callback value type | callback value description         |
   | -------------- | ------------------- | ---------------------------------- |
   | event          | int                 | Mobile Training Measurement Status |

1. **Start training**

   ```
   _blePlugin.startMovement(int type);
   ```

   Parameter Description :

   Type is the same as "Heart Rate". Type is the same.

3. **Sets training state**

   ```
   _blePlugin.setMovementState(MovementHeartRateStateType);
   ```

   Parameter Description :

   MovementHeartRateStateType：

   | value             | value type | value description  |
   | ----------------- | ---------- | ------------------ |
   | MOVEMENT_PAUSE    | byte       | -2，pause state    |
   | MOVEMENT_CONTINUE | byte       | -3，continue state |
   | MOVEMENT_COMPLETE | byte       | -1，end state      |


### **2.37 Protocol version**

**Gets the protocol version**

```dart
String version=await _blePlugin.getProtocolVersion;
```

Callback Description:

| callback value | callback value type | callback value description                                  |
| -------------- | ------------------- | ----------------------------------------------------------- |
| version        | String              | The current protocol version can be divided into V1 and V2. |

### **2.38 Body temperature**

1. **Sets listener of temperature measurement results**

   Set the monitoring of body temperature measurement results to return the corresponding data of body temperature.

   ```dart
   _blePlugin.tempChangeEveStm.listen(
     (TempChangeBean event) {
       // Do something with new state
     });
   ```

   Callback Description(event):

   TempChangeBean：

   | callback value | callback value type | callback value description                                   |
   | -------------- | ------------------- | ------------------------------------------------------------ |
   | enable         | bool                | whether to continue measuring<br />true:enable  false:disable |
   | temp           | double              | real-time body temperature                                   |
   | state          | bool                | temperature measurement status true:measuring  false:end of measurement |
   | tempInfo       | TempInfo            | Body temperature information                                 |

2. **Start measuring once temperature**

   Start taking temperature.

   The real-time body temperature is obtained through the data stream tempChangeEveStm, and the result is stored in TempChangeBean.temp; the measurement state is obtained through TempChangeEveStm, and the result is stored in TempChangeBean.state.

   ```dart
   String temp = await _blePlugin.startMeasureTemp;
   ```

3. **Stop measuring once temperature**

   ```dart
   _blePlugin.stopMeasureTemp;
   ```

4. **Enable timing temperature measurement**

   When the chronograph measurement is turned on, the watch automatically measures the temperature every half an hour.

   ```dart
   _blePlugin.enableTimingMeasureTemp;
   ```

5. **Disable timing temperature measurement**

   ```dart
   _blePlugin.disableTimingMeasureTemp;
   ```

6. **Gets the timing of temperature measurement status**

   ```dart
    String timingTempState=await _blePlugin.queryTimingMeasureTempState;
   ```

   Callback Description:

   | callback value  | callback value type | callback value description                  |
   | --------------- | ------------------- | ------------------------------------------- |
   | timingTempState | String              | Body temperature timing measurement status. |

7. **Gets the result of timing temperature measurement**

   he measurement state is obtained through tempChangeEveStm, and the result is stored in TempChangeBean.continueTemp.

   ```dart
   _blePlugin.queryTimingMeasureTemp(String TempTimeType);
   ```

   TempTimeType:

   | **TODAY** | **YESTERDAY** |
   | --------- | ------------- |
   | today     | yesterday     |

   TempInfo

   | callback value  | callback value type | callback value description                              |
   | --------------- | ------------------- | ------------------------------------------------------- |
   | type            | TempTimeType        | Body temperature timing measurement status.             |
   | startTime       | long                | Temperature measurement start time                      |
   | tempList        | List<Float>         | Temperature record sheet                                |
   | measureInterval | int                 | Measurement interval (unit: minute, default 30 minutes) |


### 2.39 Display time

1. **Sets display time**

   ```
   _blePlugin.sendDisplayTime(int time);
   ```

   Parameter Description :

   | value | value type | value description                                            |
   | ----- | ---------- | ------------------------------------------------------------ |
   | time  | int        | time is the screen-on time, unit: second, cannot exceed 255. |

2. **Gets display time**

   ```dart
   int displayTime=_blePlugin.queryDisplayTime();
   ```

### **2.40 Hand washing reminder**

1. **Enable hand washing reminder**

   ```dart
    _blePlugin.enableHandWashingReminder(HandWashingPeriodBean info);
   ```

   Parameter Description :

   HandWashingPeriodBean:

   | value       | value type | value description     |
   | ----------- | ---------- | --------------------- |
   | enable      | bool       | Whether to open       |
   | startHour   | int        | Start time hours      |
   | startMinute | int        | Start time in minutes |
   | count       | int        | count                 |
   | period      | int        | period                |

2. **Disable hand washing reminder**

   ```
   _blePlugin.disableHandWashingReminder();
   ```

3. **Gets hand washing reminder**

   ```dart
   HandWashingPeriodBean info= _blePlugin.queryHandWashingReminderPeriod();
   ```

### 2.41 Sets local city

```dart
_blePlugin.sendLocalCity(String city);
```

### **2.42 Temperature system**

1. **Sets temperature system**

   Switch temperature system.

   ```dart
   _blePlugin.sendTempUnit(TempUnit);
   ```

   Parameter Description :

   TempUnit:

   | value      | value type | value description |
   | ---------- | ---------- | ----------------- |
   | CELSIUS    | int        | 0                 |
   | FAHRENHEIT | int        | 1                 |

2. **Query temperature system**

   Query the temperature system. The query result will be obtained through the weatherChangeEveStmlistening stream and saved in the tempUnitChange field.

   ```dart
   _blePlugin.queryTempUnit();
   ```


### **2.43 Brightness**

1. ** Sets brightness**

   ```dart
   _blePlugin.sendBrightness(int brightness);
   ```

   Parameter Description :

   | value      | value type | value description |
   | ---------- | ---------- | ----------------- |
   | brightness | int        | Sets brightness   |

2. **Gets brightness**

   ```dart
   BrightnessBean bean=await _blePlugin.queryBrightness();
   ```


Callback Description:

| allback value | callback value type | callback value description |
| ------------- | ------------------- | -------------------------- |
| current       | int                 | current brightness         |
| max           | int                 | maximum brightness         |

### **2.44 Classic Bluetooth address**

```dart
 String btAddres=await _blePlugin.queryBtAddress();
```

### **2.45 Contacts**

1. **Sets contacts listener**

   Set up a contact listener, and the result is returned via the data stream contactEveStm and stored in "event".

   ```dart
   _blePlugin.contactEveStm.listen(
     (ContactListenBean event) {
        // Do something with new state
     });
   ```

   Callback Description(event):

   ContactListenBean:

   | callback value | callback value type | callback value description                             |
   | -------------- | ------------------- | ------------------------------------------------------ |
   | savedSuccess   | int                 | The return value of the success of saving the contact; |
   | savedFail      | int                 | The return value of the failure to save the contact    |

2. **Check support contacts**

   ```dart
   ContactConfigBean info=_blePlugin.checkSupportQuickContact();
   ```

   Callback Description:

   ContactConfigBean：

   | value     | value type | value description                          |
   | --------- | ---------- | ------------------------------------------ |
   | supported | bool       | Whether symbols are supported, such as ”+“ |
   | count     | int        | Maximum number of contacts                 |
   | width     | int        | The width of the contact avatar            |
   | height    | int        | The height of contact avatar               |

3. **Gets current contacts count**

   ```dart
   int contactCount = _blePlugin.queryContactCount();
   ```

4. **Sets contact information**

   Set the contact, the result is obtained through contactEveStm.

   ```
   _blePlugin.sendContact(ContactBean info);
   ```

   Parameter Description :

   ContactBean:

   | value   | value type | value description         |
   | ------- | ---------- | ------------------------- |
   | id      | int        | The contact id            |
   | width   | int        | The contact avatar width  |
   | height  | int        | The contact avatar height |
   | address | int        | The contact address       |
   | name    | String     | The contact name          |
   | number  | String     | The contact phone number  |
   | avatar  | Uint8List? | The contact avatar        |

   Precautions:

   - The Uint8List? type is a picture type, interacts with the backend, and converts it to a bitmap type at the backend.
   - Contacts sent to the watch face, must have an avatar
   - id has size limit. The maximum value of id can be viewed through count in the return value of _blePlugin.checkSupportQuickContact, and cannot be greater than or equal to the queried value.

5. **Delete contacts information**

   Delete contact information based on contact id.

   ```dart
   _blePlugin.deleteContact(int id);
   ```

### **2.46 Battery Saving**

1. **Sets battery saing listener**

   Set the battery storage listener, the result is returned through the data stream, and saved in "event".

   ```dart
   _blePlugin.batterySavingEveStm.listen(
           (event) {
            // Do something with new state
           });
   ```

   Callback Description（event）：

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | event          | bool                | Batter saving state        |

2. **Sets battery saving state**

   ```dart
   _blePlugin.sendBatterySaving(bool enable);
   ```

3. **Gets battery saving state**

   The query result will be obtained through the batterySavingEveStm monitoring stream and saved in the event field.

   ```dart
    _blePlugin.queryBatterySaving();
   ```


### **2.47 Pill Reminder**

1. **Gets support pill reminder**

   ```
   _blePlugin.queryPillReminder();
   ```

2. **Sets pill reminder**

   ```dart
   _blePlugin.sendPillReminder(PillReminderBean info);
   ```

   Parameter Description :

   PillReminderBean:

   | value            | value type                              | value description                         |
   | ---------------- | --------------------------------------- | ----------------------------------------- |
   | id               | int                                     | The pill id                               |
   | dateOffset       | int                                     | Start taking medicine in a few            |
   | name             | String                                  | The pill name                             |
   | repeat           | int                                     | The take medicine every few  days         |
   | reminderTimeList | List<PillReminderBean.ReminderTimeBean> | The time point and dosage of the medicine |

   PillReminderInfo.ReminderTimeBean:

   | value | value type | value description                             |
   | ----- | ---------- | --------------------------------------------- |
   | time  | int        | Medication time(For example, 100 is 01:40 am) |
   | count | int        | The dose                                      |

3. **Delete pill reminder**

   Delete reminder message based on pill reminder id

   ```dart
   _blePlugin.deletePillReminder(int id);
   ```

4. **Clear pill reminder**

   ```dart
   _blePlugin.clearPillReminder();
   ```


### **2.48 Tap to wake**

1. **Gets tap to wake state**

   Gets whether it is in the wake-up state. If the result is true, it means that it is in the awake state, otherwise, it is not awake.

   ```dart
   bool wakeState=await _blePlugin.queryWakeState();
   ```

2. **Sets tap to wake state**

   Sets wake state.

   ```
    _blePlugin.sendWakeState(bool enable);
   ```

### 2.49 **Training**

1. **Sets training listener**

   Set up a training listener, the results are returned through the data stream, and saved in "event".

   ```dart
   _blePlugin.trainingEveStm.listen(
           (TrainBean event) {
               // Do something with new state
           });
   ```

   Callback Description（event）：

   TrainBean

   | callback value   | callback value type          | callback value description      |
   | ---------------- | ---------------------------- | ------------------------------- |
   | historyTrainList | List<CRPHistoryTrainingInfo> | Historical training information |
   | trainingInfo     | CRPTrainingInfo              | Training information            |

   CRPHistoryTrainingInfo

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | startTime      | long                | Training start time        |
   | type           | int                 | The training type          |

   CRPTrainingInfo

   | callback value | callback value type | callback value description |
   | -------------- | ------------------- | -------------------------- |
   | type           | int                 | The training type          |
   | startTime      | long                | Training start time        |
   | endTime        | long                | Training end time          |
   | validTime      | int                 | Training duration          |
   | steps          | int                 | Steps                      |
   | distance       | int                 | Distance                   |
   | calories       | int                 | Calories                   |
   | hrList         | List<Integer>       |                            |

2. **Gets History Training**

   Gets the training records stored in the watch. The query result will be obtained through trainingEveStm listening stream and saved in the historyTrainList field.

   ```dart
   _blePlugin.queryHistoryTraining();
   ```

3. **Gets Training Detail**

   Gets detailed data for a training. The query result will be obtained through the trainingEveStm listening stream and saved in the trainingInfo field

   ```dart
   _blePlugin.queryTraining(int id);
   ```

   Parameter Description :

   | value | value type | value description          |
   | ----- | ---------- | -------------------------- |
   | id    | int        | id is the id of a training |

