import 'package:flutter/material.dart';

import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wakati_clock/objects/state.dart';

class WakatiClock extends StatefulWidget {
  const WakatiClock(this.model);

  final ClockModel model;
  _WakatiState createState() => _WakatiState();
}

class _WakatiState extends State<WakatiClock> {
  @override
  Widget build(BuildContext context) {
    print("********* build method");
    var provider = Provider.of<StateModel>(context);
    // final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
    //     .format(provider.currentTime);
    final minute = DateFormat('mm').format(provider.currentTime);
    final seconds = provider.second;
    return Container(
        child: Column(
      children: <Widget>[
        Text("here we are ${provider.number}"),
        MaterialButton(
          child: Text("Set to 3"),
          color: Colors.red,
          onPressed: () => provider.number = 3,
        ),
        MaterialButton(
          child: Text("Set to 4"),
          color: Colors.red,
          onPressed: () => provider.number = 4,
        )
      ],
    ));
  }
}
