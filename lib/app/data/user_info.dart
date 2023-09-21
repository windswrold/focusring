import 'package:beering/public.dart';

class UserInfoModel {
  String? accessToken;
  int? id; //用户id
  String? username; //用户名
  String? avatar; //头像地址
  KSexType? sex; //性别，1男，2女
  String? birthday; //生日
  String? country; //国家
  int? stepsPlan; //记步目标
  int? caloriePlan; //消耗卡路里目标，单位kcal
  int? distancePlan; //运动距离目标
  int? sleepPlan; //睡眠目标
  KUnitsType? units; //单位，1公制，2英制
  KTempUnitsType? tempUnit; //温度单位，1 摄氏温度，2 华式温度，默认1
  int? heightMetric; //身高，公制，单位厘米
  int? heightBritish; //身高，英制，单位in
  int? weightMetric; //体重，公制，单位kg
  int? weightBritish; //体重，英制，单位lb
  String? lastPeriodStartTime; //上次经期开始时间
  int? periodDuration; //经期持续天数
  int? periodStartInterval; //经期开始日间隔天数
  bool? heartRateWarnSwitch; //心率预警开关
  int? maxHeartRate; //最大心率
  int? minHeartRate; //最小心率
  bool? heartRateAutoTestSwitch; //心率自动测试开关
  int? heartRateAutoTestInterval; //心率自动测试间隔时间
  bool? bloodOxygenAutoTestSwitch; //血氧自动测试开关
  int? bloodOxygenAutoTestInterval; //血氧自动测试间隔时间

  UserInfoModel({
    this.accessToken,
    this.id,
    this.username,
    this.avatar,
    this.sex,
    this.birthday,
    this.country,
    this.stepsPlan,
    this.caloriePlan,
    this.distancePlan,
    this.sleepPlan,
    this.units,
    this.tempUnit,
    this.heightMetric,
    this.heightBritish,
    this.weightMetric,
    this.weightBritish,
    this.lastPeriodStartTime,
    this.periodDuration,
    this.periodStartInterval,
    this.bloodOxygenAutoTestSwitch,
    this.heartRateAutoTestSwitch,
    this.heartRateWarnSwitch,
    this.bloodOxygenAutoTestInterval,
    this.heartRateAutoTestInterval,
    this.maxHeartRate,
    this.minHeartRate,
  });

  UserInfoModel.fromJson(Map json) {
    accessToken = json.stringFor("accessToken");
    id = json.intFor("id");
    username = json['username'];
    avatar = json['avatar'];
    sex = KSexEX.getValue(json['sex']);
    birthday = json['birthday'];
    country = json['country'];
    stepsPlan = json['stepsPlan'] ?? 10000;
    caloriePlan = json['caloriePlan'] ?? 500;
    distancePlan = json['distancePlan'] ?? 10;
    sleepPlan = json['sleepPlan'] ?? 8;
    units = KUnitsEX.getValue(json['units']);
    tempUnit = KTempUnitsEX.getValue(json['tempUnit']);
    heightMetric = json['heightMetric'] ?? 175;
    heightBritish = json['heightBritish'] ?? 70;
    weightMetric = json['weightMetric'] ?? 60;
    weightBritish = json['weightBritish'] ?? 132;
    lastPeriodStartTime = json['lastPeriodStartTime'];
    periodDuration = json['periodDuration'];
    periodStartInterval = json['periodStartInterval'];

    heartRateWarnSwitch = json["heartRateWarnSwitch"] ?? false;
    maxHeartRate = json["maxHeartRate"] ?? 160;
    minHeartRate = json["minHeartRate"] ?? 40;
    heartRateAutoTestSwitch = json["heartRateAutoTestSwitch"] ?? false;
    heartRateAutoTestInterval = json["heartRateAutoTestInterval"] ?? 5;
    bloodOxygenAutoTestSwitch = json["bloodOxygenAutoTestSwitch"] ?? false;
    bloodOxygenAutoTestInterval = json["bloodOxygenAutoTestInterval"] ?? 5;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["accessToken"] = this.accessToken;
    data["id"] = id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['sex'] = this.sex?.getRaw();
    data['birthday'] = this.birthday;
    data['country'] = this.country;
    data['stepsPlan'] = this.stepsPlan;
    data['caloriePlan'] = this.caloriePlan;
    data['distancePlan'] = this.distancePlan;
    data['sleepPlan'] = this.sleepPlan;
    data['units'] = this.units?.getRaw();
    data['tempUnit'] = this.tempUnit?.getRaw();
    data['heightMetric'] = this.heightMetric;
    data['heightBritish'] = this.heightBritish;
    data['weightMetric'] = this.weightMetric;
    data['weightBritish'] = this.weightBritish;
    data['lastPeriodStartTime'] = this.lastPeriodStartTime;
    data['periodDuration'] = this.periodDuration;
    data['periodStartInterval'] = this.periodStartInterval;

    data['heartRateWarnSwitch'] = this.heartRateWarnSwitch;
    data['maxHeartRate'] = this.maxHeartRate;
    data['minHeartRate'] = this.minHeartRate;
    data['heartRateAutoTestSwitch'] = this.heartRateAutoTestSwitch;
    data['heartRateAutoTestInterval'] = this.heartRateAutoTestInterval;
    data['bloodOxygenAutoTestSwitch'] = this.bloodOxygenAutoTestSwitch;
    data['bloodOxygenAutoTestInterval'] = this.bloodOxygenAutoTestInterval;

    return data;
  }

  String displayHeight({bool displaySymbol = true}) {
    if (displaySymbol) {
      return units == KUnitsType.metric
          ? "$heightMetric cm"
          : "$heightBritish in";
    }
    return units == KUnitsType.metric ? "$heightMetric" : "$heightBritish";
  }

  String displayWeight({bool displaySymbol = true}) {
    if (displaySymbol) {
      return units == KUnitsType.metric
          ? "$weightMetric kg"
          : "$weightBritish lb";
    }
    return units == KUnitsType.metric ? "$weightMetric" : "$weightBritish";
  }

  ///获取公制身高
  int calMetricHeight() {
    if (heightMetric != null) {
      return heightMetric!;
    }

    return (heightBritish! * 2.54).toInt();
  }

  //获取公制体重
  int calMetricWeight() {
    if (weightMetric != null) {
      return weightMetric!;
    }

    return weightBritish! ~/ 0.453592;
  }
}
