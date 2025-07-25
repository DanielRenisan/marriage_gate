import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _clientTokenKey = 'client_token';

  AuthRepositoryImpl({
    AuthApiService? authApiService,
  }) : _authApiService = authApiService ?? AuthApiService();

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await _authApiService.loginWithEmail(
        email: email,
        password: password,
      );

      if (response.isError) {
        throw Exception(response.error?.detail ?? 'Login failed');
      }

      // Save auth token and user info
      if (response.result != null && response.result is Map<String, dynamic>) {
        await _saveAuthData(response.result as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<String?> getClientToken() async {
    try {
      final response = await _authApiService.getClientToken();
      if (response.isError) {
        throw Exception(response.error?.detail ?? 'Failed to get client token');
      }
      if (response.result != null && response.result is Map<String, dynamic>) {
        final token =
            (response.result as Map<String, dynamic>)['token'] as String?;
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_clientTokenKey, token);
          return token;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get client token: ${e.toString()}');
    }
  }

  @override
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      print("AuthRepositoryImpl: signUp method called");
      print("AuthRepositoryImpl: Calling register API with data:");
      print("First Name: $firstName");
      print("Last Name: $lastName");
      print("Email: $email");
      print("Mobile: $mobile");

      final response = await _authApiService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: mobile,
        password: password,
      );

      print("AuthRepositoryImpl: API response received: $response");

      // Check if there was an error
      if (response.isError) {
        print(
            "AuthRepositoryImpl: Error in response: ${response.error?.detail}");
        throw Exception(response.error?.detail ?? 'Sign up failed');
      }

      // Save auth token and user info if registration also logs the user in
      if (response.result != null && response.result is Map<String, dynamic>) {
        final resultMap = response.result as Map<String, dynamic>;
        if (resultMap.containsKey('token') || resultMap.containsKey('userId')) {
          print("AuthRepositoryImpl: Saving auth data");
          await _saveAuthData(resultMap);
        }
      }
    } catch (e) {
      print("AuthRepositoryImpl: Error during signup: ${e.toString()}");
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in aborted');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      final response = await _authApiService.loginWithGoogle(idToken: idToken);

      if (response.isError) {
        throw Exception(response.error?.detail ?? 'Google sign-in failed');
      }

      if (response.result != null && response.result is Map<String, dynamic>) {
        await _saveAuthData(response.result as Map<String, dynamic>);
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      if (token != null) {
        final profileResponse = await getUserProfile(token);
        if (profileResponse.isError) {
          throw Exception(
              profileResponse.error?.detail ?? 'Failed to get user profile');
        }
      }
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithFacebook() async {
    try {
      // TODO: Implement Facebook SDK integration here
      throw UnimplementedError('Facebook sign-in not implemented yet');
    } catch (e) {
      throw Exception('Facebook sign-in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithOtp(String phone, String otp) async {
    try {
      final response = await _authApiService.loginWithMobile(
        phoneNumber: phone,
        otp: otp,
      );

      if (response.isError) {
        throw Exception(response.error?.detail ?? 'OTP login failed');
      }

      if (response.result != null && response.result is Map<String, dynamic>) {
        await _saveAuthData(response.result as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('OTP login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  @override
  Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<dynamic> getUserProfile(String token) async {
    return await _authApiService.getUserProfile(token);
  }

  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();

    if (response.containsKey('token')) {
      await prefs.setString(_tokenKey, response['token']);
    }

    if (response.containsKey('userId')) {
      await prefs.setString(_userIdKey, response['userId']);
    }
  }
}
