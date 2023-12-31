import 'package:beering/public.dart';

class AppUpdateVersionModel {
  String? version;
  String? downloadUrl;
  int? fileSize;
  String? remark;
  bool? forceUpdate;
  String? createTime;

  AppUpdateVersionModel(
      {this.version,
      this.downloadUrl,
      this.fileSize,
      this.remark,
      this.forceUpdate,
      this.createTime});

  AppUpdateVersionModel.fromJson(Map json) {
    version = json.stringFor("version");
    downloadUrl = json.stringFor("downloadUrl");
    fileSize = json.intFor("fileSize");
    remark = json.stringFor("remark");
    forceUpdate = json.boolFor("forceUpdate");
    createTime = json.stringFor("createTime");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['downloadUrl'] = this.downloadUrl;
    data['fileSize'] = this.fileSize;
    data['remark'] = this.remark;
    data['forceUpdate'] = this.forceUpdate;
    data['createTime'] = this.createTime;
    return data;
  }
}
