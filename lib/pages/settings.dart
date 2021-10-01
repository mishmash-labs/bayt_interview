import 'package:bayt/utils/translate_keys.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
      appBar: AppBar(
        title: Text(translate(Keys.settings)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Radio(
                  value: 'en',
                  groupValue: localizationDelegate.currentLocale.languageCode,
                  onChanged: (String? val) {
                    changeLocale(context, val);
                  }),
              const Text("English"),
              Radio(
                  value: 'es',
                  groupValue: localizationDelegate.currentLocale.languageCode,
                  onChanged: (String? val) {
                    changeLocale(context, val);
                  }),
              const Text("Spanish"),
            ],
          ),
          ListTile(
              title: Text(
                translate(Keys.logout),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }),
        ],
      ),
    );
  }
}
