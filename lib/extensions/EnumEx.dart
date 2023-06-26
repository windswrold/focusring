import '../public.dart';

extension KHealthDataEX on KHealthDataType {
  String getDisplayName() {
    switch (this) {
      case KHealthDataType.STEPS:
        return "pedometer".tr;
      case KHealthDataType.DISTANCE:
        return "mileage".tr;
      case KHealthDataType.CALORIES_BURNED:
        return "exercise".tr;
      case KHealthDataType.SLEEP:
        return "sleep".tr;
      case KHealthDataType.HEART_RATE:
        return "heartrate".tr;
      case KHealthDataType.BLOOD_OXYGEN:
        return 'blood_OXYGEN'.tr;
      case KHealthDataType.EMOTION:
        return 'EMOTION'.tr;
      case KHealthDataType.STRESS:
        return 'STRESS'.tr;
      case KHealthDataType.BODY_TEMPERATURE:
        return 'BODY_TEMPERATURE'.tr;
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
      case KHealthDataType.DISTANCE:
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

    return name;
  }

  String getSymbol() {
    switch (this) {
      case KHealthDataType.STEPS:
        return "  steps";
      case KHealthDataType.DISTANCE:
        return "  km";
      case KHealthDataType.CALORIES_BURNED:
        return "exercise".tr;
      case KHealthDataType.SLEEP:
        return "sleep".tr;
      case KHealthDataType.HEART_RATE:
        return "heartrate".tr;
      case KHealthDataType.BLOOD_OXYGEN:
        return 'blood_OXYGEN'.tr;
      case KHealthDataType.EMOTION:
        return 'EMOTION'.tr;
      case KHealthDataType.STRESS:
        return 'STRESS'.tr;
      case KHealthDataType.BODY_TEMPERATURE:
        return 'BODY_TEMPERATURE'.tr;
      case KHealthDataType.FEMALE_HEALTH:
        return 'FEMALE_HEALTH'.tr;
      default:
        throw "add new";
    }
  }
}
