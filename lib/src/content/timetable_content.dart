import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import '../utils/vertical_zoom.dart';
import 'date_hours_painter.dart';
import 'multi_date_content.dart';

class TimetableContent<E extends Event> extends StatelessWidget {
  const TimetableContent({
    Key key,
    @required this.controller,
    @required this.eventBuilder,
    @required this.lengthOfStaff,
    @required this.callBackStaffChange,
    this.onPageChanged,
    this.canScroll = false,
    this.allowScroll = false,
    this.onEventBackgroundTap,
  })  : assert(controller != null),
        assert(eventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final bool canScroll;
  final EventBuilder<E> eventBuilder;
  final OnEventBackgroundTapCallback onEventBackgroundTap;
  final int lengthOfStaff;

  final Widget Function(BuildContext context, int index, LocalDate date)
      callBackStaffChange;
  final Function onPageChanged;

  final bool allowScroll;
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;

    return VerticalZoom(
      canScroll: canScroll,
      initialZoom: controller.initialTimeRange.asInitialZoom(),
      minChildHeight:
          (timetableTheme?.minimumHourHeight ?? 16) * TimeConstants.hoursPerDay,
      maxChildHeight:
          (timetableTheme?.maximumHourHeight ?? 64) * TimeConstants.hoursPerDay,
      child: Row(
        children: <Widget>[
          Container(
            width: hourColumnWidth,
            padding: EdgeInsets.only(right: 12),
            child: CustomPaint(
              painter: DateHoursPainter(
                textStyle: timetableTheme?.hourTextStyle ??
                    theme.textTheme.caption.copyWith(
                      color: context.theme.disabledOnBackground,
                    ),
                textDirection: context.directionality,
              ),
              size: Size.infinite,
            ),
          ),
          Expanded(
            child: MultiDateContent<E>(
              controller: controller,
              eventBuilder: eventBuilder,
              onEventBackgroundTap: onEventBackgroundTap,
              lengthOfStaff: lengthOfStaff,
              callBackStaffChange: callBackStaffChange,
              allowScroll: allowScroll,
              onPageChanged: onPageChanged,
            ),
          ),
        ],
      ),
    );
  }
}
