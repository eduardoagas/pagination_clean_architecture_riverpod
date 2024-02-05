import 'package:dio/dio.dart';
import 'package:pagination_clean_architecture_riverpod/core/constants/network_constants.dart';
import 'package:pagination_clean_architecture_riverpod/core/exceptions/http_exception.dart';
import 'package:pagination_clean_architecture_riverpod/shared/dio/mixins/exception_handler_mixin.dart';
import '../../../../core/remote/either.dart';
import '../../../../core/remote/network_service.dart';
import '../../../../core/remote/response.dart' as response;


//Alternativa de implementação para a classe abstrata de network service
class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  final Dio dio;
  DioNetworkService(this.dio) {
    // this throws error while running test
   // if (!kTestMode) {
      dio.options = dioBaseOptions;
   /*   if (kDebugMode) {
        dio.interceptors
            .add(LogInterceptor(requestBody: true, responseBody: true));
      //espaço para interceptores
      }*/
   // }
  }

  BaseOptions get dioBaseOptions => BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
      );
  @override
  String get baseUrl => NetworkConstants.baseUrl;

  @override
  Map<String, Object> get headers => {
        'accept': 'application/json',
        'content-type': 'application/json',
      };

  @override
  Map<String, dynamic>? updateHeader(Map<String, dynamic> data) {
    final header = {...data, ...headers};
    /* if (!kTestMode) {
      dio.options.headers = header;
    } */
    return header;
  }

  @override
  Future<Either<AppException, response.Response>> post(String endpoint,
      {Map<String, dynamic>? data}) {
    final res = handleException(
      () => dio.post(
        endpoint,
        data: data,
      ),
      endpoint: endpoint,
    );
    return res;
  }

  @override
  Future<Either<AppException, response.Response>> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) {
    final res = handleException(
      () => dio.get(
        endpoint,
        queryParameters: queryParameters,
      ),
      endpoint: endpoint,
    );
    return res;
  }
}
