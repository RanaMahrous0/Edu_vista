class CategoryData {
  String? name;
  String? id;

  CategoryData.fromJson(Map<String, dynamic> data, String? documentId) {
    name = data['name'];
    id = documentId ?? data['id'];
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}
