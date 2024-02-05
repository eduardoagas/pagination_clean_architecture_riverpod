import 'package:pagination_clean_architecture_riverpode/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpode/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/paginated_response.dart';
//Classe abstrata que faz a conexão do domain com a data e permite
//que se comuniquem

abstract class ExampleRepository {
  Future<Either<AppException, PaginatedResponse>> fetchExampleItems(
      {required int skip});
  Future<Either<AppException, PaginatedResponse>> searchExampleItems(
      {required int skip, required String query});
}
