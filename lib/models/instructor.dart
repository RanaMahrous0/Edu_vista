class Instructor {
  String? name;
  int? yearsOfExperience;
  String? graduatedForm;
  String? id;

  Instructor.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    id = data['id'];
    yearsOfExperience = data['years_of_experience'];
    graduatedForm = data['graduated_form'];
  }
}
