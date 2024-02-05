import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_clean_architecture_riverpode/core/constants/network_constants.dart';
import 'package:pagination_clean_architecture_riverpode/features/example/domain/models/example_item.dart';
import 'package:pagination_clean_architecture_riverpode/features/example/domain/repositories/example_repository.dart';
import 'package:pagination_clean_architecture_riverpode/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpode/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/paginated_response.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/pagination_state.dart';

class ExampleNotifier extends StateNotifier<PaginationState> {
  final ExampleRepository exampleRepository;

  ExampleNotifier(
    this.exampleRepository,
  ) : super(const PaginationState.initial());

  bool get isFetching =>
      state.state != PaginationConcreteState.loading &&
      state.state != PaginationConcreteState.fetchingMore;

  Future<void> fetchItems() async {
    if (isFetching &&
        state.state != PaginationConcreteState.fetchedAllItems) {
      state = state.copyWith(
        state: state.page > 0
            ? PaginationConcreteState.fetchingMore
            : PaginationConcreteState.loading,
        isLoading: true,
      );

      final response = await exampleRepository.fetchExampleItems(
          skip: state.page * NetworkConstants.exampleItemPerPage);

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: PaginationConcreteState.fetchedAllItems,
        message: 'No more items available',
        isLoading: false,
      );
    }
  }

  Future<void> searchItems(String query) async {
    if (isFetching &&
        state.state != PaginationConcreteState.fetchedAllItems) {
      state = state.copyWith(
        state: state.page > 0
            ? PaginationConcreteState.fetchingMore
            : PaginationConcreteState.loading,
        isLoading: true,
      );

      final response = await exampleRepository.searchExampleItems(
        skip: state.page * NetworkConstants.exampleItemPerPage,
        query: query,
      );

      updateStateFromResponse(response);
    } else {
      state = state.copyWith(
        state: PaginationConcreteState.fetchedAllItems,
        message: 'No more items available',
        isLoading: false,
      );
    }
  }

  void updateStateFromResponse(
      Either<AppException, PaginatedResponse<dynamic>> response) {
    response.fold((failure) {
      state = state.copyWith(
        state: PaginationConcreteState.failure,
        message: failure.message,
        isLoading: false,
      );
    }, (data) {
      final itemList = data.data.map((e) => ExampleItem.fromJson(e)).toList();

      final totalItems = [...state.itemList, ...itemList];

      state = state.copyWith(
        itemList: totalItems,
        state: totalItems.length == data.total
            ? PaginationConcreteState.fetchedAllItems
            : PaginationConcreteState.loaded,
        hasData: true,
        message: totalItems.isEmpty ? 'No items found' : '',
        page: totalItems.length ~/ NetworkConstants.exampleItemPerPage,
        total: data.total,
        isLoading: false,
      );
    });
  }

  void resetState() {
    state = const PaginationState.initial();
  }
}
