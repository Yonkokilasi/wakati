import 'package:flutter/material.dart';

import 'package:flutter_clock_helper/model.dart';

class WakatiClock extends StatefulWidget {
 
  const WakatiClock(this.model);

  final ClockModel model;
  _WakatiState createState() => _WakatiState();
}

class _WakatiState extends State<WakatiClock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(),
    );
  }
}
