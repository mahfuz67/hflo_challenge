import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hormoniousflo_challenge/data/common/extensions/range.dart';
import 'package:hormoniousflo_challenge/data/services/navigation/navigation.dart';
import 'package:intl/intl.dart';
import '../../data/common/constants/routes.dart';
import '../../data/models/local/current_phase.dart';
import '../../data/models/remote/cycle_info.dart';
import '../../data/services/api/api.dart';
import '../../data/services/prefs/shared_prefs.dart';
import '../../data/services/snackbar/snackbar.dart';
import '../themes/colors.dart';

class InputState {
  final DateTime? lastPeriod;
  final int? averageLengthOfPeriod;
  final int? averageLengthOfCycle;
  bool isLoading;
  final List<CycleInfo> cycleInfo;
  final CurrentPhaseModel currentPhase;
  InputState(
      {this.lastPeriod,
      this.isLoading = false,
      this.cycleInfo = const [],
      this.currentPhase = const CurrentPhaseModel(),
      this.averageLengthOfCycle,
      this.averageLengthOfPeriod});
}

class InputCubit extends Cubit<InputState> {
  ApiServiceImpl apiServiceImpl;
  NavigationServiceImpl navigationServiceImpl;
  SnackBarServiceImpl snackBarServicesImpl;
  SharedServiceImpl prefs;
  InputCubit({required this.apiServiceImpl, required this.prefs, required this.snackBarServicesImpl, required this.navigationServiceImpl})
      : super(InputState());

  void setLoading(bool isLoading) {
    emit(InputState(
        isLoading: isLoading,
        cycleInfo: state.cycleInfo,
        lastPeriod: state.lastPeriod,
        averageLengthOfCycle: state.averageLengthOfCycle,
        currentPhase: state.currentPhase,
        averageLengthOfPeriod: state.averageLengthOfPeriod));
  }

  void setLastPeriod({required BuildContext context, required TextEditingController controller}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime.utc(DateTime.now().year, DateTime.now().month - 1),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                onPrimary: AppColors.white, // selected text color
                onSurface: AppColors.primary, // default text color
                primary: AppColors.primary, // circle color
                surface: AppColors.skyBlue,
              ),
              dialogBackgroundColor: AppColors.white,
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                primary: AppColors.primary, // color of button's letters// Background color
              ))),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('MMMM d, yyyy').format(picked);
      emit(InputState(
          lastPeriod: picked,
          averageLengthOfCycle: state.averageLengthOfPeriod,
          cycleInfo: state.cycleInfo,
          currentPhase: state.currentPhase,
          averageLengthOfPeriod: state.averageLengthOfPeriod));
    }
  }

  void setAverageLengthOfPeriod({required String value}) {
    emit(InputState(
        lastPeriod: state.lastPeriod,
        averageLengthOfCycle: state.averageLengthOfPeriod,
        cycleInfo: state.cycleInfo,
        currentPhase: state.currentPhase,
        averageLengthOfPeriod: int.parse(value)));
  }

  void setAverageLengthOfCycle({required String value}) {
    emit(InputState(
        lastPeriod: state.lastPeriod,
        averageLengthOfCycle: int.parse(value),
        cycleInfo: state.cycleInfo,
        currentPhase: state.currentPhase,
        averageLengthOfPeriod: state.averageLengthOfPeriod));
  }

  void getCycleInfo() async {
    setLoading(true);
    snackBarServicesImpl.showLoadingCycleInfoSnack(context: navigationServiceImpl.navigationKey.currentContext!);
    List<CycleInfo> cycleInfo = await apiServiceImpl.getCycleInfo(
      lastPeriod: state.lastPeriod!.toIso8601String(),
      averageLengthPeriod: state.averageLengthOfPeriod!,
      averageLengthCycle: state.averageLengthOfCycle!,
    );
    CurrentPhaseModel currentPhase = initCurrentPhase(cycleInfo);
    navigationServiceImpl.replaceWith(Routes.baseRoute);
    emit(InputState(
        cycleInfo: cycleInfo,
        lastPeriod: state.lastPeriod,
        averageLengthOfCycle: state.averageLengthOfCycle,
        currentPhase: currentPhase,
        isLoading: false,
        averageLengthOfPeriod: state.averageLengthOfPeriod));
    ScaffoldMessenger.of(navigationServiceImpl.navigationKey.currentContext!).hideCurrentSnackBar();
  }

  Future<void> getCycleInfoFromPrefs() async {
    setLoading(true);
    Map<String, dynamic> userInput =  json.decode(prefs.getUserInput()) as Map<String, dynamic>;
    List<CycleInfo> init = [];
    List<dynamic> cycleInfoRaw =  json.decode(prefs.getCycleInfo());
    for (int i = 0; i < cycleInfoRaw.length; i++) {
      init.add(CycleInfo.fromJson(cycleInfoRaw[i] as Map<String, dynamic>));
    }
    List<CycleInfo> cycleInfo = init;
    CurrentPhaseModel currentPhase = initCurrentPhase(cycleInfo);
    debugPrint(currentPhase.currentCycle.toString());
    emit(InputState(
        cycleInfo: cycleInfo,
        lastPeriod: DateTime.parse(userInput["lastPeriod"]).toLocal(),
        averageLengthOfCycle: userInput['averageLengthOfCycle'],
        currentPhase: currentPhase,
        isLoading: false,
        averageLengthOfPeriod: userInput['averageLengthOfPeriod']));
  }

  CurrentPhaseModel initCurrentPhase(List<CycleInfo> cycleInfo) {
    for (int i = 0; i < cycleInfo.length; i++) {
      if (DateTime.now().isAndInRange(start: cycleInfo[i].menstrual.startDay, end: cycleInfo[i].menstrual.endDay)) {
        return CurrentPhaseModel(title: 'Menstrual', color: AppColors.menstrual, currentCycle: i);
      } else if (DateTime.now()
          .isAndInRange(start: cycleInfo[i].follicular.startDay, end: cycleInfo[i].follicular.endDay)) {
        return CurrentPhaseModel(title: 'Follicular', color: AppColors.follicular, currentCycle: i);
      } else if (DateTime.now()
          .isAndInRange(start: cycleInfo[i].ovulatory.startDay, end: cycleInfo[i].ovulatory.endDay)) {
        return CurrentPhaseModel(title: 'Ovulatory', color: AppColors.ovulatory, currentCycle: i);
      } else if (DateTime.now().isAndInRange(start: cycleInfo[i].luteal.startDay, end: cycleInfo[i].luteal.endDay)) {
        return CurrentPhaseModel(title: 'Luteal', color: AppColors.luteal, currentCycle: i);
      }
    }
    return const CurrentPhaseModel();
  }
}
