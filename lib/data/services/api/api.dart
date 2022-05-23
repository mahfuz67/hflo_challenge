import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hormoniousflo_challenge/data/services/snackbar/snackbar.dart';
import '../../common/api/request_helper.dart';
import '../../common/constants/api.dart';
import '../../models/remote/cycle_info.dart';
import '../navigation/navigation.dart';
import '../prefs/shared_prefs.dart';
import "package:http/http.dart" as http;

abstract class ApiService {
  Future<List<CycleInfo>> getCycleInfo({
    required String lastPeriod,
    required int averageLengthPeriod,
    required int averageLengthCycle,
    int cycle,
  });
}

class ApiServiceImpl extends ApiService {
  RequestHelpersImpl requestHelpers;
  SharedServiceImpl sharedServiceImpl;
  SnackBarServiceImpl snackBarServicesImpl;
  NavigationServiceImpl navigationServiceImpl;
  ApiServiceImpl(
      {required this.requestHelpers,
      required this.sharedServiceImpl,
      required this.navigationServiceImpl,
      required this.snackBarServicesImpl});

  @override
  Future<List<CycleInfo>> getCycleInfo(
      {required String lastPeriod,
      required int averageLengthPeriod,
      required int averageLengthCycle,
      int cycle = 3}) async {
     Map<String, dynamic> reqBody = {
       "lastPeriod": lastPeriod,
       "averageLengthPeriod": averageLengthPeriod,
       "averageLengthCycle": averageLengthCycle,
       "cycle": cycle
     };
      http.Response res = await requestHelpers.post(url: ApiConstants.GET_CYCLE_INFO, body: reqBody);
      sharedServiceImpl.saveUserInput(userInput: json.encode(reqBody));
      Map<String, dynamic> resDecoded = json.decode(res.body);
      if (res.statusCode == 200) {
        CycleInfoModel cycleInfoModel = CycleInfoModel.fromJson(resDecoded);
        debugPrint(cycleInfoModel.toJson().toString());
        List<Map<String, dynamic>> cycleInfoRawInit = [];
        for (int i = 0; i < cycleInfoModel.data.length; i++){
          cycleInfoRawInit.add(cycleInfoModel.data[i].toJson());
        }
        final List<Map<String, dynamic>> cycleInfoRaw = cycleInfoRawInit;
        sharedServiceImpl.saveCycleInfo(cycleInfo: json.encode(cycleInfoRaw));
        return cycleInfoModel.data;
      } else {
        debugPrint(res.body.toString());
        return [];
      }
  }
}
