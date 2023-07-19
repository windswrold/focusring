import 'package:dio/dio.dart';
import 'package:focusring/app/data/app_update_model.dart';
import 'package:focusring/app/data/common_faq.dart';
import 'package:focusring/app/data/firmware_version_model.dart';
import 'package:focusring/app/data/user_info.dart';
import 'package:focusring/net/api_stream/api.dart';
import 'package:focusring/net/api_stream/network.dart';
import 'package:focusring/public.dart' as prefix;
import 'api_stream/header.dart';

class AppApi {
  static VMApi get _api => VMApi(
      network:
          const VMNetwork(prefix: 'https://nft-dev.vmeta3.com', printLevel: 1),
      customAnalysis: (
        VMRequest request,
        Options options,
        Response<dynamic>? response,
        DioException? dioError,
        void Function(VMResultType, [String? error]) onAnalysis,
      ) async {
        final data = response?.data;
        final code = response?.statusCode;
        if (code == 200 && data is Map) {
          final Map map = data;
          final int? code = map.intFor('code');
          final String? msg = map.stringFor('message');
          if (code == 200) {
            onAnalysis(VMResultType.successful);
          } else {
            onAnalysis(VMResultType.apiFailed, msg);
          }
        } else if (data == null || data == '') {
          onAnalysis(VMResultType.connectionError, 'networkError'.tr);
        } else {
          onAnalysis(VMResultType.none);
        }
      });

  ///绑定设备
  VMApiStream<VMResult> bindDevice({required String mac}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..httpBody = {
          "bindDeviceDto": {"mac": mac}
        }
        ..path = "/app/device/bind",
    );
  }

  ///获取最新版本的固件
  VMApiStream<FirmwareVersion> getLatestFirmware() {
    return _api
        .request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..path = "/app/device/getLatestFirmware",
    )
        .convert((r) {
      var info = r.mapResult ?? {};
      return FirmwareVersion.fromJson(info);
    });
  }

  ///解绑设备，不传mac地址，默认解绑当前绑定的设备
  VMApiStream<VMResult> unBindDevice({String? mac}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..httpBody = {
          "unbindDeviceDto": {"mac": mac}..recursivelyRemoveNullItems()
        }
        ..path = "/app/device/unbind",
    );
  }

  ///查询数据
  ///数据类型；bloodOxygen：血氧；femalePeriod：女性生理期；heartRate：心率；sleep 睡眠；step 计步；temp：温度
  VMApiStream<VMResult> queryAppData(
      {required String dataType,
      required String startTime,
      required String endTime}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
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
  VMApiStream<VMResult> uploadAppData({dynamic params}) {
    return _api.request(
      re: VMRequest()
        ..vmMethod = VMMethod.POST
        ..httpBody = {"appDeviceDataDto": params..recursivelyRemoveNullItems()}
        ..path = "/app/data/query",
    );
  }

  ///上传数据
  VMApiStream<VMResult> queryAgreement({dynamic params}) {
    return _api.request(
      re: VMRequest()..path = "/app/common/agreement",
    );
  }

  ///检查应用更新
  ///系统类型，android：安卓，ios：苹果
  VMApiStream<AppUpdateModel> checkAppUpdate(
      {required String systemType, required String currentVersion}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/common/checkAppUpdate"
              ..vmMethod = VMMethod.POST
              ..httpBody = {
                "checkAppUpdateDto": {
                  "systemType": systemType,
                  "currentVersion": currentVersion,
                }
              })
        .convert((r) => AppUpdateModel.fromJson(r.mapResult ?? {}));
  }

  ///获取常见问题列表
  VMApiStream<List<CommonFaqModel>> commonFaq() {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/common/faq"
              ..vmMethod = VMMethod.POST)
        .convert((r) {
      var t = r.listResult ?? [];
      return t.myMap((element) => CommonFaqModel.fromJson(element)).toList();
    });
  }

  ///获取常见问题详情
  VMApiStream<CommonFaqModel> commonFaqDetail({required CommonFaqModel model}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/common/faqDetail"
              ..httpBody = {
                "dto": {
                  "id": model.id,
                  "type": model.type,
                }
              }
              ..vmMethod = VMMethod.POST)
        .convert((r) {
      return CommonFaqModel.fromJson(r.mapResult ?? {});
    });
  }

  ///App用户相关接口
  VMApiStream<VMResult> editUserInfo({required UserInfo model}) {
    return _api.request(
        re: VMRequest()
          ..path = "/app/user/editUserInfo"
          ..httpBody = {"editUserInfoDto": model.toJson()}
          ..vmMethod = VMMethod.POST);
  }

  ///意见反馈
  VMApiStream<VMResult> feedback({required String content}) {
    return _api.request(
        re: VMRequest()
          ..path = "/app/user/feedback"
          ..httpBody = {"feedbackDto": content}
          ..vmMethod = VMMethod.POST);
  }

  ///获取用户信息
  VMApiStream<UserInfo> getUserInfo() {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/user/getUserInfo"
              ..vmMethod = VMMethod.POST)
        .convert((r) => UserInfo.fromJson(r.mapResult ?? {}));
  }

  ///App游客登录
  /////手机唯一标识
  ///系统类型，android：安卓，ios：苹果
  VMApiStream<UserInfo> visitorLogin(
      {required String phoneId, required String systemType}) {
    return _api
        .request(
            re: VMRequest()
              ..path = "/app/user/visitorLogin"
              ..httpBody = {
                "appVisitorLoginDto": {
                  "phoneId": phoneId,
                  "systemType": systemType
                }
              }
              ..vmMethod = VMMethod.POST)
        .convert((r) {
      var user = UserInfo.fromJson(r.mapResult ?? {});
      var accessToken = r.mapResult?.stringFor("accessToken");
      user.accessToken = accessToken;
      return user;
    });
  }
}
