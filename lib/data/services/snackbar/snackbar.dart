import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../presentation/themes/colors.dart';

abstract class SnackBarService {
  void showLoadingCycleInfoSnack(
      {required BuildContext context});
}

class SnackBarServiceImpl extends SnackBarService {
  @override
  void showLoadingCycleInfoSnack(
      {required BuildContext context}) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 20.0),
      backgroundColor: AppColors.skyBlue,
      duration: const Duration(minutes: 60),
      behavior: SnackBarBehavior.fixed,
      content: Row(
        children: [
          SizedBox(
            height: 35,
              width: 35,
              child: CircularProgressIndicator(color: AppColors.blueGrey[300], backgroundColor: AppColors.white,)
          ),
          const SizedBox(width: 15,),
          const Text('Approximating current phase...', overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.primary, fontSize: 19),)
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}