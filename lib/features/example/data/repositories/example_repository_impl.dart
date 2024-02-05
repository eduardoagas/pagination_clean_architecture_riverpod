import 'package:pagination_clean_architecture_riverpode/features/example/data/data_source/remote/example_remote_data_source.dart';
import 'package:pagination_clean_architecture_riverpode/features/example/domain/repositories/example_repository.dart';
import 'package:pagination_clean_architecture_riverpode/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpode/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/paginated_response.dart';

//Implementação da abstração da data source 
//(essa classe torna possível a injeção de dependências)
class ExampleRepositoryImpl extends ExampleRepository {
  final ExampleDatasource exampleDatasource;
  ExampleRepositoryImpl(this.exampleDatasource);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchExampleItems(
      {required int skip}) {
    return exampleDatasource.fetchPaginatedProducts(skip: skip);
  }

  @override
  Future<Either<AppException, PaginatedResponse>> searchExampleItems(
      {required int skip, required String query}) {
    return exampleDatasource.searchPaginatedProducts(
        skip: skip, query: query);
  }
}
