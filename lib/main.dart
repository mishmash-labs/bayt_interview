import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';
import 'pages/navigation.dart';
import 'utils/nav_provider.dart';
import 'utils/translate_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  var delegate = await LocalizationDelegate.create(
      preferences: TranslatePreferences(),
      fallbackLocale: 'en',
      supportedLocales: ['en', 'es']);
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    Color primaryColor = Colors.red;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider(0)),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(),
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData.dark().copyWith(
            indicatorColor: primaryColor,
            radioTheme: RadioTheme.of(context).copyWith(
                fillColor: MaterialStateProperty.all<Color>(primaryColor)),
            colorScheme: ThemeData.dark()
                .colorScheme
                .copyWith(secondary: primaryColor, primary: primaryColor),
          ),
          navigatorObservers: [BotToastNavigatorObserver()],
          home: FirebaseAuth.instance.currentUser != null
              ? const NavPage()
              : LoginPage(),
        ),
      ),
    );
  }
}
