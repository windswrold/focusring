import 'package:dio/dio.dart';
import 'package:focusring/app/data/app_update_model.dart';
import 'package:focusring/app/data/common_faq.dart';
import 'package:focusring/app/data/firmware_version_model.dart';
import 'package:focusring/app/data/user_info.dart';
import 'package:focusring/app/modules/app_view/controllers/app_view_controller.dart';
import 'package:focusring/const/constant.dart';
import 'package:focusring/net/api_stream/api.dart';
import 'package:focusring/net/api_stream/network.dart';
import 'package:focusring/public.dart' as prefix;
import 'package:focusring/utils/sp_manager.dart';
import 'package:get/get_core/get_core.dart';
import 'api_stream/header.dart';

class AppApi {
  static VMApi get _api => VMApi(
      network: const VMNetwork(
          prefix: 'http://119.23.24.144/hlcrazy-ring', printLevel: 1),
      customAnalysis: (
        VMRequest request,
        Options options,
        Response<dynamic>? response,
        DioException? dioError,
        void Function(VMResultType, [String? error]) onAnalysis,
      ) async {
        final data = response?.data;
        final code = response?.statusCode;
        if (code == 200) {
          if (data is Map) {
            final Map map = data;
            final int? code = map.intFor('code');
            final String? msg = map.stringFor('message');
            if (code == 200) {
              onAnalysis(VMResultType.successful);
            } else {
              onAnalysis(VMResultType.apiFailed, msg);
            }
          } else {
            onAnalysis(VMResultType.successful);
          }
        } else if (data == null || data == '') {
          onAnalysis(VMResultType.connectionError, 'networkError'.tr);
        } else {
          onAnalysis(VMResultType.none);
        }
      });

  ///绑定设备
  static VMApiStream<VMResult> bindDevice({required String mac}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..needAccessToken = true
        ..httpBody = {
          "bindDeviceDto": {"mac": mac}
        }
        ..path = "/app/device/bind",
    );
  }

  ///获取最新版本的固件
  static VMApiStream<FirmwareVersion> getLatestFirmware() {
    return _api
        .request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..needAccessToken = true
        ..path = "/app/device/getLatestFirmware",
    )
        .convert((r) {
      var info = r.mapResult ?? {};
      return FirmwareVersion.fromJson(info);
    });
  }

  ///解绑设备，不传mac地址，默认解绑当前绑定的设备
  static VMApiStream<VMResult> unBindDevice({String? mac}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..needAccessToken = true
        ..httpBody = {
          "unbindDeviceDto": {"mac": mac}..recursivelyRemoveNullItems()
        }
        ..path = "/app/device/unbind",
    );
  }

  ///查询数据
  ///数据类型；bloodOxygen：血氧；femalePeriod：女性生理期；heartRate：心率；sleep 睡眠；step 计步；temp：温度
  static VMApiStream<VMResult> queryAppData(
      {required String dataType,
      required String startTime,
      required String endTime}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..needAccessToken = true
        ..httpBody = {
          "queryAppDataDto": {
            "dataType": dataType,
            "startTime": startTime,
            "endTime": endTime,
          }..recursivelyRemoveNullItems()
        }
        ..path = "/app/data/query",
    );
  }

  ///上传数据
  static VMApiStream<VMResult> uploadAppData({dynamic params}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..needAccessToken = true
        ..httpBody = {
          "appDeviceDataDto": params..recursivelyRemoveNullItems(),
        }
        ..path = "/app/data/query",
    );
  }

  ///上传数据
  static VMApiStream<VMResult> queryAgreement() {
    return _api.request(
      re: VMRequest()..path = "/app/common/agreement",
    );
  }

  ///检查应用更新
  ///系统类型，android：安卓，ios：苹果
  static VMApiStream<AppUpdateModel> checkAppUpdate(
      {required int systemType, required String currentVersion}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/common/checkAppUpdate"
              ..vmMethod = VMMethod.POST
              ..httpBody = {
                "systemType": systemType,
                "currentVersion": currentVersion,
              })
        .convert((r) => AppUpdateModel.fromJson(r.mapResult ?? {}));
  }

  ///获取常见问题列表
  static VMApiStream<List<CommonFaqModel>> commonFaq() {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/common/faq"
              ..canQueryCache = true
              ..vmMethod = VMMethod.POST)
        .convert((r) {
      var t = r.listResult ?? [];
      return t.myMap((element) => CommonFaqModel.fromJson(element)).toList();
    });
  }

  ///获取常见问题详情
  static VMApiStream<VMResult> commonFaqDetail(
      {required CommonFaqModel model}) {
    return _api.request(
      re: VMRequest()
        ..path = "/app/common/faqDetail"
        ..queryParams = {
          "id": model.id,
          "type": model.type,
        }
        ..vmMethod = VMMethod.GET,
    );
  }

  ///App用户相关接口
  static VMApiStream<VMResult> editUserInfo(
      {required Map<String, dynamic> model}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/user/editUserInfo"
              ..needAccessToken = true
              ..httpBody = FormData.fromMap(model)
              ..vmMethod = VMMethod.POST)
        .onSuccess((value) {
      AppViewController app = Get.find(tag: AppViewController.tag);
      app.login();
    });
  }

  ///意见反馈
  static VMApiStream<VMResult> feedback({required String content}) {
    return _api.request(
        re: VMRequest()
          ..path = "/app/user/feedback"
          ..needAccessToken = true
          ..httpBody = {"feedbackDto": content}
          ..vmMethod = VMMethod.POST);
  }

  ///获取用户信息
  static VMApiStream<UserInfo> getUserInfo() {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/user/getUserInfo"
              ..needAccessToken = true
              ..vmMethod = VMMethod.POST)
        .convert((r) => UserInfo.fromJson(r.mapResult ?? {}));
  }

  ///App游客登录
  /////手机唯一标识
  ///系统类型，android：安卓，ios：苹果
  static VMApiStream<UserInfo> visitorLogin(
      {required String phoneId, required int systemType}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/user/visitorLogin"
              ..httpBody = {"phoneId": phoneId, "systemType": systemType}
              ..vmMethod = VMMethod.POST)
        .convert((r) {
      var accessToken = r.mapResult?.stringFor("accessToken");
      var appUserInfo = r.mapResult?.mapFor("appUserInfo");
      var user = UserInfo.fromJson(appUserInfo ?? {});
      user.accessToken = accessToken;
      SPManager.setGlobalUser(user);
      return user;
    });
  }
}
