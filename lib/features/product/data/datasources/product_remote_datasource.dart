import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getOnSaleProducts();
  Future<List<ProductModel>> getTopRatedProducts();
  Future<List<ProductModel>> searchProducts(String query, int limit, int skip);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getOnSaleProducts() async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {
          'sortBy': 'discountPercentage',
          'order': 'desc',
          'limit': 8,
        },
      );
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mengambil On Sale');
    }
  }

  @override
  Future<List<ProductModel>> getTopRatedProducts() async {
    try {
      final response = await dio.get(
        '/products',
        queryParameters: {'sortBy': 'rating', 'order': 'desc', 'limit': 8},
      );
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Gagal mengambil Top Rated',
      );
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(
    String query,
    int limit,
    int skip,
  ) async {
    try {
      final response = await dio.get(
        '/products/search',
        queryParameters: {'q': query, 'limit': limit, 'skip': skip},
      );
      final List productsList = response.data['products'];
      return productsList
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal mencari produk');
    }
  }
}
