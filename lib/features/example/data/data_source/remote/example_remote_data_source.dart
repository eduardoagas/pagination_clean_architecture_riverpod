import 'package:pagination_clean_architecture_riverpod/core/constants/network_constants.dart';
import 'package:pagination_clean_architecture_riverpod/core/remote/network_service.dart';
import 'package:pagination_clean_architecture_riverpod/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpod/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpod/shared/pagination/domain/models/paginated_response.dart';

abstract class ExampleDatasource { //forks to remote and local
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedItems(
      {required int skip});
  Future<Either<AppException, PaginatedResponse>> searchPaginatedItems(
      {required int skip, required String query});
}
//Implement logic
class ExampleRemoteDatasource extends ExampleDatasource {
  final NetworkService networkService;
  ExampleRemoteDatasource(this.networkService);

  @override
  Future<Either<AppException, PaginatedResponse>> fetchPaginatedItems(
      {required int skip}) async {
    final response = await networkService.get(
      NetworkConstants.exampleItemEndpoint,
      queryParameters: {
        NetworkConstants.exampleSkipName: skip,
        NetworkConstants.exampleLimitName: NetworkConstants.exampleItemPerPage,
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
            PaginatedResponse.fromJson(jsonData, jsonData[NetworkConstants.exampleDataName] ?? []);
        return Right(paginatedResponse);
      },
    );
  }

  @override
  Future<Either<AppException, PaginatedResponse>> searchPaginatedItems(
      {required int skip, required String query}) async {
    final response = await networkService.get(
      '${NetworkConstants.exampleItemSearchEndpoint}$query',
      queryParameters: {
        NetworkConstants.exampleSkipName: skip,
        NetworkConstants.exampleLimitName: NetworkConstants.exampleItemPerPage,
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
            PaginatedResponse.fromJson(jsonData, jsonData[NetworkConstants.exampleDataName] ?? []);
        return Right(paginatedResponse);
      },
    );
  }
}
