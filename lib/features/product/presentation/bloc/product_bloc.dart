import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final int _limit = 20;
  int _searchSkip = 0;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchHomeProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final results = await Future.wait([
          repository.getOnSaleProducts(),
          repository.getTopRatedProducts(),
        ]);

        emit(
          ProductHomeLoaded(
            onSaleProducts: results[0],
            topRatedProducts: results[1],
          ),
        );
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });

    on<SearchProducts>((event, emit) async {
      if (event.query.isEmpty) {
        emit(ProductInitial());
        return;
      }

      try {
        if (!event.isLoadMore) {
          emit(ProductLoading());
          _searchSkip = 0;
          final results = await repository.searchProducts(
            event.query,
            limit: _limit,
            skip: _searchSkip,
          );

          _searchSkip += _limit;
          emit(
            ProductSearchLoaded(
              searchResults: results,
              hasReachedMax: results.length < _limit,
            ),
          );
        } else {
          final currentState = state;
          if (currentState is ProductSearchLoaded &&
              !currentState.hasReachedMax) {
            final results = await repository.searchProducts(
              event.query,
              limit: _limit,
              skip: _searchSkip,
            );

            _searchSkip += _limit;
            emit(
              ProductSearchLoaded(
                searchResults: currentState.searchResults + results,
                hasReachedMax: results.length < _limit,
              ),
            );
          }
        }
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
