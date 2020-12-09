import 'dart:ui';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart' hide Offset;

import '../controller.dart';
import '../event.dart';

class CurrentTimeIndicatorPainter<E extends Event> extends CustomPainter {
  CurrentTimeIndicatorPainter({
    @required this.controller,
    @required Color color,
    this.circleRadius = 4,
    Listenable repaint,
  })  : assert(controller != null),
        assert(color != null),
        _paint = Paint()..color = color,
        assert(circleRadius != null),
        super(
          repaint: Listenable.merge([
            controller.scrollControllers.pageListenable,
            repaint,
          ]),
        );

  final TimetableController<E> controller;
  final Paint _paint;
  final double circleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final dateWidth = size.width;

    final temporalOffset = 0.0;
    final left = temporalOffset;

    final actualLeft = left.coerceAtLeast(0);

    var time = (DateTime.now().hour * 60 * 60) +
        (DateTime.now().minute * 60) +
        DateTime.now().second;

    // final time = LocalTime.currentClockTime().timeSinceMidnight.inSeconds;
    final y = (time / TimeConstants.secondsPerDay) * size.height;

    final radius = lerpDouble(circleRadius, 0, (actualLeft - left) / dateWidth);
    canvas
      ..drawCircle(Offset(actualLeft, y), radius, _paint)
      ..drawLine(Offset(actualLeft + radius, y), Offset(size.width, y), _paint);
  }

  @override
  bool shouldRepaint(CurrentTimeIndicatorPainter oldDelegate) =>
      _paint.color != oldDelegate._paint.color ||
      circleRadius != oldDelegate.circleRadius;
}
