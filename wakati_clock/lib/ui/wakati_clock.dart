import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:wakati_clock/utils/strings.dart';

class WakatiClock extends StatefulWidget {
  const WakatiClock(this.model);

  final ClockModel model;
  _WakatiState createState() => _WakatiState();
}

class _WakatiState extends State<WakatiClock> {
  Timer _timer;
  DateTime _theTimeNow;
  String _formattedTime;
  static ClockModel _sampleData = ClockModel();
  String _currentLocation = _sampleData.location;
  num _temparature = _sampleData.temperature;
  var minute;
  @override
  void initState() {
    super.initState();
    _theTimeNow = new DateTime.now();
    _timer = new Timer.periodic(const Duration(minutes: 1), setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      _theTimeNow = new DateTime.now();
      _formattedTime = DateFormat.jm().format(_theTimeNow);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // returns the background image based on the current weather condition
  String get _getBackgroundImage {
    var currentWeather = _sampleData.weatherCondition;
    switch (currentWeather) {
      case WeatherCondition.sunny:
        return sunnyBackground;
      case WeatherCondition.cloudy:
        // TODO: Handle this case.
        break;
      case WeatherCondition.foggy:
        // TODO: Handle this case.
        break;
      case WeatherCondition.rainy:
        // TODO: Handle this case.
        break;
      case WeatherCondition.snowy:
        // TODO: Handle this case.
        break;
      case WeatherCondition.thunderstorm:
        // TODO: Handle this case.
        break;
      case WeatherCondition.windy:
        return windyBackground;
        break;
      default:
        return sunnyBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      width: deviceWidth,
      height: deviceHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(_getBackgroundImage), fit: BoxFit.cover)),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text("$_formattedTime"),
          ),
          _buildDateSection(),
          _buildBottomContainer(deviceHeight, deviceWidth),
          _buildWeatherSection(deviceWidth, deviceHeight),
          _buildLocationSection(),
        ],
      ),
    );
  }

  Positioned _buildDateSection() {
    var today = DateFormat.E().format(_theTimeNow);
    var dayOfTheWeek = DateFormat.d().format(_theTimeNow);
    return Positioned(
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Opacity(
          opacity: 0.6,
          child: Container(
            width: 90,
            height: 105,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("$today",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                  Text("$dayOfTheWeek",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 15),
          child: Text(
            "$_currentLocation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection(double deviceWidth, double deviceHeight) {
    var formattedTemp = _temparature.truncate();
    return Positioned(
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15),
        child: Container(
          width: deviceWidth / 4,
          child: Column(
            children: <Widget>[
              Text(
                "$formattedTemp",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
              ),
              Text("Probably feels like ${formattedTemp + 4}")
            ],
          ),
        ),
      ),
    );
  }

  // Background for bottom items
  Widget _buildBottomContainer(double deviceHeight, double deviceWidth) {
    return Positioned(
        bottom: 0,
        child: ClipRRect(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              height: deviceHeight / 4,
              width: deviceWidth,
              color: Colors.white,
            ),
          ),
        ));
  }
}
