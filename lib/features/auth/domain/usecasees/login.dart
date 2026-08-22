import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password, String? fcmToken) async {
    return repository.login(email, password, fcmToken);
  }
}
