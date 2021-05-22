import 'package:flutter/material.dart';

import 'config.dart';
class Theme with ChangeNotifier{
  static bool _isDark=false;
  Theme()
  {
    if(box.containsKey('currentTheme'))
      {
        _isDark=box.get('currentTheme');
      }
    else
      box.put('currentTheme', _isDark);
  }
  ThemeMode currentTheme(){
    return _isDark?ThemeMode.dark:ThemeMode.light;
  }
  void switchTheme(){
    _isDark=!_isDark;
    box.put('currentTheme', _isDark);
    notifyListeners();
  }
}