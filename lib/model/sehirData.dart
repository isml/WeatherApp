class SehirData {
  final String id;
  final String name;

  SehirData({this.id, this.name});

  factory SehirData.fromJson(Map<String, dynamic> json) {
    return SehirData(id: json['id'].toString(), name: json['name']);
  }
}