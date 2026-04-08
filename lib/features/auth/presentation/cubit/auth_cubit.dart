// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/features/auth/domain/usecase/index.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthUsecase _authUsecase;

  AuthCubit(this._authUsecase) : super(AuthUnauthenticated()) {
    bootstrap();
  }

  void bootstrap() {
    if (_authUsecase.hasValidSession) {
      emit(AuthAuthenticated());
      return;
    }

    _authUsecase.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await _authUsecase.login(
      username: username,
      password: password,
    );

    if (result.isSuccess) {
      emit(AuthAuthenticated());
      return;
    }

    emit(AuthFailure());
  }

  void logout() {
    _authUsecase.logout();
    emit(AuthUnauthenticated());
  }
}
