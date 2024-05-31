import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? message;

  const AuthState._({required this.status, this.message});

  const AuthState.initial() : this._(status: AuthStatus.initial);
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.success(String message)
      : this._(status: AuthStatus.success, message: message);
  const AuthState.failure(String message)
      : this._(status: AuthStatus.failure, message: message);

  @override
  List<Object?> get props => [status, message];
}
