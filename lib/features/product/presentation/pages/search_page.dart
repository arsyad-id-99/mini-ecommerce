// lib/features/product/presentation/pages/search_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/cart_helper.dart';
import '../bloc/product_bloc.dart';
import '../widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200.h) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductSearchLoaded && !state.hasReachedMax) {
        context.read<ProductBloc>().add(
          SearchProducts(_searchController.text, isLoadMore: true),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProducts(query));
      } else {
        context.read<ProductBloc>().add(const SearchProducts(''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                _searchController.clear();
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          } else if (state is ProductSearchLoaded) {
            if (state.searchResults.isEmpty) {
              return Center(
                child: Text(
                  'Produk tidak ditemukan',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              );
            }
            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.58,
              ),
              itemCount: state.hasReachedMax
                  ? state.searchResults.length
                  : state.searchResults.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.searchResults.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = state.searchResults[index];
                return ProductCard(
                  product: product,
                  onAddToCart: () =>
                      CartHelper.handleAddToCart(context, product),
                );
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search, size: 64.w, color: Colors.grey[400]),
                SizedBox(height: 16.h),
                Text(
                  'Ketikkan nama produk di atas',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
