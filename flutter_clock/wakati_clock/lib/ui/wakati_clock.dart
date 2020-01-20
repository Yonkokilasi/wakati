import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:wakati_clock/ui/wakati_clock_widgets.dart';
import 'package:wakati_clock/utils/strings.dart';

class WakatiClock extends StatefulWidget {
  const WakatiClock(this.model);

  final ClockModel model;

  _WakatiState createState() => _WakatiState();
}

class _WakatiState extends State<WakatiClock> {
  Timer _timer;
  DateTime _theTimeNow;
  String _formattedHour = "";
  String _formattedMinute = "";
  static ClockModel _sampleData;
  String _currentLocation;
  var _condition;
  var _unitString;
  num _temparature;
  var minute;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateModel();
    _sampleData = ClockModel();
    _temparature = _sampleData.temperature;
    _currentLocation = _sampleData.location;
    _theTimeNow = new DateTime.now();
    _timer = new Timer.periodic(const Duration(seconds: 1), setTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WakatiClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  void setTime(Timer timer) {
    setState(() {
      _theTimeNow = new DateTime.now();
      _formattedHour = DateFormat.H().format(_theTimeNow);
      var minute = int.parse(DateFormat.m().format(_theTimeNow));

      // add 0 when $minute are below 10 for example 09
      if (minute < 10) {
        _formattedMinute = "0$minute";
      } else {
        _formattedMinute = "$minute";
      }
    });
  }

  // Cause the clock to rebuild when the model changes.
  void _updateModel() {
    setState(() {
      _temparature = widget.model.temperature;
      _condition = widget.model.weatherCondition;
      _currentLocation = widget.model.location;
      _unitString = widget.model.unitString;
    });
  }

  // returns the background image based on the current weather condition and the theme mode
  String get _getBackgroundImage {
    var result;
    var isLightmode =
        Theme.of(context).brightness == Brightness.light ? true : false;

    result = sunnyBackground;
    switch (_condition) {
      case WeatherCondition.sunny:
        result = isLightmode ? sunnyBackground : nightBackground;
        break;
      case WeatherCondition.cloudy:
        result = isLightmode ? cloudyBackground : nightCloudyBackground;
        break;
      case WeatherCondition.rainy:
        result = rainyBackground;
        break;
      case WeatherCondition.thunderstorm:
        result = rainyBackground;
        break;
      case WeatherCondition.windy:
        result = isLightmode ? neutralBackground : nightCloudyBackground;
        break;
      case WeatherCondition.foggy:
        result = foggyBackground;
        break;
      default:
        return neutralBackground;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: deviceWidth,
        height: deviceHeight,

        // background image
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(_getBackgroundImage), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            buildTimeWidget(_formattedHour, _formattedMinute),
            buildDateSection(_theTimeNow, getColor()),
            buildBottomContainer(deviceHeight, deviceWidth, getColor()),
            buildWeatherSection(
                deviceWidth, deviceHeight, _temparature, _unitString),
            buildLocationSection(_currentLocation),
          ],
        ),
      ),
    );
  }

  // Used to return a color based on the theme mode
  Color getColor() {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;
  }
}
