import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime lastMenStartDate = DateTime.utc(2022, 5, 7);
  int lengthOfCircle = 5;
  int averageLengthOfCircle = 30;
  late final PageController pageController;
  int currentPage = 0;
  late int cycle;
  DateTime _focusedDay = DateTime.now().toLocal();
  late List<CycleInfo> cycleInfo;

  @override
  void initState() {
    cycle = 0;
    initInfoForThreeCycles();
      debugPrint(cycleInfo[cycle].toString());
    super.initState();
  }

  void initInfoForThreeCycles(){
    List<CycleInfo> cycleInfoInit = [];
    for(int i=1; i<=3; i++){
      cycleInfoInit.add(CycleInfo.fromRaw(
          startDateLastMenstrual: lastMenStartDate.toLocal(),
          averageLengthOfCircle: averageLengthOfCircle,
          cycle: i,
          averageLengthOfPeriod: lengthOfCircle));
    }
    cycleInfo = [...cycleInfoInit];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap:(){
                    if(cycle != 0){
                      pageController.jumpToPage(cycle - 1);
                      setState(() {
                        cycle --;
                      });
                      debugPrint(cycleInfo[cycle].toString());
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.deepPurple,),
                  ),
                ),
                GestureDetector(
                  onTap:(){
                    pageController.jumpToPage(cycle + 1);
                    setState(() {
                      cycle ++;
                    });
                    if(cycle < 3){
                      debugPrint(cycleInfo[cycle].toString());
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Icon(Icons.arrow_forward_ios,size: 18, color: Colors.deepPurple,),
                  ),
                )
              ],
            ),
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: cycleInfo[0].menstrual.startDay,
            lastDay: DateTime.utc(2050, 3, 14),
            availableGestures: AvailableGestures.none,
            onCalendarCreated: (PageController pageControllerr) {
                  pageController = pageControllerr;
            },
            onPageChanged: (datetime) {
              _focusedDay = datetime;
              currentPage ++;
            },
            headerVisible: true,
            headerStyle: const HeaderStyle(
              leftChevronVisible: false,
              rightChevronVisible: false,
              headerPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)
            ),
            calendarBuilders: CalendarBuilders(
              outsideBuilder: (buildContext, day, focusedDay) {
                _focusedDay= focusedDay;
                if(cycle < 3){
                  return decideColorToShow(day: day, cycleInfo: cycleInfo[cycle]);
                }
                return null;
              },
              todayBuilder: (buildContext, day, focusedDay) {
                _focusedDay= focusedDay;
                if(cycle < 3){
                  return decideColorToShow(day: day, cycleInfo: cycleInfo[cycle]);
                }
                return null;
              },
              defaultBuilder: (buildContext, day, focusedDay) {
                _focusedDay= focusedDay;
                if(cycle < 3){
                  return decideColorToShow(day: day, cycleInfo: cycleInfo[cycle]);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget? decideColorToShow({required DateTime day, required CycleInfo cycleInfo, bool? todayBuilder, }){
  if (isSameDay(day, cycleInfo.menstrual.startDay) ||
      isSameDay(day, cycleInfo.menstrual.endDay) ||
      (day.isAfter(cycleInfo.menstrual.startDay) &&
          day.isBefore(cycleInfo.menstrual.endDay))) {

    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.red,
                width: 3,
              ))),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(day.day.toString()),
      ),
    );
  } else if (isSameDay(day, cycleInfo.follicular.startDay) ||
      isSameDay(day, cycleInfo.follicular.endDay) ||
      (day.isAfter(cycleInfo.follicular.startDay) &&
          day.isBefore(cycleInfo.follicular.endDay))) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.blue,
                width: 3,
              ))),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(day.day.toString()),
      ),
    );
  } else if (isSameDay(day, cycleInfo.ovulatory.startDay) ||
      isSameDay(day, cycleInfo.ovulatory.endDay) ||
      (day.isAfter(cycleInfo.ovulatory.startDay) &&
          day.isBefore(cycleInfo.ovulatory.endDay))) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.green,
                width: 3,
              ))),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(day.day.toString()),
      ),
    );
  } else if (isSameDay(day, cycleInfo.luteal.startDay) ||
      isSameDay(day, cycleInfo.luteal.endDay) ||
      (day.isAfter(cycleInfo.luteal.startDay) &&
          day.isBefore(cycleInfo.luteal.endDay))) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.yellow,
                width: 3,
              ))),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(day.day.toString()),
      ),
    );
  }else if(day.isAfter(cycleInfo.luteal.endDay)){
      return null;
  }else if(day.isBefore(cycleInfo.menstrual.startDay)){
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.yellow,
                width: 3,
              ))),
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(day.day.toString()),
      ),
    );
  }else {
    return null;
  }
}

