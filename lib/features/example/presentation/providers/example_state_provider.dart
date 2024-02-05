//
import 'package:pagination_clean_architecture_riverpod/features/example/domain/providers/example_providers.dart';
import 'package:pagination_clean_architecture_riverpod/features/example/presentation/providers/state/example_notifier.dart';
import 'package:pagination_clean_architecture_riverpod/shared/pagination/domain/models/pagination_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exampleNotifierProvider =
    StateNotifierProvider<ExampleNotifier, PaginationState>((ref) {
  final repository = ref.watch(exampleRepositoryProvider);
  return ExampleNotifier(repository)..fetchItems();
});
