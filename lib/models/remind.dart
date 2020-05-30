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

  Remind({
    this.id,
    this.title,
    this.description,
    this.enabled,
  });

  factory Remind.fromMap(Map<String, dynamic> json) => new Remind(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        enabled: json["enabled"] == 1,
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> remindMap = {
      "title": title,
      "description": description,
      "enabled": enabled? 1 : 0,
    };
    if (id != null) remindMap["id"] = id;

    return remindMap;
  }
}
