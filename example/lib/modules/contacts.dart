import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:logger/logger.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import 'contact_list_page.dart';

class ContactsPage extends StatefulWidget {
  final MoYoungBle blePlugin;

  const ContactsPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ContactsPage> createState() {
    return _ContactsPage(blePlugin);
  }
}

class _ContactsPage extends State<ContactsPage> {
  final MoYoungBle _blePlugin;
  ContactConfigBean? _contactConfigBean;
  String _contactStr = 'sendContact()';
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Logger logger = Logger();
  int _progress = -1;
  int _error = -1;
  int _savedSuccess = -1;
  int _savedFail = -1;

  _ContactsPage(this._blePlugin);

  @override
  void initState() {
    super.initState();
    subscriptStream();
  }

  void subscriptStream() {
    _streamSubscriptions.add(
      _blePlugin.contactAvatarEveStm.listen(
            (FileTransBean event) {
          setState(() {
            logger.d('contactAvatarEveStm===' + event.progress.toString());
            _progress = event.progress;
            _error = event.error;
          });
        },
      ),
    );

    _streamSubscriptions.add(
      _blePlugin.contactEveStm.listen(
            (ContactListenBean event) {
          setState(() {
            logger.d("ContactEveStm======" + event.toString());
            _savedSuccess = event.savedSuccess;
            _savedFail = event.savedFail;
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
              title: const Text("Contacts Page"),
            ),
            body: Center(
                child: ListView(children: <Widget>[
                  Text("progress: $_progress"),
                  Text("error: $_error"),
                  Text("savedSuccess: $_savedSuccess"),
                  Text("savedFail: $_savedFail"),
                  ElevatedButton(
                      onPressed: () async => _contactConfigBean =
                      await _blePlugin.checkSupportQuickContact,
                      child: const Text("checkSupportQuickContact()")),
                  ElevatedButton(
                      onPressed: () => _blePlugin.queryContactCount,
                      child: const Text("queryContactCount()")),
                  ElevatedButton(
                      onPressed: () {
                        if (_contactConfigBean != null) {
                          selectContact();
                        }
                      },
                      child: Text(_contactStr)),
                  ElevatedButton(
                      onPressed: () {
                        if (_contactConfigBean != null) {
                          sendContactAvatar();
                        }
                      },
                      child: Text("sendContactAvatar")),
                  ElevatedButton(
                      onPressed: () => _blePlugin.deleteContact(0),
                      child: const Text("deleteContact(0)")),
                  ElevatedButton(
                      onPressed: () => _blePlugin.deleteContactAvatar(0),
                      child: const Text("deleteContactAvatar(0)")),
                  ElevatedButton(
                      onPressed: () => _blePlugin.clearContact(),
                      child: const Text("clearContact()")),
                ]))));
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlutterContactsExample(pageContext: context),
        ));

    if (int.parse(contact.id) < _contactConfigBean!.count) {
      _blePlugin.sendContact(ContactBean(
        id: 0,
        width: _contactConfigBean!.width,
        height: _contactConfigBean!.height,
        address: 1,
        name: contact.name.first,
        number: contact.phones.first.number,
        avatar: contact.thumbnail,
        timeout: 30,
      ));
    }

    if (!mounted) {
      return;
    }

    setState(() {
      String name = contact.name.first;
      String number = contact.phones.first.number;
      _contactStr = '$name, $number';
    });
  }

  Future<void> sendContactAvatar() async {
    final Contact contact = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlutterContactsExample(pageContext: context),
        ));

    if (int.parse(contact.id) < _contactConfigBean!.count) {
      _blePlugin.sendContactAvatar(ContactBean(
        id: 0,
        width: _contactConfigBean!.width,
        height: _contactConfigBean!.height,
        address: 1,
        name: contact.name.first,
        number: contact.phones.first.number,
        avatar: contact.thumbnail,
        timeout: 30,
      ));
    }

    if (!mounted) {
      return;
    }

    setState(() {
      String name = contact.name.first;
      String number = contact.phones.first.number;
      _contactStr = '$name, $number';
    });
  }
}