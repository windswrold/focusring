import 'package:extended_image/extended_image.dart';

import '../public.dart';

extension KHealthDataEX on KHealthDataType {
  String getDisplayName({
    bool? isGoals,
    bool? isReport,
    bool? isReportSmallTotal,
    bool? isMubiao,
  }) {
    switch (this) {
      case KHealthDataType.STEPS:
        if (isGoals == true) {
          return "steps_goals".tr;
        }
        if (isReport == true) {
          return "pedometer".tr;
        }
        if (isReportSmallTotal == true) {
          return "all_steps".tr;
        }
        if (isMubiao == true) {
          return "steps_mubiao".tr;
        }
        return "pedometer".tr;

      case KHealthDataType.LiCheng:
        if (isGoals == true) {
          return "mileage_goals".tr;
        }
        if (isReport == true) {
          return "distance_report".tr;
        }
        if (isReportSmallTotal == true) {
          return "total_licheng".tr;
        }
        if (isMubiao == true) {
          return "ligheng_mubiao".tr;
        }
        return "mileage".tr;

      case KHealthDataType.CALORIES_BURNED:
        if (isGoals == true) {
          return "activity_goals".tr;
        }
        if (isReport == true) {
          return "calories_report".tr;
        }
        if (isReportSmallTotal == true) {
          return "total_xiaohao".tr;
        }
        if (isMubiao == true) {
          return "xiaohao_mubiao".tr;
        }

        return "exercise".tr;

      case KHealthDataType.SLEEP:
        if (isGoals == true) {
          return "sleep_goals".tr;
        }
        if (isReport == true) {
          return "sleep_report".tr;
        }
        if (isMubiao == true) {
          return "sleep_mubiao".tr;
        }
        return "sleep".tr;

      case KHealthDataType.HEART_RATE:
        if (isReport == true) {
          return "heartrate_report".tr;
        }
        if (isReportSmallTotal == true) {
          return "average_heartrate".tr;
        }

        return "heartrate".tr;

      case KHealthDataType.BLOOD_OXYGEN:
        if (isReport == true) {
          return "bloodoxygen_report".tr;
        }
        if (isReportSmallTotal == true) {
          return "average_bloodoxygen".tr;
        }
        return "blood_OXYGEN".tr;

      case KHealthDataType.EMOTION:
        if (isReport == true) {
          return "emption_report".tr;
        }

        if (isReportSmallTotal == true) {
          return "eMOTION_status".tr;
        }

        return "EMOTION".tr;

      case KHealthDataType.STRESS:
        if (isReport == true) {
          return "stress_report".tr;
        }
        return "STRESS".tr;

      case KHealthDataType.BODY_TEMPERATURE:
        if (isReport == true) {
          return "temperature_report".tr;
        }
        return "BODY_TEMPERATURE".tr;

      case KHealthDataType.FEMALE_HEALTH:
        return 'FEMALE_HEALTH'.tr;
      default:
        throw "add new";
    }
  }

  String getIcon({bool? isBgIcon, bool? isEmptyIcon, bool? isCardIcon}) {
    String name = "";
    switch (this) {
      case KHealthDataType.STEPS:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthDataType.LiCheng:
        if (isBgIcon == true) {
          name += "status_distance_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_distance";
        }
        break;
      case KHealthDataType.CALORIES_BURNED:
        if (isBgIcon == true) {
          name += "status_carolies_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_calorie";
        }
        break;
      case KHealthDataType.SLEEP:
        if (isBgIcon == true) {
          name += "status_sleep_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_sleep";
        }
        break;
      case KHealthDataType.HEART_RATE:
        if (isBgIcon == true) {
          name += "status_hr_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_hr";
        }
        break;
      case KHealthDataType.BLOOD_OXYGEN:
        if (isBgIcon == true) {
          name += "status_sao2_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_sao2";
        }
        break;
      case KHealthDataType.EMOTION:
        if (isBgIcon == true) {
          name += "status_emotion_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_emotion";
        }
        break;
      case KHealthDataType.STRESS:
        if (isBgIcon == true) {
          name += "status_stress_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_stress";
        }
        break;
      case KHealthDataType.BODY_TEMPERATURE:
        if (isBgIcon == true) {
          name += "status_temp_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_temp";
        }
        break;
      case KHealthDataType.FEMALE_HEALTH:
        if (isBgIcon == true) {
          name += "status_female_bg";
        } else if (isCardIcon == true) {
          name += "status_carticon_femalehealth";
        }
        break;
      default:
        throw "add new";
    }

    if (isBgIcon == true) {
      name = "bg/$name";
    } else if (isCardIcon == true) {
      name = "icons/$name";
    }
    if (isEmptyIcon == true) {
      name += "_none";
    }

    return name;
  }

