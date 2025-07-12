import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  AuthRepositoryImpl({fb.FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance;

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  // TODO: Implement other AuthRepository methods
  @override
  Future<void> signInWithGoogle() async => throw UnimplementedError();
  @override
  Future<void> signInWithFacebook() async => throw UnimplementedError();
  @override
  Future<void> signInWithOtp(String phone, String otp) async => throw UnimplementedError();
  @override
  Future<void> signOut() async => _firebaseAuth.signOut();
  @override
  Future<bool> isSignedIn() async => _firebaseAuth.currentUser != null;
} 