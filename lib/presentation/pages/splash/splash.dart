import 'package:flutter/material.dart';

import '../../../data/common/constants/assets.dart';
import '../../../data/common/constants/routes.dart';
import '../../../data/services/navigation/navigation.dart';
import '../../../data/services/prefs/shared_prefs.dart';
import '../../../di/get_it.dart';
import '../../themes/colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      if(getIt<SharedServiceImpl>().userInputExist()){
        //getIt<NavigationServiceImpl>().replaceWith(Routes.inputRoute);
        getIt<NavigationServiceImpl>().replaceWith(Routes.baseRoute);
      }else {
        getIt<NavigationServiceImpl>().replaceWith(Routes.inputRoute);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.skyBlue,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.splashLogo, height: 100, width: 100,)
            ],
          ),
        ));
  }
}