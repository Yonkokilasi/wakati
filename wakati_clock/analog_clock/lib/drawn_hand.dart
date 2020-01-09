// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:math';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is drawn with [CustomPainter]
///
/// The hand's length scales based on the clock's size.
/// This hand is used to build the second and minute hands, and demonstrates
/// building a custom hand.
class DrawnHand extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const DrawnHand({
    @required Color color,
    @required this.thickness,
    @required double size,
    @required double angleRadians,
    bool isMinute,
  })  : assert(color != null),
        assert(thickness != null),
        assert(size != null),
        assert(angleRadians != null),
        super(
            color: color,
            size: size,
            angleRadians: angleRadians,
            isMinute: isMinute);

  /// How thick the hand should be drawn, in logical pixels.
  final double thickness;
  Widget _buildHand() {
    return CustomPaint(
      painter: HandPainter(
          handSize: size,
          lineWidth: thickness,
          angleRadians: angleRadians,
          color: color,
          isMinute: isMinute),
    );
  }

  @override
  Widget build(BuildContext context) {
    var sizedBox = SizedBox.expand(child: _buildHand());
    return Center(
      child: sizedBox,
    );
  }
}

/// [CustomPainter] that draws a clock hand.
class HandPainter extends CustomPainter {
  HandPainter({
    @required this.handSize,
    @required this.lineWidth,
    @required this.angleRadians,
    @required this.color,
    this.isMinute,
  })  : assert(handSize != null),
        assert(lineWidth != null),
        assert(angleRadians != null),
        assert(color != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double handSize;
  double lineWidth;
  double angleRadians;
  bool isMinute;
  Offset position;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    
    if (isMinute) {
      Offset centerPoint = Offset(100, 0);
      double triangleA = 165; // this the dimension of triangle's side
      double triangleR = triangleA /sqrt(3); // this the distance between the center of triangle/circle to corner of triangle
    
      Path path = Path();

      double x1Point = position.dx + triangleR * cos(3 * pi / 2);
      double y1Point = centerPoint.dy + triangleR * sin(3 * pi / 2);
      path.moveTo(x1Point, y1Point);

      // left angle
      double x2Point = centerPoint.dx +
          triangleR * cos((3 * pi / 2) - Angle.fromDegrees(120).radians);
      // right angle
      double y2Point = centerPoint.dy +
          triangleR * sin((3 * pi / 2) - Angle.fromDegrees(120).radians);
      path.lineTo(x2Point, y2Point);

      // top angle
      double x3Point = centerPoint.dx +
          triangleR * cos((3 * pi / 2) + Angle.fromDegrees(120).radians);
      double y3Point = centerPoint.dy +
          triangleR * sin((3 * pi / 2) + Angle.fromDegrees(120).radians);
      path.lineTo(x3Point, y3Point);

      path.close();

      canvas.drawPath(
          path,
          Paint()
            ..color = Colors.deepOrange
            ..style = PaintingStyle.fill);

      canvas.save();
      canvas.restore();
    } else {
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.square;

      canvas.drawLine(center, position, linePaint);
    }
  }

  @override
  bool shouldRepaint(HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
