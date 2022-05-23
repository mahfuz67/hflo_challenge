import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hormoniousflo_challenge/data/common/extensions/range.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../data/models/remote/cycle_info.dart';
import '../../../../data/services/dialog/dialog.dart';
import '../../../../data/services/prefs/shared_prefs.dart';
import '../../../../di/get_it.dart';
import '../../../bloc/input_bloc.dart';
import '../../../themes/colors.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart' as gl;


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final PageController pageController;
  DateTime _focusedDay = DateTime.now().toLocal();
  CalendarFormat calenderFormat = CalendarFormat.month;

  @override
  void initState() {
    if(getIt<SharedServiceImpl>().userInputExist()){
      context.read<InputCubit>().getCycleInfoFromPrefs();
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<InputCubit, InputState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: () async{
                await context.read<InputCubit>().getCycleInfoFromPrefs();
              },
              backgroundColor: AppColors.white,
              color: AppColors.primary,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kToolbarHeight * 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Current Phase:',
                              style: TextStyle(color: Colors.blueGrey.withOpacity(0.7), fontSize: 18),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              state.currentPhase.title,
                              style: TextStyle(color: state.currentPhase.color, fontSize: 19),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: (){
                                getIt<DialogServicesImpl>().pickPhaseToSendToCalendar();
                              },
                              child:  const Icon(
                                Icons.upload_file,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      TableCalendar(
                        focusedDay: _focusedDay,
                        rowHeight: 43,
                        firstDay: DateTime.utc(DateTime.now().year, state.lastPeriod!.month),
                        lastDay: DateTime.utc(2050, 3, 14),
                        availableGestures: AvailableGestures.none,
                        onCalendarCreated: (PageController pageControllerA) {
                          pageController = pageControllerA;
                        },
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month View',
                          CalendarFormat.week: 'Week View',
                          CalendarFormat.twoWeeks: '2 Weeks View',
                        },
                        calendarFormat: calenderFormat,
                        onFormatChanged: (format) {
                          setState(() {
                            calenderFormat = format;
                          });
                        },
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
                          weekendStyle: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        onPageChanged: (datetime) {
                          _focusedDay = datetime;
                        },
                        headerStyle: HeaderStyle(
                            formatButtonDecoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(12)),
                            leftChevronIcon: const Icon(
                              Icons.chevron_left,
                              color: Colors.blue,
                            ),
                            rightChevronIcon: const Icon(
                              Icons.chevron_right,
                              color: Colors.blue,
                            ),
                            formatButtonTextStyle: TextStyle(fontSize: 17, color: Colors.blueGrey.withOpacity(0.7)),
                            titleTextStyle:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey.withOpacity(0.7)),
                            formatButtonPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5)),
                        calendarBuilders: CalendarBuilders(
                          outsideBuilder: (buildContext, day, focusedDay) {
                            _focusedDay = focusedDay;
                            if(state.isLoading){
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.primary,
                                          width: 1.3,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle(fontSize: 16,color: Colors.grey),),
                                  ),
                                ),
                              );
                            }
                            Color? color = decideColorToShow(day: day, cycleInfo: state.cycleInfo);
                            if(color != null){
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: color,
                                          width: 1.5,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle(fontSize: 16,color: Colors.grey),),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 9.5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(day.day.toString(), style: const TextStyle(fontSize: 16,color: Colors.grey),),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (buildContext, day, focusedDay) {
                            _focusedDay = focusedDay;
                            if(state.isLoading){
                              if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                                return Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: AppColors.primary,
                                            width: 1.3,
                                          ))),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(day.day.toString(), style: const TextStyle( color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900),),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.primary,
                                          width: 1.3,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle( color: Color(0xff541675), fontSize: 16, fontWeight: FontWeight.w900),),
                                  ),
                                ),
                              );
                            }
                            Color? color = decideColorToShow(day: day, cycleInfo: state.cycleInfo);
                            if(color != null){
                              if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: color,
                                            width: 1.5,
                                          ))),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(day.day.toString(), style: const TextStyle( color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900),),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: color,
                                          width: 1.5,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle( color: Color(0xff541675), fontSize: 16, fontWeight: FontWeight.w900),),
                                  ),
                                ),
                              );
                            }
                            if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle( color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w900),),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 9.5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(day.day.toString(), style: const TextStyle( color: Color(0xff541675), fontSize: 16, fontWeight: FontWeight.w900),),
                                ),
                              ),
                            );
                          },
                          disabledBuilder: (buildContext, day, focusedDay){
                            _focusedDay = focusedDay;
                            return Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 9.5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(day.day.toString(), style: const TextStyle(color: Colors.grey, fontSize: 16),),
                                ),
                              ),
                            );
                          },
                          defaultBuilder: (buildContext, day, focusedDay) {
                            _focusedDay = focusedDay;
                            if(state.isLoading){
                              if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                                return Container(
                                  decoration: const  BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: AppColors.primary,
                                            width: 1.3,
                                          ))),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(day.day.toString(), style: const TextStyle( color: Colors.black87, fontSize: 16),),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.primary,
                                          width: 1.3,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle(color: Color(0xff541675), fontSize: 16),),
                                  ),
                                ),
                              );
                            }
                            Color? color = decideColorToShow(day: day, cycleInfo: state.cycleInfo);
                            if(color != null){
                              if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            color: color,
                                            width: 1.5,
                                          ))),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Center(
                                      child: Text(day.day.toString(), style: const TextStyle( color: Colors.black87, fontSize: 16),),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                          color: color,
                                          width: 1.5,
                                        ))),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle(color: Color(0xff541675), fontSize: 16),),
                                  ),
                                ),
                              );
                            }
                            if(day.weekday == DateTime.sunday || day.weekday == DateTime.saturday){
                              return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(horizontal: 9.5),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Center(
                                    child: Text(day.day.toString(), style: const TextStyle(color: Colors.black87, fontSize: 16),),
                                  ),
                                ),
                              );
                            }
                            return  Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 9.5),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Text(day.day.toString(), style: const TextStyle(color: Color(0xff541675), fontSize: 16),),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}


Color? decideColorToShow({
  required DateTime day,
  required List<CycleInfo> cycleInfo,
}) {
  Color? color;
  for (int i = 0; i < cycleInfo.length; i++) {
    if (day.isAndInRange(start: cycleInfo[i].menstrual.startDay, end: cycleInfo[i].menstrual.endDay)) {
      color = AppColors.menstrual;
    } else if (day.isAndInRange(start: cycleInfo[i].follicular.startDay, end: cycleInfo[i].follicular.endDay)) {
      color = AppColors.follicular;
    } else if (day.isAndInRange(start: cycleInfo[i].ovulatory.startDay, end: cycleInfo[i].ovulatory.endDay)) {
      color = AppColors.ovulatory;
    } else if (day.isAndInRange(start: cycleInfo[i].luteal.startDay, end: cycleInfo[i].luteal.endDay)) {
      color = AppColors.luteal;
    } else if (day.isAfter(cycleInfo[i].luteal.endDay)) {
      color = null;
    }
    else {
      color = null;
    }
    if (color != null) {
      break;
    }
  }
  return color;
}
