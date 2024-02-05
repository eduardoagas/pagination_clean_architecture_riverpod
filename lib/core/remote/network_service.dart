
import 'package:pagination_clean_architecture_riverpod/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpod/core/remote/either.dart';
import 'package:pagination_clean_architecture_riverpod/core/remote/response.dart';

abstract class NetworkService {
  String get baseUrl;

  Map<String, Object> get headers;

  void updateHeader(Map<String, dynamic> data);

  Future<Either<AppException, Response>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<AppException, Response>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  });
}
