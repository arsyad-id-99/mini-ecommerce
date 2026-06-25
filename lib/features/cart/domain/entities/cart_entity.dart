import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final int productId;
  final String title;
  final double price;
  final double discountPercentage;
  final String thumbnail;
  final int quantity;

  const CartEntity({
    required this.productId,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.thumbnail,
    required this.quantity,
  });

  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  double get totalItemPrice {
    return discountedPrice * quantity;
  }

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
    productId,
    title,
    price,
    discountPercentage,
    thumbnail,
    quantity,
  ];
}
