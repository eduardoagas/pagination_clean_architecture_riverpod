// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExampleItemImpl _$$ExampleItemImplFromJson(Map<String, dynamic> json) =>
    _$ExampleItemImpl(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      category: json['category'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExampleItemImplToJson(_$ExampleItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'thumbnail': instance.thumbnail,
      'brand': instance.brand,
      'category': instance.category,
      'rating': instance.rating,
      'discountPercentage': instance.discountPercentage,
      'stock': instance.stock,
      'price': instance.price,
      'images': instance.images,
    };
