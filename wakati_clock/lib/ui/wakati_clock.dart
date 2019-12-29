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
    var result = sunnyBackground;
    switch (currentWeather) {
      case WeatherCondition.sunny:
        result = sunnyBackground;
        break;
      case WeatherCondition.cloudy:
        result = nightBackground;
        break;
      case WeatherCondition.rainy:
        result = rainyBackground2;
        break;
      case WeatherCondition.thunderstorm:
        result = rainyBackground2;
        break;
      case WeatherCondition.windy:
        return windyBackground;
        break;
      default:
        return sunnyBackground;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    var _currentTime = _formattedTime != null ? _formattedTime : 'now';
    return Container(
      width: deviceWidth,
      height: deviceHeight,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(_getBackgroundImage), fit: BoxFit.cover)),
      child: Stack(
        children: <Widget>[
          Center(
            child: Text(
              "$_currentTime",
              style: TextStyle(fontSize: 50, fontFamily: primaryFont),
            ),
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
    var today = _theTimeNow != null ? DateFormat.E().format(_theTimeNow) : '';
    var dayOfTheWeek =
        _theTimeNow != null ? DateFormat.d().format(_theTimeNow) : 'Today';
    return Positioned(
      right: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Opacity(
          opacity: 0.6,
          child: Container(
            height: 125,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text("$today",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          fontFamily: secondaryFont)),
                  Text("$dayOfTheWeek",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: primaryFont)),
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
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: primaryFont),
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
        padding: const EdgeInsets.only(left: 5, bottom: 15),
        child: Container(
          width: deviceWidth / 3,
          child: Column(
            children: <Widget>[
              Text(
                "$formattedTemp",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    fontFamily: primaryFont),
              ),
              Text(
                "$weatherPrefix ${formattedTemp + 4}",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: secondaryFont,
                    fontWeight: FontWeight.w700),
              )
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
