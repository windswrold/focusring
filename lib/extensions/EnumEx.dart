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
        return "  hours";
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
}

extension KSleepStatusEX on KSleepStatus {
  Color getStatusColor() {
    return [
      Colors.transparent,
      const Color(0xFFFFD802),
      const Color(0xFF02FFE2),
      const Color(0xFF766AFF),
    ][index];
  }

  String getStatusDesc() {
    if (this == KSleepStatus.awake) {
      return "wakeup_sleep".tr;
    }

    if (this == KSleepStatus.deepSleep) {
      return "deepsleep_time".tr;
    }
    if (this == KSleepStatus.lightSleep) {
      return "lightsleep_time".tr;
    }

    return "";
  }
}

extension KHeartRateStatusEX on KHeartRateStatus {
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
    if (this == KHeartRateStatus.extreme) {
      return "extreme_status".tr;
    }
    if (this == KHeartRateStatus.anaerobic) {
      return "anaerobic_status".tr;
    }
    if (this == KHeartRateStatus.cardiovascular) {
      return "cardiovascular_status".tr;
    }
    if (this == KHeartRateStatus.fatBurning) {
      return "fatBurning_status".tr;
    }
    if (this == KHeartRateStatus.relaxation) {
      return "relaxation_status".tr;
    }
    if (this == KHeartRateStatus.resting) {
      return "resting_status".tr;
    }

    return "";
  }

  static KHeartRateStatus getExerciseState(int value) {
    if (value >= 181) {
      return KHeartRateStatus.extreme;
    } else if (value >= 161 && value <= 180) {
      return KHeartRateStatus.anaerobic;
    } else if (value >= 141 && value <= 160) {
      return KHeartRateStatus.cardiovascular;
    } else if (value >= 121 && value <= 140) {
      return KHeartRateStatus.fatBurning;
    } else if (value >= 100 && value <= 120) {
      return KHeartRateStatus.relaxation;
    } else {
      return KHeartRateStatus.resting;
    }
  }

  String getStateCondition(KHeartRateStatus status) {
    switch (status) {
      case KHeartRateStatus.extreme:
        return '(>=181)';
      case KHeartRateStatus.anaerobic:
        return '(161~180)';
      case KHeartRateStatus.cardiovascular:
        return '(141~160)';
      case KHeartRateStatus.fatBurning:
        return '(121~140)';
      case KHeartRateStatus.relaxation:
        return '(100~120)';
      case KHeartRateStatus.resting:
        return '(<100)';
      default:
        return '';
    }
  }
}

extension KEMOTIONStatusEX on KEMOTIONStatus {
  Color getStatusColor() {
    return [
      const Color(0xFF00E77C),
      const Color(0xFF14C0FF),
      const Color(0xFFFF8B4D),
    ][index];
  }
}

extension KStressStatusEX on KStressStatus {
  Color getStatusColor() {
    return [
      const Color(0xFF00DCE7),
      const Color(0xFF00E612),
      const Color(0xFFFFD00B),
      const Color(0xFFE7013E),
    ][index];
  }

  String getStatusDesc() {
    if (this == KStressStatus.normal) {
      return "normal".tr;
    }
    if (this == KStressStatus.mild) {
      return "mild".tr;
    }
    if (this == KStressStatus.moderate) {
      return "moderate".tr;
    }
    if (this == KStressStatus.severe) {
      return "severe".tr;
    }

    return "";
  }

  static KStressStatus getExerciseState(int value) {
    if (value >= 80) {
      return KStressStatus.severe;
    } else if (value >= 60 && value <= 79) {
      return KStressStatus.moderate;
    } else if (value >= 30 && value <= 59) {
      return KStressStatus.mild;
    } else if (value >= 0 && value <= 29) {
      return KStressStatus.normal;
    }

    return KStressStatus.normal;
  }

  String getStateCondition(KStressStatus status) {
    switch (status) {
      case KStressStatus.normal:
        return '(0~29)';
      case KStressStatus.mild:
        return '(30~59)';
      case KStressStatus.moderate:
        return '(60~79)';
      case KStressStatus.severe:
        return '(80~100)';

      default:
        return '';
    }
  }
}

extension KFemmaleStatusEX on KFemmaleStatus {
  String image() {
    if (this == KFemmaleStatus.normal) {
      return "${assetsImages}icons/female_bg_safe@3x.png";
    }

    if (this == KFemmaleStatus.yuce) {
      return "${assetsImages}icons/female_todaybg_forecast@3x.png";
    }

    if (this == KFemmaleStatus.anquanqi) {
      return "${assetsImages}icons/female_todaybg_easy@3x.png";
    }
    if (this == KFemmaleStatus.yujinqi) {
      return "${assetsImages}icons/female_todaybg_menstrual@3x.png";
    }
    return "";
  }
}
