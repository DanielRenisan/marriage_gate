import 'package:dio/dio.dart';
import 'api_constants.dart';
import '../../data/models/api_response.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConstants.clientToken}',
          'accept': 'application/json, text/plain, */*',
          'access-control-allow-origin': '*',
        },
      ),
    );

    // Add interceptors for logging, error handling, etc.
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Generic GET method
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(path,
          queryParameters: queryParameters, options: Options(headers: headers));
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Generic POST method
  Future<ApiResponse> post(String path, {dynamic data}) async {
    try {
      print("ApiClient: POST request to $path");
      print("ApiClient: Request data: $data");
      print("ApiClient: Request headers: ${_dio.options.headers}");

      final response = await _dio.post(path, data: data);

      print("ApiClient: Response status code: ${response.statusCode}");
      print("ApiClient: Response data: ${response.data}");

      // Check if response is already in ApiResponse format
      if (response.data is Map<String, dynamic> &&
          (response.data.containsKey('IsError') ||
              response.data.containsKey('Result'))) {
        return ApiResponse.fromJson(response.data);
      }

      // If not, wrap it in a success response
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      print("ApiClient: DioException occurred: ${e.type}");
      print("ApiClient: Error message: ${e.message}");

      if (e.response != null) {
        print("ApiClient: Response status code: ${e.response!.statusCode}");
        print("ApiClient: Response data: ${e.response!.data}");

        // Check if error response is already in ApiResponse format
        if (e.response!.data is Map<String, dynamic> &&
            (e.response!.data.containsKey('IsError') ||
                e.response!.data.containsKey('Error'))) {
          return ApiResponse.fromJson(e.response!.data);
        }

        // Create ApiError from response
        final statusCode = e.response!.statusCode ?? 500;
        String title = 'Error';
        String detail = 'An error occurred';

        if (e.response!.data is Map<String, dynamic>) {
          final errorData = e.response!.data as Map<String, dynamic>;
          if (errorData.containsKey('message')) {
            detail = errorData['message'];
          } else if (errorData.containsKey('error')) {
            detail = errorData['error'];
          }
        }

        return ApiResponse.error(ApiError(
          title: title,
          detail: detail,
          statusCode: statusCode,
        ));
      }

      // Handle other Dio errors
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      print("ApiClient: Unexpected error: $e");
      return ApiResponse.error(ApiError(
        title: 'Unexpected Error',
        detail: e.toString(),
        statusCode: 500,
      ));
    }
  }

  // Generic PUT method
  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Generic DELETE method
  Future<dynamic> delete(String path, {dynamic data}) async {
    try {
      final response = await _dio.delete(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // Error handling
  ApiError _handleError(DioException e) {
    String title = 'Error';
    String detail = 'An error occurred';
    int statusCode = 500;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        title = 'Connection Timeout';
        detail = 'The connection timed out. Please try again.';
        statusCode = 408;
        break;
      case DioExceptionType.badResponse:
        if (e.response != null) {
          statusCode = e.response!.statusCode ?? 500;
          // Try to extract error message from response
          if (e.response!.data is Map) {
            if (e.response!.data['message'] != null) {
              detail = e.response!.data['message'];
            } else if (e.response!.data['error'] != null) {
              detail = e.response!.data['error'];
            }
          }
          title = 'Server Error';
        }
        break;
      case DioExceptionType.cancel:
        title = 'Request Cancelled';
        detail = 'The request was cancelled';
        statusCode = 499;
        break;
      case DioExceptionType.connectionError:
        title = 'Connection Error';
        detail = 'No internet connection';
        statusCode = 503;
        break;
      default:
        title = 'Network Error';
        detail = e.message ?? 'An unexpected network error occurred';
    }

    return ApiError(
      title: title,
      detail: detail,
      statusCode: statusCode,
    );
  }
}
