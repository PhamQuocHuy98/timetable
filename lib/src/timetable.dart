import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_machine/time_machine.dart';

import 'all_day.dart';
import 'content/timetable_content.dart';
import 'controller.dart';
import 'event.dart';
import 'header/timetable_header.dart';
import 'theme.dart';

typedef EventBuilder<E extends Event> = Widget Function(E event);
typedef AllDayEventBuilder<E extends Event> = Widget Function(
  BuildContext context,
  E event,
  AllDayEventLayoutInfo info,
);

/// Signature for [Timetable.leadingHeaderBuilder] and
/// [Timetable.dateHeaderBuilder].
typedef HeaderWidgetBuilder = Widget Function(
  BuildContext context,
  LocalDate date,
);

/// Signature for [Timetable.onEventBackgroundTap].
///
/// `start` contains the time that the user tapped on. `isAllDay` indicates that
/// the tap occurred in the all-day/nnheader area.
typedef OnEventBackgroundTapCallback = void Function(
  LocalDateTime start,
  bool isAllDay,
);

const double hourColumnWidth = 60;

class Timetable<E extends Event> extends StatelessWidget {
  const Timetable({
    Key key,
    @required this.controller,
    @required this.eventBuilder,
    this.allDayEventBuilder,
    this.onEventBackgroundTap,
    this.theme,
    this.dateHeaderBuilder,
    this.leadingHeaderBuilder,
    this.onPageChanged,
    @required this.lengthOfStaff,
    @required this.callBackStaffChange,
    this.allowSrcoll = false,
    this.canScroll =false
  })  : assert(controller != null),
        assert(eventBuilder != null),
        super(key: key);

  final TimetableController<E> controller;
  final EventBuilder<E> eventBuilder;
  
  final bool canScroll;

  /// Optional [Widget] builder function for all-day event shown in the header.
  ///
  /// If not set, [eventBuilder] will be used instead.
  final AllDayEventBuilder<E> allDayEventBuilder;
  final TimetableThemeData theme;

  /// Called when the user taps the background in areas where events are laid
  /// out.
  final OnEventBackgroundTapCallback onEventBackgroundTap;

  /// Custom builder for the left area of the header.
  ///
  /// If it's not provided, or the builder returns `null`, a week indicator
  /// will be shown.
  final HeaderWidgetBuilder leadingHeaderBuilder;

  /// Custom builder for header of a single date.
  ///
  /// If it's not provided, or the builder returns `null`, the day of week and
  /// day of month will be shown.
  final HeaderWidgetBuilder dateHeaderBuilder;

  final int lengthOfStaff;

  final Widget Function(BuildContext context, int index, LocalDate date)
      callBackStaffChange;

  final bool allowSrcoll;

  final Function onPageChanged;
  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      children: <Widget>[
        TimetableHeader<E>(
          controller: controller,
          onEventBackgroundTap: onEventBackgroundTap,
          leadingHeaderBuilder: leadingHeaderBuilder,
          dateHeaderBuilder: dateHeaderBuilder,
          allDayEventBuilder:
              allDayEventBuilder ?? (_, event, __) => eventBuilder(event),
          callBackStaffChange: callBackStaffChange,
          lengthOfStaff: lengthOfStaff,
          onPageChanged: onPageChanged,
        ),
        Expanded(
          child: TimetableContent<E>(
            canScroll: canScroll,
            controller: controller,
            eventBuilder: eventBuilder,
            onEventBackgroundTap: onEventBackgroundTap,
            lengthOfStaff: lengthOfStaff,
            callBackStaffChange: callBackStaffChange,
            allowScroll: allowSrcoll,
            onPageChanged: onPageChanged,
          ),
        ),
      ],
    );

    if (theme != null) {
      child = TimetableTheme(data: theme, child: child);
    }

    return child;
  }
}
