// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'container_hand.dart';
import 'drawn_hand.dart';
import 'dart:math' as math;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
   
    // lock orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFFED254E),
            // Minute hand.
            highlightColor: Color(0xFFF9DC5C),
            // Second hand.
            accentColor: Color(0xFF011936),
            backgroundColor: Color(0xFFC2EABD),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: customTheme.backgroundColor, shape: BoxShape.circle),
          child: Stack(
            children: [
              // Example of a hand drawn with [CustomPainter].
              DrawnHand(
                color: customTheme.primaryColor,
                thickness: 4,
                size: 1,
                isMinute: false,
                angleRadians: _now.second * radiansPerTick,
              ),
              DrawnHand(
                color: customTheme.highlightColor,
                thickness: 12,
                size: 0.9,
                isMinute: false,
                angleRadians: _now.minute * radiansPerTick,
              ),
              // Transform.translate(
              //   offset: getOffset(_now.second * radiansPerTick, 0.1),
              //   child: DrawnHand(
              //     color: customTheme.highlightColor,
              //     thickness: 42,
              //     size: 0.2,
              //     isMinute: true,
              //     angleRadians: _now.second * radiansPerTick,
              //   ),
              // ),
              Transform.translate(
                offset: getOffset(_now.second * radiansPerTick, 0.1),
                child: new CustomPaint(
                  painter: new MinuteHandPainter(
                      minutes: _now.second, seconds: _now.second),
                ),
              ),
              // Example of a hand drawn with [Container].
              ContainerHand(
                color: Colors.transparent,
                size: 0.5,
                angleRadians: _now.hour * radiansPerHour +
                    (_now.minute / 60) * radiansPerHour,
                child: Transform.translate(
                  offset: Offset(0.0, -60.0),
                  child: Container(
                    width: 32,
                    height: 150,
                    decoration: BoxDecoration(
                      color: customTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                  offset: getOffset(_now.minute * radiansPerTick, 1),
                  child: Text("${_now.minute}")),

              Positioned(
                left: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: weatherInfo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Offset getOffset(double angleRadians, double modifier) {
    var size = Size(536.8, 326.7);
    final center = (Offset.zero & size).center;
    final angle = angleRadians - math.pi / 2.0;

    final length = size.shortestSide * 0.5 * modifier;

    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    return position;
  }
}
