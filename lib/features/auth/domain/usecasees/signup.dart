import 'package:library_app1/features/auth/domain/entities/user.dart';
import 'package:library_app1/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> call({
    required String name,
    required String email,
    required String password,
    String? fcmToken,
    required String passwordConfirmation,
    required List<int> interests,
    String? imagePath,
  }) {
    return repository.register(
      name: name,
      email: email,
      password: password,
      fcmToken: fcmToken,
      passwordConfirmation: passwordConfirmation,
      interests: interests,
      imagePath: imagePath,
    );
  }
}