  String getSymbol() {
    switch (this) {
      case KHealthDataType.STEPS:
        return "  steps";
      case KHealthDataType.LiCheng:
        return "  km";
      case KHealthDataType.CALORIES_BURNED:
        return "  kcal".tr;
      case KHealthDataType.SLEEP:
        return "  h";
      case KHealthDataType.HEART_RATE:
        return "  Bpm";
      case KHealthDataType.BLOOD_OXYGEN:
        return "  %";
      case KHealthDataType.EMOTION:
        return '';
      case KHealthDataType.STRESS:
        return '';
      case KHealthDataType.BODY_TEMPERATURE:
        return "  ℃";
      case KHealthDataType.FEMALE_HEALTH:
        return '';
      default:
        throw "add new";
    }
  }

  Gradient getReportGradient() {
    List<Color> colors = [];

    if (this == KHealthDataType.STEPS) {
      colors = [
        const Color(0xFF314626),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.LiCheng) {
      colors = [
        const Color(0xFF2D4348),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.CALORIES_BURNED) {
      colors = [
        const Color(0xFF40352B),
        const Color(0xff161819),
      ];
    } else if (this == KHealthDataType.SLEEP) {
      colors = [
        const Color(0xFF3D3967),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.HEART_RATE) {
      colors = [
        const Color(0xFF4D1E1E),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.BLOOD_OXYGEN) {
      colors = [
        const Color(0xFF523D28),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.BODY_TEMPERATURE) {
      colors = [
        const Color(0xFF274248),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.EMOTION) {
      colors = [
        const Color(0xFF304E40),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.STRESS) {
      colors = [
        const Color(0xFF32585A),
        const Color(0xFF161819),
      ];
    } else if (this == KHealthDataType.FEMALE_HEALTH) {
      colors = [
        const Color(0xFF5A324B),
        const Color(0xFF161819),
      ];
    }

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: [0, 0.2],
    );
  }

  Color? getTypeMainColor() {
    if (this == KHealthDataType.STEPS) {
      return Color(0xFF34E050);
    } else if (this == KHealthDataType.LiCheng) {
      return Color(0xFF00CEFF);
    } else if (this == KHealthDataType.CALORIES_BURNED) {
      return Color(0xFFFF723E);
    } else if (this == KHealthDataType.SLEEP) {
      return Color(0xFF766AFF);
    } else if (this == KHealthDataType.HEART_RATE) {
      return Color(0xFFFF3636);
    } else if (this == KHealthDataType.BLOOD_OXYGEN) {
      return Color(0xFFFF9327);
    } else if (this == KHealthDataType.BODY_TEMPERATURE) {
      return Color(0xFF00BBE7);
    } else if (this == KHealthDataType.EMOTION) {
    } else if (this == KHealthDataType.STRESS) {
      return Color(0xFF00DCE7);
    } else if (this == KHealthDataType.FEMALE_HEALTH) {}
  }

  String getReportDesc({bool? isContent}) {
    if (this == KHealthDataType.SLEEP) {
      if (isContent == true) {
        return "abount_sleep_tip".tr;
      }
      return "abount_sleep".tr;
    }
    if (isContent == true) {
      return "steps_info_tip2".tr;
    }
    return "steps_info_tip1".tr;
  }
}

extension KReportTypeEX on KReportType {
  String getCaloriesTitle() {
    return [
      "daily_activity".tr,
      "week_activity".tr,
      "month_activity".tr,
    ][index];
  }

  String getOverviewTitle() {
    return [
      "today_overview".tr,
      "week_overview".tr,
      "moneth_overview".tr,
    ][index];
  }
}

extension KSleepStatusEX on KSleepStatusType {
  Color getStatusColor() {
    if (this == KSleepStatusType.awake) {
      return const Color(0xFFFFD802);
    }
    if (this == KSleepStatusType.lightSleep) {
      return const Color(0xFF02FFE2);
    }
    if (this == KSleepStatusType.deepSleep) {
      return const Color(0xFF766AFF);
    }

    return Colors.transparent;
  }

  String getStatusDesc() {
    if (this == KSleepStatusType.awake) {
      return "wakeup_sleep".tr;
    }

    if (this == KSleepStatusType.deepSleep) {
      return "deepsleep_time".tr;
    }
    if (this == KSleepStatusType.lightSleep) {
      return "lightsleep_time".tr;
    }

    return "";
  }
}

extension KHeartRateStatusEX on KHeartRateStatusType {
  Color getStatusColor() {
    return [
      const Color(0xFFFF0000),
      const Color(0xFFFD8813),
      const Color(0xFFF5FD00),
      const Color(0xFF07FD4C),
      const Color(0xFF1DBAFF),
      const Color(0xFF7C5DFF),
    ][index];
  }

  String getStatusDesc() {
    if (this == KHeartRateStatusType.extreme) {
      return "extreme_status".tr;
    }
    if (this == KHeartRateStatusType.anaerobic) {
      return "anaerobic_status".tr;
    }
    if (this == KHeartRateStatusType.cardiovascular) {
      return "cardiovascular_status".tr;
    }
    if (this == KHeartRateStatusType.fatBurning) {
      return "fatBurning_status".tr;
    }
    if (this == KHeartRateStatusType.relaxation) {
      return "relaxation_status".tr;
    }
    if (this == KHeartRateStatusType.resting) {
      return "resting_status".tr;
    }

    return "";
  }

  static KHeartRateStatusType getExerciseState(int value) {
    if (value >= 181) {
      return KHeartRateStatusType.extreme;
    } else if (value >= 161 && value <= 180) {
      return KHeartRateStatusType.anaerobic;
    } else if (value >= 141 && value <= 160) {
      return KHeartRateStatusType.cardiovascular;
    } else if (value >= 121 && value <= 140) {
      return KHeartRateStatusType.fatBurning;
    } else if (value >= 100 && value <= 120) {
      return KHeartRateStatusType.relaxation;
    } else {
      return KHeartRateStatusType.resting;
    }
  }

  String getStateCondition(KHeartRateStatusType status) {
    switch (status) {
      case KHeartRateStatusType.extreme:
        return '(>=181)';
      case KHeartRateStatusType.anaerobic:
        return '(161~180)';
      case KHeartRateStatusType.cardiovascular:
        return '(141~160)';
      case KHeartRateStatusType.fatBurning:
        return '(121~140)';
      case KHeartRateStatusType.relaxation:
        return '(100~120)';
      case KHeartRateStatusType.resting:
        return '(<100)';
      default:
        return '';
    }
  }
}

extension KEMOTIONStatusEX on KEMOTIONStatusType {
  Color getStatusColor() {
    return [
      const Color(0xFF00E77C),
      const Color(0xFF14C0FF),
      const Color(0xFFFF8B4D),
    ][index];
  }

  String getStatusDesc() {
    if (this == KEMOTIONStatusType.neutral) {
      return "neutral".tr;
    }
    if (this == KEMOTIONStatusType.negative) {
      return "negative".tr;
    }
    if (this == KEMOTIONStatusType.positive) {
      return "positive".tr;
    }

    return "";
  }
}

extension KStressStatusEX on KStressStatusType {
  Color getStatusColor() {
    return [
      const Color(0xFF00DCE7),
      const Color(0xFF00E612),
      const Color(0xFFFFD00B),
      const Color(0xFFE7013E),
    ][index];
  }

  String getStatusDesc() {
    if (this == KStressStatusType.normal) {
      return "normal".tr;
    }
    if (this == KStressStatusType.mild) {
      return "mild".tr;
    }
    if (this == KStressStatusType.moderate) {
      return "moderate".tr;
    }
    if (this == KStressStatusType.severe) {
      return "severe".tr;
    }

    return "";
  }

  static KStressStatusType getExerciseState(int value) {
    if (value >= 80) {
      return KStressStatusType.severe;
    } else if (value >= 60 && value <= 79) {
      return KStressStatusType.moderate;
    } else if (value >= 30 && value <= 59) {
      return KStressStatusType.mild;
    } else if (value >= 0 && value <= 29) {
      return KStressStatusType.normal;
    }

    return KStressStatusType.normal;
  }

  String getStateCondition(KStressStatusType status) {
    switch (status) {
      case KStressStatusType.normal:
        return '(0~29)';
      case KStressStatusType.mild:
        return '(30~59)';
      case KStressStatusType.moderate:
        return '(60~79)';
      case KStressStatusType.severe:
        return '(80~100)';

      default:
        return '';
    }
  }
}

extension KFemmaleStatusEX on KFemmaleStatusType {
  String image() {
    if (this == KFemmaleStatusType.normal) {
      return "${assetsImages}icons/female_bg_safe@3x.png";
    }

    if (this == KFemmaleStatusType.yuce) {
      return "${assetsImages}icons/female_todaybg_forecast@3x.png";
    }

    if (this == KFemmaleStatusType.anquanqi) {
      return "${assetsImages}icons/female_todaybg_easy@3x.png";
    }
    if (this == KFemmaleStatusType.yujinqi) {
      return "${assetsImages}icons/female_todaybg_menstrual@3x.png";
    }
    return "";
  }
}

extension KUnitsEX on KUnitsType {
  int getRaw() {
    return [1, 2][index];
  }

  String title() {
    return ["unit_gong".tr, "unit_inch".tr][index];
  }

  static KUnitsType getValue(int? value) {
    try {
      value ??= 1;
      return value == 1 ? KUnitsType.metric : KUnitsType.imperial;
    } catch (e) {}
    return KUnitsType.metric;
  }
}

extension KTempUnitsEX on KTempUnitsType {
  int getRaw() {
    return [1, 2][index];
  }

  String title() {
    return ["unit_degreescelsius".tr, "unit_fahrenheit".tr][index];
  }

  static KTempUnitsType getValue(int? value) {
    try {
      value ??= 1;
      return value == 1 ? KTempUnitsType.celsius : KTempUnitsType.fahrenheit;
    } catch (e) {}
    return KTempUnitsType.celsius;
  }
}

extension GetBack on GetInterface {
  void backDelay<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
    int milliseconds = 1500,
  }) {
    Future.delayed(Duration(milliseconds: milliseconds)).then((value) => {
          back<T>(
              result: result,
              closeOverlays: closeOverlays,
              canPop: canPop,
              id: id),
        });
  }
}

extension KSexEX on KSexType {
  int getRaw() {
    return [1, 2][index];
  }

  String title() {
    return ["man".tr, "woman".tr][index];
  }

  static KSexType getValue(int? value) {
    try {
      value ??= 1;
      return value == 1 ? KSexType.man : KSexType.woman;
    } catch (e) {}
    return KSexType.man;
  }
}

extension KBLECommandEX on KBLECommandType {
  String getBLECommand() {
    String values = "";
    if (this == KBLECommandType.bindingsverify) {
      values = "01";
    }
    if (this == KBLECommandType.system) {
      values = "02";
    }
    if (this == KBLECommandType.ppg) {
      values = "03";
    }
    if (this == KBLECommandType.gsensor) {
      values = "04";
    }
    if (this == KBLECommandType.sleep) {
      values = "05";
    }
    if (this == KBLECommandType.battery) {
      values = "06";
    }
    if (this == KBLECommandType.charger) {
      values = "07";
    }
    if (this == KBLECommandType.factory) {
      values = "08";
    }
    if (this == KBLECommandType.debug) {
      values = "09";
    }

    return values;
  }
}

extension KBleStateEX on KBleState {
  String getRawString() {
    return ["Unconnect", "Connecting", "Connected"][index];
  }
}
