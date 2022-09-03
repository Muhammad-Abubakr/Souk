// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final File? image;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.image,
  });

  Product.copyWith(
    Product product,
  )   : id = product.id,
        title = product.title,
        description = product.description,
        price = product.price,
        imageUrl = product.imageUrl,
        image = product.image;

  const Product.empty()
      : id = '',
        title = '',
        description = '',
        price = 0,
        imageUrl = '',
        image = null;

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    File? image,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        imageUrl,
        image,
      ];
}
