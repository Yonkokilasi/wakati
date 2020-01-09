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
  String _formattedHour = "";
  String _formattedMinute = "";
  static ClockModel _sampleData;
  String _currentLocation;

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

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
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
        result = windyBackground;
        break;
      case WeatherCondition.cloudy:
        result = nightBackground;
        break;
      case WeatherCondition.rainy:
        result = rainyBackground;
        break;
      case WeatherCondition.thunderstorm:
        result = rainyBackground;
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

    return Container(
      width: deviceWidth,
      height: deviceHeight,

      // background image
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(_getBackgroundImage), fit: BoxFit.cover)),
      child: Stack(
        children: <Widget>[
          _buildTimeWidget(),
          _buildDateSection(),
          _buildBottomContainer(deviceHeight, deviceWidth),
          _buildWeatherSection(deviceWidth, deviceHeight),
          _buildLocationSection(),
        ],
      ),
    );
  }

  Center _buildTimeWidget() {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$_formattedHour",
            style: TextStyle(fontSize: 100, fontFamily: primaryFont),
          ),
          Text(
            ":",
            style: TextStyle(fontSize: 50, fontFamily: primaryFont),
          ),
          Text(
            "$_formattedMinute",
            style: TextStyle(fontSize: 50, fontFamily: primaryFont),
          ),
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
            height: 110,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$formattedTemp",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        fontFamily: primaryFont),
                  ),
                  Text(
                    "°C",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: primaryFont),
                  )
                ],
              ),
              Text(
                "$weatherPrefix ${formattedTemp + 4} °C",
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
            opacity: 0.3,
            child: Container(
              height: deviceHeight / 4,
              width: deviceWidth,
              color: Colors.white,
            ),
          ),
        ));
  }
}
