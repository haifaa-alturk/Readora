abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}
class RegisterEvent extends AuthEvent {
  final String name, email, password, confirmPassword;
  final List<int> interests;
  final String? imagePath;

  RegisterEvent({
    required this.name, required this.email,
    required this.password, required this.confirmPassword,
    required this.interests, this.imagePath,
  });
}
class GetCategoriesEvent extends AuthEvent {}