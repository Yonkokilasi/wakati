import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class StateModel with ChangeNotifier {
  Timer _timer;
  DateTime _dateTime = DateTime.now();
  var hour;
  var _second = DateFormat('ss').format(DateTime.now());
  var _minute = 0;

  get currentTime => _dateTime;

  get second => _second;

  get number => _minute;

  set second(DateTime dateTime) {
    //print("********** updating seconds to $_second");
    _second = DateFormat('ss').format(dateTime);
    notifyListeners();
  }

  set number(int val) {
    _minute = val;
    notifyListeners();
  }

  set dateTime(DateTime dateTime) {
    //print("********* updating time ");
    _dateTime = dateTime;
    notifyListeners();
  }

  void _onTick() {
    dateTime = DateTime.now();
    second = _dateTime;
    notifyListeners();
    updateTime();
  }

  // method to update time
  // will be called every minute
  void updateTime() {
    // _timer = _timer = Timer(
    //   Duration(minutes: 1) -
    //       Duration(seconds: _dateTime.second) -
    //       Duration(milliseconds: _dateTime.millisecond),
    //   updateTime,
    // );
    _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _onTick);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
