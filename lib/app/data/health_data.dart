class BloodOxygenData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? bloodOxygen;

  BloodOxygenData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.bloodOxygen,
  });

  factory BloodOxygenData.fromJson(Map<String, dynamic> json) =>
      BloodOxygenData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        bloodOxygen: json["bloodOxygen"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "bloodOxygen": bloodOxygen,
      };
}

class FemalePeriodData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? periodState;

  FemalePeriodData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.periodState,
  });

  factory FemalePeriodData.fromJson(Map<String, dynamic> json) =>
      FemalePeriodData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        periodState: json["periodState"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "periodState": periodState,
      };
}

class HeartRateData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? averageHeartRate;
  String? heartArray;

  HeartRateData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.averageHeartRate,
    this.heartArray,
  });

  factory HeartRateData.fromJson(Map<String, dynamic> json) => HeartRateData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        averageHeartRate: json["averageHeartRate"],
        heartArray: json["heartArray"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "averageHeartRate": averageHeartRate,
        "heartArray": heartArray,
      };
}

class SleepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? deepTime;
  int? lightTime;
  String? dataForHour;

  SleepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.deepTime,
    this.lightTime,
    this.dataForHour,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) => SleepData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        deepTime: json["deepTime"],
        lightTime: json["lightTime"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "deepTime": deepTime,
        "lightTime": lightTime,
        "dataForHour": dataForHour,
      };
}

class TempData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? temperature;

  TempData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.temperature,
  });

  factory TempData.fromJson(Map<String, dynamic> json) => TempData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        temperature: json["temperature"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "temperature": temperature,
      };
}

class StepData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? steps;
  int? distance;
  int? calorie;
  String? dataForHour;

  StepData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.steps,
    this.distance,
    this.calorie,
    this.dataForHour,
  });

  factory StepData.fromJson(Map<String, dynamic> json) => StepData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        steps: json["steps"],
        distance: json["distance"],
        calorie: json["calorie"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "steps": steps,
        "distance": distance,
        "calorie": calorie,
        "dataForHour": dataForHour,
      };
}

class EmotionData {
  int? appUserId;
  String? mac;
  String? createTime;
  String? emotion;
  String? dataForHour;

  EmotionData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.emotion,
    this.dataForHour,
  });

  factory EmotionData.fromJson(Map<String, dynamic> json) => EmotionData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        emotion: json["emotion"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "emotion": emotion,
        "dataForHour": dataForHour,
      };
}

class PressureData {
  int? appUserId;
  String? mac;
  String? createTime;
  int? pressure;
  String? dataForHour;

  PressureData({
    this.appUserId,
    this.mac,
    this.createTime,
    this.pressure,
    this.dataForHour,
  });

  factory PressureData.fromJson(Map<String, dynamic> json) => PressureData(
        appUserId: json["appUserId"],
        mac: json["mac"],
        createTime: json["createTime"],
        pressure: json["pressure"],
        dataForHour: json["dataForHour"],
      );

  Map<String, dynamic> toJson() => {
        "appUserId": appUserId,
        "mac": mac,
        "createTime": createTime,
        "pressure": pressure,
        "dataForHour": dataForHour,
      };
}
