import 'package:equatable/equatable.dart';
import 'package:task6_adv/models/course.dart';

class CartState extends Equatable {
  final List<Course> cartItems;
  final String? errorMessage;
  const CartState({
    required this.cartItems,
    this.errorMessage,
  });

  CartState copyWith({
    List<Course>? cartItems,
    String? errorMessage,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [cartItems, errorMessage];
}
