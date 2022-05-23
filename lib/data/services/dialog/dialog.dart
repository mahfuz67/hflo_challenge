import 'package:flutter/material.dart';
import 'package:hormoniousflo_challenge/data/services/dialog/widget.dart';
import '../navigation/navigation.dart';

abstract class DialogServices {
  Future<void> pickPhaseToSendToCalendar();
}

class DialogServicesImpl implements DialogServices {
  NavigationServiceImpl navigationServiceImpl;
  DialogServicesImpl({required this.navigationServiceImpl});

  @override
  Future<void> pickPhaseToSendToCalendar() async{
    await showDialog(
        context: navigationServiceImpl.navigationKey.currentContext!,
        barrierDismissible: true,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 15),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 440,
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: const Center(child: DialogWidget())),
        ));
  }
}