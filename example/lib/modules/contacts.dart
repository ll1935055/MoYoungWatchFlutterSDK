import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:moyoung_ble_plugin/moyoung_ble.dart';

import 'contact_list_page.dart';

class ContactsPage extends StatefulWidget {
  MoYoungBle blePlugin;

  ContactsPage({
    Key? key,
    required this.blePlugin,
  }) : super(key: key);

  @override
  State<ContactsPage> createState() {
    return _contactsPage(blePlugin);
  }
}

class _contactsPage extends State<ContactsPage> {
  final MoYoungBle _blePlugin;
  ContactConfigBean? _contactConfigBean;
  String _contactStr = 'sendContact()';

  _contactsPage(this._blePlugin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text("ContactsPage"),
            ),
            body: Center(child: ListView(children: <Widget>[
              ElevatedButton(
                  onPressed: () async =>
                  _contactConfigBean =
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
                  onPressed: () => _blePlugin.deleteContact(7),
                  child: const Text("deleteContact(7)")),
            ])
            )
        )
    );
  }

  Future<void> selectContact() async {
    final Contact contact = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => FlutterContactsExample(context),
    )
    );

    if (int.parse(contact.id) < _contactConfigBean!.count) {
      _blePlugin.sendContact(ContactBean(
        id: int.parse(contact.id),
        width: _contactConfigBean!.width,
        height: _contactConfigBean!.height,
        address: 1,
        name: contact.name.first,
        number: contact.phones.first.number,
        avatar: contact.thumbnail,
        timeout: 30,
      ));
    }

    if (!mounted) return;

    setState(() {
      String name = contact.name.first;
      String number = contact.phones.first.number;
      _contactStr = '$name, $number';
    });
  }
}