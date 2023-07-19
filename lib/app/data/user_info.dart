import 'package:focusring/public.dart';

class UserInfo {
  String? accessToken;
  int? id;
  String? username;
  String? avatar;
  int? sex;
  String? birthday;
  String? country;
  int? stepsPlan;
  int? caloriePlan;
  int? distancePlan;
  int? sleepPlan;
  int? units;
  String? tempUnit;
  int? heightMetric;
  int? heightBritish;
  int? weightMetric;
  int? weightBritish;
  String? lastPeriodStartTime;
  int? periodDuration;
  int? periodStartInterval;

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
    sex = json['sex'];
    birthday = json['birthday'];
    country = json['country'];
    stepsPlan = json['stepsPlan'];
    caloriePlan = json['caloriePlan'];
    distancePlan = json['distancePlan'];
    sleepPlan = json['sleepPlan'];
    units = json['units'];
    tempUnit = json['tempUnit'];
    heightMetric = json['heightMetric'];
    heightBritish = json['heightBritish'];
    weightMetric = json['weightMetric'];
    weightBritish = json['weightBritish'];
    lastPeriodStartTime = json['lastPeriodStartTime'];
    periodDuration = json['periodDuration'];
    periodStartInterval = json['periodStartInterval'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['sex'] = this.sex;
    data['birthday'] = this.birthday;
    data['country'] = this.country;
    data['stepsPlan'] = this.stepsPlan;
    data['caloriePlan'] = this.caloriePlan;
    data['distancePlan'] = this.distancePlan;
    data['sleepPlan'] = this.sleepPlan;
    data['units'] = this.units;
    data['tempUnit'] = this.tempUnit;
    data['heightMetric'] = this.heightMetric;
    data['heightBritish'] = this.heightBritish;
    data['weightMetric'] = this.weightMetric;
    data['weightBritish'] = this.weightBritish;
    data['lastPeriodStartTime'] = this.lastPeriodStartTime;
    data['periodDuration'] = this.periodDuration;
    data['periodStartInterval'] = this.periodStartInterval;
    return data;
  }
}
