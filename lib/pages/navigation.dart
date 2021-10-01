import 'package:bayt/utils/translate_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../utils/nav_provider.dart';
import 'checkout.dart';
import 'home.dart';
import 'settings.dart';

class NavPage extends StatelessWidget {
  const NavPage({key}) : super(key: key);

  static final _pages = <Widget>[
    const HomePage(),
    const CheckoutPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final navWatcher = context.watch<NavigationProvider>();

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navWatcher.pageController,
        children: _pages,
      ),
      // persistentFooterButtons: <Widget>[
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       MyTabButton(
      //         index: 0,
      //         label: translate(Keys.home),
      //         navWatcher: navWatcher,
      //       ),
      //       MyTabButton(
      //         index: 1,
      //         label: translate(Keys.checkout),
      //         navWatcher: navWatcher,
      //       ),
      //       MyTabButton(
      //         index: 2,
      //         label: translate(Keys.settings),
      //         navWatcher: navWatcher,
      //       ),
      //     ],
      //   )
      // ],
      bottomNavigationBar: BottomNavBar(navWatcher: navWatcher),
    );
  }
}

class MyTabButton extends StatelessWidget {
  const MyTabButton(
      {Key? key,
      required this.index,
      required this.label,
      required this.navWatcher})
      : super(key: key);
  final int index;
  final String label;
  final NavigationProvider navWatcher;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: navWatcher.currentIndex == index
              ? MaterialStateProperty.all<Color>(
                  Theme.of(context).indicatorColor.withOpacity(0.5))
              : MaterialStateProperty.all<Color>(Colors.grey)),
      onPressed: () {
        navWatcher.changeTab(index);
      },
      child: Text(label),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    key,
    required this.navWatcher,
  }) : super(key: key);

  final NavigationProvider navWatcher;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: navWatcher.changeTab,
        currentIndex: navWatcher.currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: translate(Keys.home)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: translate(Keys.checkout)),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: translate(Keys.settings)),
        ],
      );
}
