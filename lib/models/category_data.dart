class CategoryData {
  String? name;
  String? id;

  CategoryData.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    id = data['id'];
  }
}
