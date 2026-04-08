// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthUnauthenticated());

  void login() {
    emit(AuthAuthenticated());
  }

  void logout() {
    emit(AuthUnauthenticated());
  }
}
