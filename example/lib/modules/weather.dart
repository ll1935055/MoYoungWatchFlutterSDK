import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class WeatherPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const WeatherPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<WeatherPage> createState() {
    return _WeatherPage(blePlugin);
  }
}

class _WeatherPage extends State<WeatherPage> {
  final MoYoungBle _blePlugin;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int _weather = -1;

  _WeatherPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.weatherChangeEveStm.listen(
            (int event) {
          setState(() {
            _weather = event;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Weather Page"),
            ),
            body: Center(
              child: ListView(
                children: [
                  Text("weather：$_weather"),

                  ElevatedButton(
                      child: const Text('sendTodayWeather()'),
                      onPressed: () => _blePlugin.sendTodayWeather(
                          TodayWeatherBean(
                              city: "111",
                              lunar: "111",
                              festival: "111",
                              pm25: 111,
                              temp: 111,
                              weatherId: 111))),
                  ElevatedButton(
                      child: const Text('sendFutureWeather()'),
                      onPressed: () => _blePlugin.sendFutureWeather(
                              getFutureWeathers()
                          )),
                ],
              ),
            )
        )
    );
  }

  FutureWeatherListBean getFutureWeathers() {
    FutureWeatherBean futureWeatherBean1 = FutureWeatherBean(
        weatherId: 5,
        lowTemperature: 10,
        highTemperature: 30);
    FutureWeatherBean futureWeatherBean2 = FutureWeatherBean(
        weatherId: 6,
        lowTemperature: 11,
        highTemperature: 21);

    List<FutureWeatherBean> futureList = [];
    futureList.add(futureWeatherBean1);
    futureList.add(futureWeatherBean2);

    return FutureWeatherListBean(future: futureList);
  }
}
