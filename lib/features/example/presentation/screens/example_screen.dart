import 'dart:async';
//import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pagination_clean_architecture_riverpode/features/example/domain/models/example_item.dart';
import 'package:pagination_clean_architecture_riverpode/features/example/presentation/providers/example_state_provider.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/pagination_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//@RoutePage()
class ExampleScreen extends ConsumerStatefulWidget {
  static const String routeName = 'ExampleScreen';

  const ExampleScreen({super.key});

  @override
  ConsumerState<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends ConsumerState<ExampleScreen> {
  final scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  bool isSearchActive = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerListener);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void scrollControllerListener() {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      final notifier = ref.read(exampleNotifierProvider.notifier);
      if (isSearchActive) {
        notifier.searchItems(searchController.text);
      } else {
        notifier.fetchItems();
      }
    }
  }

  void refreshScrollControllerListener() {
    scrollController.removeListener(scrollControllerListener);
    scrollController.addListener(scrollControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exampleNotifierProvider);

    ref.listen(
      exampleNotifierProvider.select((value) => value),
      ((PaginationState? previous, PaginationState next) {
        //show Snackbar on failure
        if (next.state == PaginationConcreteState.fetchedAllItems) {
          if (next.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(next.message.toString())));
          }
        }
      }),
    );
    return Scaffold(
      appBar: AppBar(
        title: isSearchActive
            ? TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search here',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
                controller: searchController,
                onChanged: _onSearchChanged,
              )
            : const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {
                isSearchActive = !isSearchActive;
              });

              ref.read(exampleNotifierProvider.notifier).resetState();
              if (!isSearchActive) {
                ref.read(exampleNotifierProvider.notifier).fetchItems();
              }
              refreshScrollControllerListener();
            },
            icon: Icon(
              isSearchActive ? Icons.clear : Icons.search,
            ),
          ),
        ],
      ),
      drawer: const Placeholder(),
      body: state.state == PaginationConcreteState.loading
          ? const Center(child: CircularProgressIndicator())
          : state.hasData
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        child: ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          controller: scrollController,
                          itemCount: state.itemList.length,
                          itemBuilder: (context, index) {
                            ExampleItem exampleItem = state.itemList[index] as ExampleItem;
                            //final exampleItem = state.itemList[index];
                            return ListTile(
                              leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(exampleItem.thumbnail)),
                              title: Text(
                                exampleItem.title,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: Text(
                                '\$${exampleItem.price}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                exampleItem.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.state == PaginationConcreteState.fetchingMore)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(exampleNotifierProvider.notifier).searchItems(query);
    });
  }
}
