import 'dart:convert';

Remind remindFromJson(String str) {
  final jsonData = json.decode(str);
  return Remind.fromMap(jsonData);
}

String remindToJson(Remind data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Remind {
  int id;
  String title;
  String description;
  bool enabled;
  String dateTime;

  Remind({
    this.id,
    this.title,
    this.description,
    this.enabled,
    this.dateTime,
  });

  factory Remind.fromMap(Map<String, dynamic> json) => new Remind(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        enabled: json["enabled"] == 1,
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> remindMap = {
      "title": title,
      "description": description,
      "enabled": enabled ? 1 : 0,
      "dateTime": dateTime,
    };
    if (id != null) remindMap["id"] = id;

    return remindMap;
  }
}
