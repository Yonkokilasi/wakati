import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wakati_clock/utils/strings.dart';

// Used to build the center widget with the time
Center buildTimeWidget(String formattedHour, String formattedMinute) {
  return Center(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$formattedHour",
          style: TextStyle(fontSize: 100, fontFamily: primaryFont),
        ),
        Text(
          ":",
          style: TextStyle(fontSize: 50, fontFamily: primaryFont),
        ),
        Text(
          "$formattedMinute",
          style: TextStyle(fontSize: 50, fontFamily: primaryFont),
        ),
      ],
    ),
  );
}

// Builds the date section on the top right
Positioned buildDateSection(DateTime theTimeNow,Color color) {
  var today = theTimeNow != null ? DateFormat.E().format(theTimeNow) : '';
  var dayOfTheWeek =
      theTimeNow != null ? DateFormat.d().format(theTimeNow) : 'Today';
  return Positioned(
    right: 0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Opacity(
        opacity: 0.6,
        child: Container(
          height: 110,
          color: color,
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

// Builds the location section on the bottom left
Widget buildLocationSection(String currentLocation) {
  return Positioned(
    bottom: 0,
    right: 0,
    child: Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15, right: 15),
        child: Text(
          "$currentLocation",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: primaryFont),
        ),
      ),
    ),
  );
}

// Builds the weather section
Widget buildWeatherSection(
    double deviceWidth, double deviceHeight, num temparature,String unitString) {
  var formattedTemp = temparature.truncate();
  return Positioned(
    bottom: 0,
    child: Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 15),
      child: Container(
        width: deviceWidth / 3,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "$formattedTemp",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        fontFamily: primaryFont),
                  ),
                ),
                Text(
                  "$unitString",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: primaryFont),
                )
              ],
            ),
            Text(
              "$weatherPrefix ${formattedTemp + 4} $unitString",
              style: TextStyle(
                  fontSize: 14,
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
Widget buildBottomContainer(double deviceHeight, double deviceWidth,Color color) {
  return Positioned(
      bottom: 0,
      child: ClipRRect(
        child: Opacity(
          opacity: 0.4,
          child: Container(
            height: deviceHeight / 4,
            width: deviceWidth,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.5],
                    colors: [Colors.transparent, color])),
          ),
        ),
      ));
}
