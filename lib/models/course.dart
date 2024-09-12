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
  bool isExpanded = false;
  Course({
    required this.id,
    required this.title,
    required this.image,
    required this.instructor,
    required this.rating,
    required this.price,
    this.isExpanded = false,
  });
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
        ? CategoryData.fromJson(data['category'], null)
        : null;
    instructor = data['instructor'] != null
        ? Instructor.fromJson(data['instructor'])
        : null;
    isExpanded = data['isExpanded'] ?? false;
  }

  Course copyWith({
    String? id,
    String? title,
    String? image,
    Instructor? instructor,
    double? rating,
    double? price,
    bool? isExpanded,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      instructor: instructor ?? this.instructor,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'id': id,
      'currency': currency,
      'has_certificate ': hasCertificate,
      'price': price,
      'rating': rating,
      'rank': rank,
      'created_date': createdDate,
      'total_hours': totatlHours,
      'category': category?.toJson(),
      'instructor': instructor?.toJson(),
    };
  }
}
