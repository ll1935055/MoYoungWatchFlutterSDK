import 'package:flutter/material.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

class UserInfoPage extends StatefulWidget {
  MoYoungBle blePlugin;

  UserInfoPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<UserInfoPage> createState() {
    return _userInfoPage(blePlugin);
  }
}

class _userInfoPage extends State<UserInfoPage> {
  final MoYoungBle _blePlugin;

  _userInfoPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        title: const Text("UserInfoPage"),
    ),
    body: Center(
      child: ListView(
        children: [
          ElevatedButton(
              child: const Text('sendUserInfo()-MALE'),
              onPressed: () => _blePlugin.sendUserInfo(UserBean(
                  weight: 50,
                  height: 180,
                  gender: UserBean.male,
                  age: 30))),
          ElevatedButton(
              child: const Text('sendUserInfo()-FEMALE'),
              onPressed: () => _blePlugin.sendUserInfo(UserBean(
                  weight: 50,
                  height: 170,
                  gender: UserBean.female,
                  age: 31))),
          ElevatedButton(
              child: const Text('sendStepLength(5)'),
              onPressed: () => _blePlugin.sendStepLength(5)),
        ],
      ),
    )
    ));
  }
}