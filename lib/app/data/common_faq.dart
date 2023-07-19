import 'package:focusring/public.dart';

class CommonFaqModel {
  int? id;
  String? language;
  String? type;
  String? title;
  String? createTime;
  String? content;

  CommonFaqModel(
      {this.id,
      this.language,
      this.type,
      this.title,
      this.createTime,
      this.content});

  CommonFaqModel.fromJson(Map json) {
    id = json.intFor("id");
    language = json.stringFor("language");
    type = json.stringFor("type");
    title = json.stringFor("title");
    createTime = json.stringFor("createTime");
    content = json.stringFor("content");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language'] = this.language;
    data['type'] = this.type;
    data['title'] = this.title;
    data['createTime'] = this.createTime;
    return data;
  }
}
