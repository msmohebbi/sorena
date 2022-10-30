import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Index with ChangeNotifier {
  int _index = 0;
  int get index {
    return _index;
  }

  void changeIndex(int newIndex) {
    _index = newIndex;
    notifyListeners();
  }
}
