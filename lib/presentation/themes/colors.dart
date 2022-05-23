import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const Color primary = Color(0xff541675);
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color skyBlue = Color(0xffB4D0E8);
  static Map<int, Color> blueGrey = {
    300: Colors.blueGrey,
    200: Colors.blueGrey.withOpacity(0.9),
    100: const Color(0xff99cced),
  };

  static const Color menstrual = Color(0xFFF24951);
  static const Color follicular = Color(0xFF2ECECB);
  static const Color ovulatory = Color(0xFF00ff00);
  static const Color luteal = Color(0xFFFFB131);

}
