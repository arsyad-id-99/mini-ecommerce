import 'package:hive/hive.dart';
import '../../domain/entities/cart_entity.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 0)
class CartModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String thumbnail;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  final double discountPercentage;

  CartModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.discountPercentage,
  });

  CartEntity toEntity() {
    return CartEntity(
      productId: productId,
      title: title,
      price: price,
      discountPercentage: discountPercentage,
      thumbnail: thumbnail,
      quantity: quantity,
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      productId: entity.productId,
      title: entity.title,
      price: entity.price,
      discountPercentage: entity.discountPercentage,
      thumbnail: entity.thumbnail,
      quantity: entity.quantity,
    );
  }
}
