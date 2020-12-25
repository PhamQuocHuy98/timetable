import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart';

// ignore: unused_import
import 'positioning_demo.dart';
import 'utils.dart';

void main() async {
  setTargetPlatformForDesktop();

  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize({'rootBundle': rootBundle});
  runApp(ExampleApp(child: TimetableExample()));
}

class TimetableExample extends StatefulWidget {
  @override
  _TimetableExampleState createState() => _TimetableExampleState();
}

class _TimetableExampleState extends State<TimetableExample> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TimetableController<BasicEvent> _controller;

  @override
  void initState() {
    super.initState();

    _controller = TimetableController(
      eventProvider: positioningDemoEventProvider,
      initialTimeRange: InitialTimeRange.range(
        startTime: LocalTime(8, 0, 0),
        endTime: LocalTime(22, 00, 0),
      ),
      initialDate: LocalDate.today(),
      visibleRange: VisibleRange.days(2),
      firstDayOfWeek: DayOfWeek.monday,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      animatoToday();
    });
  }

  animatoToday() async {
    //
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Timetable example'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.today),
            onPressed: () async {
              print("?");
              animatoToday();
            },
            tooltip: 'Jump to today',
          ),
        ],
      ),
      body: Timetable(
        controller: _controller,
        onEventBackgroundTap: (start, isAllDay) {
          print('Background tapped $start is all day event $isAllDay');
        },
        eventBuilder: (event) {
          return DataEventWidget(
            text: 'Ahihi',
            onTap: () => print('Part-day event $event tapped'),
          );
        },
        allDayEventBuilder: (context, event, info) => BasicAllDayEventWidget(
          event,
          info: info,
          onTap: () {
            print('All-day event $event tapped');
          },
        ),
        dateHeaderBuilder: (context, date) {
          int r = (Random().nextInt(255));
          return Container(
            color: Color.fromRGBO(r, r, r, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(date.dayOfMonth.toString()),
                Text(date.toString()),
              ],
            ),
          );
        },
        lengthOfStaff: 0,
        callBackStaffChange: (context, index, date) {
          print(date);
          int r = (Random().nextInt(255));
          return GestureDetector(
            child: Container(
              color: Color.fromRGBO(r, r, r, 1),
              child: Column(
                children: [
                  Text(
                    (index).toString(),
                  ),
                  Text(
                    date.toString(),
                  ),
                  Text(
                    index.toString(),
                  ),
                ],
              ),
            ),
            onTap: () {
              print(date);
            },
          );
        },
        leadingHeaderBuilder: (context, date) {
          return const SizedBox();
        },
      ),
    );
  }

  void _showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(content),
    ));
  }
}
