import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task6_adv/models/category_data.dart';
import 'package:task6_adv/models/instructor.dart';

class Course {
  String? id;

  String? title;
  String? image;
  CategoryData? category;
  String? currency;
  bool? hasCertificate;
  Instructor? instructor;
  double? price;
  double? rating;
  int? totatlHours;
  String? rank;
  DateTime? createdDate;

  Course.fromJson(Map<String, dynamic> data) {
    title = data['title'];
    image = data['image'];
    id = data['id'];
    currency = data['currency'];
    hasCertificate = data['has_certificate '];
    price = data['price'] is int
        ? (data['price'] as int).toDouble()
        : data['price'];
    rating = data['rating'] is int
        ? (data['rating'] as int).toDouble()
        : data['rating'];
    rank = data['rank'];
    createdDate = data['created_date'] != null
        ? (data['created_date'] as Timestamp).toDate()
        : null;
    totatlHours = data['total_hours'];
    category = data['category'] != null
        ? CategoryData.fromJson(data['category'])
        : null;
    instructor = data['instructor'] != null
        ? Instructor.fromJson(data['instructor'])
        : null;
  }
}
