import 'package:flutter/material.dart';

import '../../../presentation/themes/colors.dart';
class CurrentPhaseModel {
  final String title;
  final Color color;
  final int currentCycle;
  const CurrentPhaseModel({this.title = 'Unknown', this.currentCycle = 0, this.color = AppColors.primary});
}