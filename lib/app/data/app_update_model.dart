class AppUpdateModel {
  String? version;
  String? downloadUrl;
  int? fileSize;
  String? mark;
  bool? forceUpdate;
  String? createTime;

  AppUpdateModel(
      {this.version,
      this.downloadUrl,
      this.fileSize,
      this.mark,
      this.forceUpdate,
      this.createTime});

  AppUpdateModel.fromJson(Map json) {
    version = json['version'];
    downloadUrl = json['downloadUrl'];
    fileSize = json['fileSize'];
    mark = json['mark'];
    forceUpdate = json['forceUpdate'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['downloadUrl'] = this.downloadUrl;
    data['fileSize'] = this.fileSize;
    data['mark'] = this.mark;
    data['forceUpdate'] = this.forceUpdate;
    data['createTime'] = this.createTime;
    return data;
  }
}
