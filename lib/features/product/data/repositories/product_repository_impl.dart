import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getOnSaleProducts() async =>
      await remoteDataSource.getOnSaleProducts();

  @override
  Future<List<ProductEntity>> getTopRatedProducts() async =>
      await remoteDataSource.getTopRatedProducts();

  @override
  Future<List<ProductEntity>> searchProducts(
    String query, {
    int limit = 10,
    int skip = 0,
  }) async {
    return await remoteDataSource.searchProducts(query, limit, skip);
  }
}
