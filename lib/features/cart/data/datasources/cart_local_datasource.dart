import 'package:hive/hive.dart';
import '../models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartModel>> getCartItems();
  Future<void> addToCart(CartModel item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<CartModel> cartBox;

  CartLocalDataSourceImpl(this.cartBox);

  @override
  Future<List<CartModel>> getCartItems() async {
    return cartBox.values.toList();
  }

  @override
  Future<void> addToCart(CartModel item) async {
    final existingItemIndex = cartBox.values.toList().indexWhere(
      (e) => e.productId == item.productId,
    );

    if (existingItemIndex != -1) {
      final existingItem = cartBox.getAt(existingItemIndex)!;
      existingItem.quantity += item.quantity;
      await existingItem.save();
    } else {
      await cartBox.add(item);
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final itemKey = cartBox.values
        .firstWhere((e) => e.productId == productId)
        .key;
    await cartBox.delete(itemKey);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final item = cartBox.values.firstWhere((e) => e.productId == productId);
    item.quantity = quantity;
    await item.save();
  }

  @override
  Future<void> clearCart() async {
    await cartBox.clear();
  }
}
