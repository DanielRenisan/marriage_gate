import '../../core/network/api_client.dart';
import '../../core/network/api_constants.dart';
import '../../data/models/api_response.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Get client token from API
  Future<ApiResponse> getClientToken() async {
    try {
      final response = await _apiClient.get(ApiConstants.clientTokenEndpoint);
      return ApiResponse.success(response);
    } catch (e) {
      print("AuthApiService: Error during getClientToken API call: $e");
      return ApiResponse.error(ApiError(
        title: 'Client Token Error',
        detail: e.toString(),
        statusCode: 500,
      ));
    }
  }

  /// Register a new user with email and password
  Future<ApiResponse> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    int loginType = ApiConstants.loginTypeEmail,
  }) async {
    print("AuthApiService: register method called");

    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'loginType': loginType,
      'phoneNumber': phoneNumber,
    };

    print("AuthApiService: Sending data to API: $data");
    print(
        "AuthApiService: Endpoint: ${ApiConstants.baseUrl}${ApiConstants.register}");

    try {
      final response = await _apiClient.post(ApiConstants.register, data: data);
      print("AuthApiService: Response received: $response");
      return response;
    } catch (e) {
      print("AuthApiService: Error during API call: $e");
      return ApiResponse.error(ApiError(
        title: 'Registration Error',
        detail: e.toString(),
        statusCode: 500,
      ));
    }
  }

  /// Login with email and password
  Future<ApiResponse> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
      'loginType': ApiConstants.loginTypeEmail,
    };

    final response = await _apiClient.post(ApiConstants.login, data: data);
    return response;
  }

  /// Login with mobile number and OTP
  Future<ApiResponse> loginWithMobile({
    required String phoneNumber,
    required String otp,
  }) async {
    final data = {
      'phoneNumber': phoneNumber,
      'otp': otp,
      'loginType': ApiConstants.loginTypeMobile,
    };

    final response = await _apiClient.post(ApiConstants.login, data: data);
    return response;
  }

  /// Login with Google
  Future<ApiResponse> loginWithGoogle({
    required String idToken,
  }) async {
    final data = {
      'idToken': idToken,
      'loginType': ApiConstants.loginTypeGoogle,
    };

    final response = await _apiClient.post(ApiConstants.login, data: data);
    return response;
  }

  /// Login with Facebook
  Future<ApiResponse> loginWithFacebook({
    required String accessToken,
  }) async {
    final data = {
      'accessToken': accessToken,
      'loginType': ApiConstants.loginTypeFacebook,
    };

    final response = await _apiClient.post(ApiConstants.login, data: data);
    return response;
  }

  /// Get user profile with bearer token
  Future<ApiResponse> getUserProfile(String token) async {
    try {
      final response = await _apiClient.get(
        '\${ApiConstants.baseUrl}/api/Profile/user',
        headers: {
          'Authorization': 'Bearer \$token',
          'Accept': 'application/json, text/plain, */*',
        },
      );
      return ApiResponse.success(response);
    } catch (e) {
      print("AuthApiService: Error during getUserProfile API call: \$e");
      return ApiResponse.error(ApiError(
        title: 'User Profile Error',
        detail: e.toString(),
        statusCode: 500,
      ));
    }
  }
}
