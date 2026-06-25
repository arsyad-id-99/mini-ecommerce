part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductHomeLoaded extends ProductState {
  final List<ProductEntity> onSaleProducts;
  final List<ProductEntity> topRatedProducts;

  const ProductHomeLoaded({
    required this.onSaleProducts,
    required this.topRatedProducts,
  });

  @override
  List<Object> get props => [onSaleProducts, topRatedProducts];
}

class ProductSearchLoaded extends ProductState {
  final List<ProductEntity> searchResults;
  final bool hasReachedMax;

  const ProductSearchLoaded({
    required this.searchResults,
    required this.hasReachedMax,
  });

  @override
  List<Object> get props => [searchResults, hasReachedMax];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
  @override
  List<Object> get props => [message];
}
