import 'package:hormoniousflo_challenge/presentation/pages/base/base.dart';
import 'package:hormoniousflo_challenge/presentation/pages/input/input.dart';
import 'package:hormoniousflo_challenge/presentation/pages/splash/splash.dart';
import 'package:page_transition/page_transition.dart';

import '../data/common/constants/routes.dart';

class CustomRouter {
  CustomRouter._();
  static generateRoutes(settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return PageTransition(
            child: const Splash(),
            type: PageTransitionType.fade,
            settings: settings);
      case Routes.inputRoute:
        return PageTransition(
            child: const InputPage(),
            type: PageTransitionType.fade,
            settings: settings);
      case Routes.baseRoute:
        return PageTransition(
            child: const Base(),
            type: PageTransitionType.fade,
            settings: settings);
    }
  }
}