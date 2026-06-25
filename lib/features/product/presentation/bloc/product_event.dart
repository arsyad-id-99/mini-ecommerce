part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchHomeProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  final bool isLoadMore;
  const SearchProducts(this.query, {this.isLoadMore = false});
  @override
  List<Object> get props => [query, isLoadMore];
}
