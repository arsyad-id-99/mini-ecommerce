import 'package:hive/hive.dart';
import '../../domain/entities/cart_entity.dart';

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

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 0;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      productId: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      thumbnail: fields[3] as String,
      quantity: fields[4] as int,
      discountPercentage: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.discountPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
