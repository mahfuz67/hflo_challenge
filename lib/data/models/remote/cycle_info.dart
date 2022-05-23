
enum Phase { menstrual, follicular, ovulatory, luteal }

class CycleInfoModel {
  CycleInfoModel({
    required this.message,
    required this.success,
    required this.data,
  });
  late final String message;
  late final bool success;
  late final List<CycleInfo> data;

  CycleInfoModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    success = json['success'];
    data = List.from(json['data']).map((e)=>CycleInfo.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['success'] = success;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class CycleInfo {
  CycleInfo({
    required this.menstrual,
    required this.follicular,
    required this.ovulatory,
    required this.luteal,
  });
  late final PhaseInfo menstrual;
  late final PhaseInfo follicular;
  late final PhaseInfo ovulatory;
  late final PhaseInfo luteal;

  CycleInfo.fromJson(Map<String, dynamic> json){
    menstrual = PhaseInfo.fromJson(json['menstrual']);
    follicular = PhaseInfo.fromJson(json['follicular']);
    ovulatory = PhaseInfo.fromJson(json['ovulatory']);
    luteal = PhaseInfo.fromJson(json['luteal']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['menstrual'] = menstrual.toJson();
    _data['follicular'] = follicular.toJson();
    _data['ovulatory'] = ovulatory.toJson();
    _data['luteal'] = luteal.toJson();
    return _data;
  }
}

class PhaseInfo {
  PhaseInfo({
    required this.startDay,
    required this.endDay,
    required this.period,
  });
  late final DateTime startDay;
  late final DateTime endDay;
  late final int period;

  PhaseInfo.fromJson(Map<String, dynamic> json){
    startDay = DateTime.parse(json['startDay']).toLocal();
    endDay = DateTime.parse(json['endDay']).toLocal();
    if(json['period'].runtimeType == String){
      period =  int.parse(json['period']);
    }else {
      period = json['period'];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['startDay'] = startDay.toIso8601String();
    _data['endDay'] = endDay.toIso8601String();
    _data['period'] = period;
    return _data;
  }
}
