import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_clean_architecture_riverpod/features/example/data/data_source/remote/example_remote_data_source.dart';
import 'package:pagination_clean_architecture_riverpod/features/example/data/repositories/example_repository_impl.dart';
import 'package:pagination_clean_architecture_riverpod/features/example/domain/repositories/example_repository.dart';
import 'package:pagination_clean_architecture_riverpod/core/remote/network_service.dart';
import 'package:pagination_clean_architecture_riverpod/shared/dio/providers/dio_network_service_provider.dart';

//DOMAIN PROVIDERS fazem a injeção de dependência

//usar a implementação de exampleRemote num provider que retorna um exampledata e tem como parametro um networkservice
final exampleDatasourceProvider =
    Provider.family<ExampleDatasource, NetworkService>(
  (_, networkService) => ExampleRemoteDatasource(networkService),
);

final exampleRepositoryProvider = Provider<ExampleRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  final datasource = ref.watch(exampleDatasourceProvider(networkService));
  final repository = ExampleRepositoryImpl(datasource);

  return repository;
});
