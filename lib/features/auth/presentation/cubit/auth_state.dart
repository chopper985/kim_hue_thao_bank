part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthUnauthenticated extends AuthState {}

final class AuthAuthenticated extends AuthState {}
