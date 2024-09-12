import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task6_adv/Cubits/cart/cubit/cart_state.dart';
import 'package:task6_adv/models/course.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState(cartItems: []));

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchCartItems() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return; 

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      List<Course> cartItems = snapshot.docs
          .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      emit(CartState(cartItems: cartItems));
    } catch (e) {
      print("Error fetching cart items: $e");
    }
  }


  Future<void> addToCart(Course course) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return; 

   
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(course.id)
          .set(course.toJson());

      await fetchCartItems();
    } catch (e) {
      emit(state.copyWith(errorMessage: "Error adding to cart: $e"));
    }
  }


  Future<void> removeFromCart(String courseId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return; 

    
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(courseId)
          .delete();

   
      List<Course> updatedItems = List.from(state.cartItems)
        ..removeWhere((course) => course.id == courseId);

      emit(state.copyWith(cartItems: updatedItems));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Error removing from cart: $e"));
    }
  }

  void toggleExpand(Course course) {
    final updatedItems = state.cartItems.map((item) {
      if (item.id == course.id) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }
      return item;
    }).toList();
    emit(CartState(cartItems: updatedItems));
  }


  void buyNow(String courseId) {
    print("Buying course with ID: $courseId");
  }
}
