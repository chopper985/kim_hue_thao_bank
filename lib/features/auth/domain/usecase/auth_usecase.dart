// Package imports:
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:kht_gold/core/utils/dio_api/result.dart';
import 'package:kht_gold/features/auth/data/models/index.dart';
import 'package:kht_gold/features/auth/data/repositories/auth_repository.dart';

@lazySingleton
class AuthUsecase {
  final AuthRepository _authRepository;

  AuthUsecase(this._authRepository);

  Future<Result<LoginResponseModel>> login({
    required String username,
    required String password,
  }) {
    return _authRepository.login(username: username, password: password);
  }

  bool get hasValidSession => _authRepository.hasValidSession;

  void logout() {
    _authRepository.logout();
  }
}
