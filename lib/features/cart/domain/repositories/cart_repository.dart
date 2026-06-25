import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<List<CartEntity>> getCartItems();
  Future<void> addToCart(CartEntity item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}
