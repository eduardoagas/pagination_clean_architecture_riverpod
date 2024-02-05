import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/pagination/domain/models/pagination_item.dart';
part 'example_item.freezed.dart';
part 'example_item.g.dart';

typedef ExampleItemList = List<ExampleItem>;

@freezed
class ExampleItem extends Item with _$ExampleItem {
  factory ExampleItem({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String description,
    @Default('') String thumbnail,
    @Default('') String brand,
    @Default('') String category,
    @Default(0.0) double rating,
    @Default(0.0) double discountPercentage,
    @Default(0) int stock,
    @Default(0) int price,
    @Default([]) List<String> images,
  }) = _ExampleItem;

  factory ExampleItem.fromJson(dynamic json) => _$ExampleItemFromJson(json);
}
