abstract class AuthRepository {
  Future<void> signInWithEmail(String email, String password);
  Future<void> signInWithGoogle();
  Future<void> signInWithFacebook();
  Future<void> signInWithOtp(String phone, String otp);
  Future<void> signOut();
  Future<bool> isSignedIn();
} 