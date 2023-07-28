import 'package:focusring/public.dart';

class UserInfo {
  String? accessToken;
  int? id; //用户id
  String? username; //用户名
  String? avatar; //头像地址
  KSex? sex; //性别，1男，2女
  String? birthday; //生日
  String? country; //国家
  int? stepsPlan; //记步目标
  int? caloriePlan; //消耗卡路里目标，单位kcal
  int? distancePlan; //运动距离目标
  int? sleepPlan; //睡眠目标
  KUnits? units; //单位，1公制，2英制
  KTempUnits? tempUnit; //温度单位，1 摄氏温度，2 华式温度，默认1
  int? heightMetric; //身高，公制，单位厘米
  int? heightBritish; //身高，英制，单位in
  int? weightMetric; //体重，公制，单位kg
  int? weightBritish; //体重，英制，单位lb
  String? lastPeriodStartTime; //上次经期开始时间
  int? periodDuration; //经期持续天数
  int? periodStartInterval; //经期开始日间隔天数

  UserInfo(
      {this.accessToken,
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
      this.periodStartInterval});

  UserInfo.fromJson(Map json) {
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

    return data;
  }

  String displayHeight({bool displaySymbol = true}) {
    if (displaySymbol) {
      return units == KUnits.metric ? "$heightMetric cm" : "$heightBritish in";
    }
    return units == KUnits.metric ? "$heightMetric" : "$heightBritish";
  }

  String displayWeight({bool displaySymbol = true}) {
    if (displaySymbol) {
      return units == KUnits.metric ? "$weightMetric kg" : "$weightBritish lb";
    }
    return units == KUnits.metric ? "$weightMetric" : "$weightBritish";
  }
}
