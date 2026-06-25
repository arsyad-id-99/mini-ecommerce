part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartEntity> items;

  const CartLoaded({required this.items});

  double get totalCartPrice {
    return items.fold(0, (total, item) => total + item.totalItemPrice);
  }

  int get totalItemsCount {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object> get props => [message];
}
