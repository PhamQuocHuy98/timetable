import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../date_page_view.dart';
import '../event.dart';
import '../timetable.dart';
import 'date_header.dart';

class MultiDateHeader<E extends Event> extends StatelessWidget {
  const MultiDateHeader({
    Key key,
    @required this.controller,
    @required this.callBackStaffChange,
    @required this.lengthOfStaff,
    this.builder,
  })  : assert(controller != null),
        super(key: key);

  final TimetableController<E> controller;
  final HeaderWidgetBuilder builder;
  final int lengthOfStaff;

  final Widget Function(BuildContext context, int index, LocalDate date)
      callBackStaffChange;

  @override
  Widget build(BuildContext context) {
    return DatePageView(
      controller: controller,
      lengthOfStaff: lengthOfStaff,
      callBackStaffChange: (context, index, date) {
        return callBackStaffChange?.call(context, index, date);
      },
      builder: (context, date) {
        return builder?.call(context, date);
      },
    );
  }
}
