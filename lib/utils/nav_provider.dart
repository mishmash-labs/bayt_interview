import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  NavigationProvider(this._currentIndex) {
    _pageController = PageController(initialPage: currentIndex);
  }

  int _currentIndex;
  late PageController _pageController;

  int get currentIndex => _currentIndex;

  PageController get pageController => _pageController;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeTab(int tab) {
    currentIndex = tab;
    _pageController.animateToPage(
      tab,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
