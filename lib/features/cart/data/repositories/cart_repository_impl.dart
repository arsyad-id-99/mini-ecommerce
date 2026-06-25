import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<List<CartEntity>> getCartItems() async {
    final models = await localDataSource.getCartItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addToCart(CartEntity item) async {
    final model = CartModel.fromEntity(item);
    await localDataSource.addToCart(model);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    await localDataSource.removeFromCart(productId);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    await localDataSource.updateQuantity(productId, quantity);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}
