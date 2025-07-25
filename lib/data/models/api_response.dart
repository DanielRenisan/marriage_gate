class ApiResponse<T> {
  final T? result;
  final bool isError;
  final ApiError? error;

  ApiResponse({
    this.result,
    required this.isError,
    this.error,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      result: json['Result'],
      isError: json['IsError'] ?? false,
      error: json['Error'] != null ? ApiError.fromJson(json['Error']) : null,
    );
  }

  factory ApiResponse.success(T? result) {
    return ApiResponse(
      result: result,
      isError: false,
    );
  }

  factory ApiResponse.error(ApiError error) {
    return ApiResponse(
      result: null,
      isError: true,
      error: error,
    );
  }
}

class ApiError {
  final String title;
  final String detail;
  final int statusCode;

  ApiError({
    required this.title,
    required this.detail,
    required this.statusCode,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      title: json['Title'] ?? 'Error',
      detail: json['Detail'] ?? 'An unknown error occurred',
      statusCode: json['StatusCode'] ?? 500,
    );
  }

  @override
  String toString() {
    return detail;
  }
}
