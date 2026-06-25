part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final ProductEntity product;
  final int quantity;

  const AddToCart({required this.product, this.quantity = 1});

  @override
  List<Object> get props => [product, quantity];
}

class UpdateCartQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartQuantity({required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class RemoveFromCart extends CartEvent {
  final int productId;
  const RemoveFromCart(this.productId);
  @override
  List<Object> get props => [productId];
}

class ClearCartEvent extends CartEvent {}
