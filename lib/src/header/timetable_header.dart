import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import 'all_day_events.dart';
import 'multi_date_header.dart';
import 'week_indicator.dart';

class TimetableHeader<E extends Event> extends StatelessWidget {
  const TimetableHeader({
    Key key,
    @required this.controller,
    @required this.allDayEventBuilder,
    this.onEventBackgroundTap,
    this.leadingHeaderBuilder,
    this.dateHeaderBuilder,
    this.allowSrcoll = false,
    this.onPageChanged,
    @required this.lengthOfStaff,
    @required this.callBackStaffChange,
  })  : assert(controller != null),
        assert(allDayEventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final AllDayEventBuilder<E> allDayEventBuilder;
  final OnEventBackgroundTapCallback onEventBackgroundTap;
  final HeaderWidgetBuilder leadingHeaderBuilder;
  final HeaderWidgetBuilder dateHeaderBuilder;

  final int lengthOfStaff;

  final Widget Function(BuildContext context, int index, LocalDate date)
      callBackStaffChange;

  final bool allowSrcoll;

  final Function onPageChanged;

  @override
  Widget build(BuildContext context) {
    // Like [WeekYearRules.iso], but with a variable first day of week.
    final weekYearRule =
        WeekYearRules.forMinDaysInFirstWeek(4, controller.firstDayOfWeek);

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: hourColumnWidth,
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: MultiDateHeader(
                controller: controller,
                builder: dateHeaderBuilder,
                lengthOfStaff: lengthOfStaff,
                callBackStaffChange: callBackStaffChange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
