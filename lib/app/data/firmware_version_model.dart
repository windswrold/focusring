import 'package:beering/public.dart';

class FirmwareVersionModel {
  String? downloadUrl;
  String? version;
  int? fileSize;
  String? createTime;
  String? remark;

  FirmwareVersionModel(
      {this.downloadUrl,
      this.version,
      this.fileSize,
      this.createTime,
      this.remark});

  FirmwareVersionModel.fromJson(Map json) {
    downloadUrl = json.stringFor("downloadUrl");
    version = json.stringFor("version");
    fileSize = json.intFor("fileSize");
    createTime = json.stringFor("createTime");
    remark = json.stringFor("remark");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['downloadUrl'] = downloadUrl;
    data['version'] = version;
    data['fileSize'] = fileSize;
    data['createTime'] = createTime;
    data['remark'] = remark;
    return data;
  }
}
