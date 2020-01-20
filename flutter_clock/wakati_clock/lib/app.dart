import 'package:flutter/material.dart';
import 'package:wakati_clock/ui/wakati_clock.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_clock_helper/customizer.dart';

class WakatiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => WakatiClock(model));
  }
}
