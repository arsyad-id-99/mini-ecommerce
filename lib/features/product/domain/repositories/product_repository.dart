import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getOnSaleProducts();
  Future<List<ProductEntity>> getTopRatedProducts();
  Future<List<ProductEntity>> searchProducts(
    String query, {
    int limit = 10,
    int skip = 0,
  });
}
