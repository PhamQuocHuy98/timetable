import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

import 'controller.dart';
import 'event.dart';
import 'scroll_physics.dart';

typedef DateWidgetBuilder = Widget Function(
    BuildContext context, LocalDate date);

class DatePageView<E extends Event> extends StatefulWidget {
  const DatePageView({
    Key key,
    @required this.controller,
    @required this.builder,
    @required this.callBackStaffChange,
    this.allowScroll = true,
    this.lengthOfStaff = 0,
  })  : assert(controller != null),
        assert(builder != null),
        super(key: key);

  final TimetableController<E> controller;
  final DateWidgetBuilder builder;

  final int lengthOfStaff;

  final Widget Function(BuildContext context, int index, LocalDate date)
      callBackStaffChange;

  /// if alowwScoll is true ->
  /// physics: TimetableScrollPhysics(widget.controller),
  ///  else   physics: NeverScrollPhysics
  final bool allowScroll;

  @override
  _DatePageViewState createState() => _DatePageViewState();
}

class _DatePageViewState extends State<DatePageView> {
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller.scrollControllers.addAndGet();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleDays = widget.controller.visibleRange.visibleDays;

    return Scrollable(
      axisDirection: AxisDirection.right,
      physics: TimetableScrollPhysics(widget.controller),
      controller: _controller,
      viewportBuilder: (context, position) {
        return Viewport(
          axisDirection: AxisDirection.right,
          offset: position,
          anchor: 0,
          slivers: <Widget>[
            SliverFillViewport(
              padEnds: visibleDays % 2 != 0,
              viewportFraction: 1 / visibleDays,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (widget.lengthOfStaff == 0) {
                    return widget.builder?.call(
                      context,
                      LocalDate.fromEpochDay(index + visibleDays ~/ 2),
                    );
                  } else {
                    if (index >= widget.lengthOfStaff) {
                      return null;
                    } else {
                      return widget.callBackStaffChange?.call(
                        context,
                        index,
                        LocalDate.today().addDays(index),
                      );
                    }
                  }
                  // } else {
                  //   if (index > widget.lengthOfStaff) {
                  //     return null;
                  //   } else {
                  //     return widget.callBackStaffChange?.call(
                  //       context,
                  //       index,
                  //       LocalDate.fromEpochDay(index + visibleDays ~/ 2),
                  //     );
                  //   }
                  // }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
