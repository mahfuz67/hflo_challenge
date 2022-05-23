import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/calendar/v3.dart';

import '../../../di/get_it.dart';
import '../../../presentation/bloc/input_bloc.dart';
import '../../../presentation/themes/colors.dart';
import '../../models/remote/cycle_info.dart';
import '../events/events.dart';
import '../navigation/navigation.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({Key? key}) : super(key: key);

  @override
  _DialogWidgetState createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  List<CheckData> checkData = [
    CheckData(title: 'All'),
    CheckData(title: 'Menstrual'),
    CheckData(title: 'Follicular'),
    CheckData(title: 'Ovulatory'),
    CheckData(title: 'Luteal'),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select phase of current cycle to export phase dates to the google calender.',
            style: TextStyle(fontSize: 16, color: AppColors.blueGrey[300])),
        const SizedBox(
          height: 10,
        ),
        ...List.generate(
          checkData.length,
          (index) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    value: checkData[index].isSelected,
                    onChanged: (bool? value) {
                      if (checkData[index].title == "All") {
                        if (checkData[index].isSelected) {
                          for (int i = 0; i < checkData.length; i++) {
                            setState(() {
                              checkData[i].isSelected = false;
                            });
                          }
                        } else {
                          for (int i = 0; i < checkData.length; i++) {
                            setState(() {
                              checkData[i].isSelected = true;
                            });
                          }
                        }
                      } else {
                        if (checkData[checkData.indexWhere((element) => element.title == "All")].isSelected) {
                          setState(() {
                            checkData[checkData.indexWhere((element) => element.title == "All")].isSelected = false;
                          });
                        }
                        setState(() {
                          checkData[index].isSelected = !checkData[index].isSelected;
                        });
                      }
                    },
                    activeColor: AppColors.primary,
                    checkColor: AppColors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [Text(checkData[index].title, style: TextStyle(color: AppColors.blueGrey[300]))]),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  getIt<NavigationServiceImpl>().pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: AppColors.primary),
                )),
            const SizedBox(
              width: 8,
            ),
            TextButton(
                onPressed: () {
                  List<Event> events = [];
                  List<CycleInfo> cycleInfo = context.read<InputCubit>().state.cycleInfo;
                  int currentCycle = context.read<InputCubit>().state.currentPhase.currentCycle;
                  if (checkData[0].isSelected) {
                    Event event1 = Event(
                        summary: "Menstrual",
                        colorId: "11",
                        end: EventDateTime(
                            dateTime: cycleInfo[currentCycle].menstrual.endDay,
                            timeZone: "GMT+01:00"),
                        start: EventDateTime(
                            dateTime: cycleInfo[currentCycle].menstrual.startDay,
                            timeZone: "GMT+01:00"));
                    Event event2 = Event(
                        summary: "Follicular",
                        colorId: "7",
                        end: EventDateTime(
                            dateTime: cycleInfo[currentCycle].follicular.endDay,
                            timeZone: "GMT+01:00"),
                        start: EventDateTime(
                            dateTime: cycleInfo[currentCycle].follicular.startDay,
                            timeZone: "GMT+01:00"));
                    Event event3 = Event(
                        summary: "Ovulatory",
                        colorId: "2",
                        end: EventDateTime(
                            dateTime: cycleInfo[currentCycle].ovulatory.endDay,
                            timeZone: "GMT+01:00"),
                        start: EventDateTime(
                            dateTime: cycleInfo[currentCycle].ovulatory.startDay,
                            timeZone: "GMT+01:00"));
                    Event event4 = Event(
                        summary: "Luteal",
                        colorId: "6",
                        end: EventDateTime(
                            dateTime: cycleInfo[currentCycle].luteal.endDay,
                            timeZone: "GMT+01:00"),
                        start: EventDateTime(
                            dateTime: cycleInfo[currentCycle].luteal.startDay,
                            timeZone: "GMT+01:00"));
                    events = [event1, event2, event3, event4];
                    debugPrint(events.toString());
                    getIt<EventServiceImpl>().sendAllDates(events: events);
                  } else {
                    List<CheckData> ne = checkData.sublist(1);
                    for (int i = 0; i < ne.length; i++) {
                      if(ne[i].isSelected && ne[i].title == "Menstrual"){
                        events.add(Event(
                            summary: "Menstrual",
                            colorId: "11",
                            end: EventDateTime(
                                dateTime: cycleInfo[currentCycle].menstrual.endDay,
                                timeZone: "GMT+01:00"),
                            start: EventDateTime(
                                dateTime: cycleInfo[currentCycle].menstrual.startDay,
                                timeZone: "GMT+01:00")));
                      }else if (ne[i].isSelected && ne[i].title == "Ovulatory"){
                        events.add(Event(
                            summary: "Ovulatory",
                            colorId: "2",
                            end: EventDateTime(
                                dateTime: cycleInfo[currentCycle].ovulatory.endDay,
                                timeZone: "GMT+01:00"),
                            start: EventDateTime(
                                dateTime: cycleInfo[currentCycle].ovulatory.startDay,
                                timeZone: "GMT+01:00")));
                      }else if (ne[i].isSelected && ne[i].title == "Follicular"){
                        events.add(Event(
                            summary: "Follicular",
                            colorId: "7",
                            end: EventDateTime(
                                dateTime: cycleInfo[currentCycle].follicular.endDay,
                                timeZone: "GMT+01:00"),
                            start: EventDateTime(
                                dateTime: cycleInfo[currentCycle].follicular.startDay,
                                timeZone: "GMT+01:00")));
                      }else if (ne[i].isSelected && ne[i].title == "Luteal"){
                        events.add(Event(
                            summary: "Luteal",
                            colorId: "6",
                            end: EventDateTime(
                                dateTime: cycleInfo[currentCycle].luteal.endDay,
                                timeZone: "GMT+01:00"),
                            start: EventDateTime(
                                dateTime: cycleInfo[currentCycle].luteal.startDay,
                                timeZone: "GMT+01:00")));
                      }
                    }
                    debugPrint(events.toString());
                    if(events.isNotEmpty){
                      getIt<EventServiceImpl>().sendAllDates(events: events);
                    }
                  }
                },
                child: const Text(
                  'Export',
                  style: TextStyle(fontSize: 16, color: AppColors.primary),
                ))
          ],
        )
      ],
    );
  }
}

class CheckData {
  String title;
  bool isSelected;
  CheckData({required this.title, this.isSelected = false});
}
