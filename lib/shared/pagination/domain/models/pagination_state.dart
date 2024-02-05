// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'pagination_item.dart';

enum PaginationConcreteState {
  initial,
  loading,
  loaded,
  failure,
  fetchingMore,
  fetchedAllItems
}

class PaginationState extends Equatable {
  final List<Item> itemList;
  final int total;
  final int page;
  final bool hasData;
  final PaginationConcreteState state;
  final String message;
  final bool isLoading;
  const PaginationState({
    this.itemList = const [],
    this.isLoading = false,
    this.hasData = false,
    this.state = PaginationConcreteState.initial,
    this.message = '',
    this.page = 0,
    this.total = 0,
  });

  const PaginationState.initial({
    this.itemList = const [],
    this.total = 0,
    this.page = 0,
    this.isLoading = false,
    this.hasData = false,
    this.state = PaginationConcreteState.initial,
    this.message = '',
  });

  PaginationState copyWith({
    List<Item>? itemList,
    int? total,
    int? page,
    bool? hasData,
    PaginationConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return PaginationState(
      isLoading: isLoading ?? this.isLoading,
      itemList: itemList ?? this.itemList,
      total: total ?? this.total,
      page: page ?? this.page,
      hasData: hasData ?? this.hasData,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return 'PaginationState(isLoading:$isLoading, itemLength: ${itemList.length},total:$total page: $page, hasData: $hasData, state: $state, message: $message)';
  }

  @override
  List<Object?> get props => [itemList, page, hasData, state, message];
}
