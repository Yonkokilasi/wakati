import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_clock_helper/model.dart';

class WakatiClock extends StatefulWidget {
  const WakatiClock(this.model);

  final ClockModel model;
  _WakatiState createState() => _WakatiState();
}

class _WakatiState extends State<WakatiClock> {
  Timer _timer;
  DateTime dateTime;
  bool is24 = ClockModel().is24HourFormat;

  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
  }

   void setTime(Timer timer) {
    setState(() {
      dateTime = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child:Text("The time is ${dateTime.hour} : ${dateTime.minute} : ${dateTime.second}")),
    );
  }
}
