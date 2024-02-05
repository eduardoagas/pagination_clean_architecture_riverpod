import 'package:pagination_clean_architecture_riverpode/core/constants/network_constants.dart';
import 'package:pagination_clean_architecture_riverpode/core/remote/network_service.dart';
import 'package:pagination_clean_architecture_riverpode/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpode/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpode/shared/pagination/domain/models/paginated_response.dart';

abstract class ExampleDatasource { //forks to remote and local
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedProducts(
      {required int skip});
  Future<Either<AppException, PaginatedResponse>> searchPaginatedProducts(
      {required int skip, required String query});
}
//Implement logic
class ExampleRemoteDatasource extends ExampleDatasource {
  final NetworkService networkService;
  ExampleRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedProducts(
      {required int skip}) async {
    final response = await networkService.get(
      NetworkConstants.exampleItemEndpoint,
      queryParameters: {
        'skip': skip,
        'limit': NetworkConstants.exampleItemPerPage,
      },
    );

    return response.fold(
      (l) => Left(l),
      (r) {
        final jsonData = r.data;
        if (jsonData == null) {
          return Left(
            AppException(
              identifier: 'fetchPaginatedData',
              statusCode: 0,
              message: 'The data is not in the valid format.',
            ),
          );
        }
        final paginatedResponse =
            PaginatedResponse.fromJson(jsonData, jsonData['products'] ?? []);
        return Right(paginatedResponse);
      },
    );
  }

  @override
  Future<Either<AppException, PaginatedResponse>> searchPaginatedProducts(
      {required int skip, required String query}) async {
    final response = await networkService.get(
      '${NetworkConstants.exampleItemSearchEndpoint}$query',
      queryParameters: {
        'skip': skip,
        'limit': NetworkConstants.exampleItemPerPage,
      },
    );

    return response.fold(
      (l) => Left(l),
      (r) {
        final jsonData = r.data;
        if (jsonData == null) {
          return Left(
            AppException(
              identifier: 'search PaginatedData',
              statusCode: 0,
              message: 'The data is not in the valid format.',
            ),
          );
        }
        final paginatedResponse =
            PaginatedResponse.fromJson(jsonData, jsonData['products'] ?? []);
        return Right(paginatedResponse);
      },
    );
  }
}
