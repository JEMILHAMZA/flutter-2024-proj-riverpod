import 'package:quiz_app/features/auth/domain/usecases/delete_user_usecase.dart';
import 'package:quiz_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:quiz_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:quiz_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:quiz_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:quiz_app/features/auth/domain/usecases/update_username_usecase.dart';
import 'package:quiz_app/features/auth/presentation/riverpod/auth_state.dart';
import 'package:riverpod/riverpod.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final Login login;
  final Signup signUp;
  final Logout logout;
  final UpdatePassword updatePassword;
  final UpdateUsername updateUsername;
  final DeleteUser deleteUser;

  AuthNotifier(
      {required this.deleteUser,
      required this.login,
      required this.logout,
      required this.signUp,
      required this.updatePassword,
      required this.updateUsername})
      : super(const AuthState.initial());

  Future<void> loginEvent(String userId, String password, String role) async {
    state = const AuthState.loading();
    final result = await login(
        LoginParams(userId: userId, password: password, role: role));
    result.fold(
      (failure) => state = const AuthState.failure(failure.message),
      (success) => state = const AuthState.success('Login successful'),
    );
  }

  Future<void> signupEvent(
      String username, String password, String email, String role) async {
    state = const AuthState.loading();
    final result = await signUp(SignupParams(
        username: username, password: password, email: email, role: role));
    result.fold(
      (failure) => state = const AuthState.failure(failure.message),
      (success) => state = const AuthState.success('Sign Up Successful'),
    );
  }

  Future<void> logoutEvent() async {
    state = const AuthState.loading();
    await logout();
    state = const AuthState.success('Logged out successfully');
  }

  Future<void> updatePasswordEvent(UpdatePasswordParams params) async {
    state = const AuthState.loading();
    final result = await updatePassword(params);
    result.fold(
      (failure) =>
          state = const AuthState.failure('Password update unsuccessful'),
      (success) => state = const AuthState.success('Update Successful'),
    );
  }

  Future<void> updateUsernameEvent(String newUsername) async {
    state = const AuthState.loading();
    final result = await updateUsername(newUsername);
    result.fold(
      (failure) => state = const AuthState.failure(failure.message),
      (success) => state = const AuthState.success('Update Successful'),
    );
  }

  Future<void> deleteUserEvent() async {
    state = const AuthState.loading();
    final result = await deleteUser();
    result.fold(
      (failure) => state = const AuthState.failure(failure.message),
      (success) =>
          state = const AuthState.success('We\'re sorry to see you go'),
    );
  }
}
