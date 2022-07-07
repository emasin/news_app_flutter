import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void init() {
    _count = 0;
    notifyListeners();
  }

  void set(int value) {
    _count = value;
    notifyListeners();
  }

}