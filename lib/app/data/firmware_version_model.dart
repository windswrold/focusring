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
    List<String> a = json.stringFor("version")?.split(".") ?? [];
    if (a.length == 3) {
      a.removeAt(0);
    }
    downloadUrl = json.stringFor("downloadUrl");
    version = a.join(".");
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
