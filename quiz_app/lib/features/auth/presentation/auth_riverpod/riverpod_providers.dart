//riverpod providers

import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = Provider<Login>((ref) {
  return login;
});
final signUpProvider = Provider<Signup>((ref) {
  return signUp;
});

final logoutProvider = Provider<Logout>((ref) {
  return logout;
});

final updatePasswordProvider = Provider<UpdatePassword>((ref) {
  return updatePassword;
});

final updateUsernameProvider = Provider<UpdateUsername>((ref) {
  return updateUsername;
});

final deleteUserProvider = Provider<DeleteUser>((ref) {
  return deleteUser;
});
