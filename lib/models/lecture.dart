class Lecture {
  String? id;
  String? title;
  String? description;
  String? lectureUrl;
  int? duration;
  int? sort;
  List<String>? watchedUerse;

  Lecture.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    description = data['description'];
    lectureUrl = data['lectureUrl'] ?? '';
    duration = int.tryParse(data['duration'].toString());

    title = data['title'];
    sort = data['sort'];
    watchedUerse =
        data['watched_users'] != null ? List.from(data['watched_users']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['lectureUrl'] = lectureUrl;
    data['duration'] = duration;
    data['title'] = title;
    data['sort'] = sort;
    data['watched_users'] = watchedUerse;
    return data;
  }
}