class CycleInfo {
  PhaseInfo menstrual;
  PhaseInfo follicular;
  PhaseInfo ovulatory;
  PhaseInfo luteal;
  int cycle = 1;

  CycleInfo({required this.menstrual, required this.follicular, required this.ovulatory, required this.luteal});

  @override
  String toString() {
    return '${{
      'menstrual': {
        'start': menstrual.startDay.toString(),
        'end': menstrual.endDay.toString(),
        'period': menstrual.period.toString()
      },
      'follicular': {
        'start': follicular.startDay.toString(),
        'end': follicular.endDay.toString(),
        'period': follicular.period.toString()
      },
      'ovulatory': {
        'start': ovulatory.startDay.toString(),
        'end': ovulatory.endDay.toString(),
        'period': ovulatory.period.toString()
      },
      'luteal': {
        'start': luteal.startDay.toString(),
        'end': luteal.endDay.toString(),
        'period': luteal.period.toString()
      },
    }}';
  }

  factory CycleInfo.fromRaw({
    required DateTime startDateLastMenstrual,
    required int averageLengthOfCircle,
    required int averageLengthOfPeriod,
    int cycle = 1,
  }) {
    //menstrual
    DateTime startDayM;
    DateTime endDayM;
    int periodM;

    startDayM = startDateLastMenstrual.add(Duration(days: averageLengthOfCircle * (cycle - 1)));
    endDayM = startDayM.add(Duration(days: averageLengthOfPeriod - 1));
    periodM = averageLengthOfPeriod;

    //luteal
    DateTime startDayL;
    DateTime endDayL;
    int periodL;

    periodL = int.parse((0.4 * averageLengthOfCircle).toString().split('.')[0]);
    endDayL = startDayM.add(Duration(days: averageLengthOfCircle - 1));
    startDayL = endDayL.subtract(Duration(days: periodL - 1));

    //ovulatory
    DateTime startDayO;
    DateTime endDayO;
    int periodO;

    endDayO = startDayL.subtract(const Duration(days: 1));
    periodO = 4;
    startDayO = endDayO.subtract(Duration(days: periodO - 1));

    //follicular
    DateTime startDayF;
    DateTime endDayF;
    int periodF;

    startDayF = endDayM.add(const Duration(days: 1));
    endDayF = startDayO.subtract(const Duration(days: 1));
    periodF = averageLengthOfCircle - periodM - periodO - periodL;
       // endDayF.difference(startDayF).inDays;

    return CycleInfo(
        menstrual: PhaseInfo(startDay: startDayM, endDay: endDayM, period: periodM),
        follicular: PhaseInfo(startDay: startDayF, endDay: endDayF, period: periodF),
        ovulatory: PhaseInfo(startDay: startDayO, endDay: endDayO, period: periodO),
        luteal: PhaseInfo(startDay: startDayL, endDay: endDayL, period: periodL));
  }
}

class PhaseInfo {
  DateTime startDay;
  DateTime endDay;
  int period;
  PhaseInfo({required this.startDay, required this.endDay, required this.period});
}

enum Phase { menstrual, follicular, ovulatory, luteal }


