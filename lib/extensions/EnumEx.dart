import '../public.dart';

extension KHealthDataEX on KHealthData {
  String getChineseName() {
    switch (this) {
      case KHealthData.STEPS:
        return "pedometer".tr;
      case KHealthData.DISTANCE:
        return "mileage".tr;
      case KHealthData.CALORIES_BURNED:
        return "exercise".tr;
      case KHealthData.SLEEP:
        return "sleep".tr;
      case KHealthData.HEART_RATE:
        return "heartrate".tr;
      case KHealthData.BLOOD_OXYGEN:
        return 'blood_OXYGEN'.tr;
      case KHealthData.EMOTION:
        return 'EMOTION'.tr;
      case KHealthData.STRESS:
        return 'STRESS'.tr;
      case KHealthData.BODY_TEMPERATURE:
        return 'BODY_TEMPERATURE'.tr;
      case KHealthData.FEMALE_HEALTH:
        return 'FEMALE_HEALTH'.tr;
      default:
        throw "add new";
    }
  }

  String getIcon({bool? isBgIcon, bool? isEmptyIcon, bool? isCardIcon}) {
    String name = "";
    switch (this) {
      case KHealthData.STEPS:
        if (isBgIcon == true) {
          name += "bg/status_steps_bg";
        } else if (isCardIcon == true) {
          name += "icons/status_card_icon_steps";
        }
        break;
      case KHealthData.DISTANCE:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.CALORIES_BURNED:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.SLEEP:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.HEART_RATE:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.BLOOD_OXYGEN:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.EMOTION:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.STRESS:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.BODY_TEMPERATURE:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      case KHealthData.FEMALE_HEALTH:
        if (isBgIcon == true) {
          name += "status_steps_bg";
        } else if (isCardIcon == true) {
          name += "status_card_icon_steps";
        }
        break;
      default:
        throw "add new";
    }

    return name;
  }

  String getSymbol() {
    switch (this) {
      case KHealthData.STEPS:
        return "  steps";
      case KHealthData.DISTANCE:
        return "  km";
      case KHealthData.CALORIES_BURNED:
        return "exercise".tr;
      case KHealthData.SLEEP:
        return "sleep".tr;
      case KHealthData.HEART_RATE:
        return "heartrate".tr;
      case KHealthData.BLOOD_OXYGEN:
        return 'blood_OXYGEN'.tr;
      case KHealthData.EMOTION:
        return 'EMOTION'.tr;
      case KHealthData.STRESS:
        return 'STRESS'.tr;
      case KHealthData.BODY_TEMPERATURE:
        return 'BODY_TEMPERATURE'.tr;
      case KHealthData.FEMALE_HEALTH:
        return 'FEMALE_HEALTH'.tr;
      default:
        throw "add new";
    }
  }
}
