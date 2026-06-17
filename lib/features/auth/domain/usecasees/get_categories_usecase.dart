import 'package:library_app1/features/auth/data/models/Category_Model.dart';
import 'package:library_app1/features/auth/domain/repositories/auth_repository.dart';

class GetCategoriesUseCase {
  final AuthRepository repository;
  GetCategoriesUseCase(this.repository);

  Future<List<CategoryModel>> call() {
    return repository.getCategories();
  }
}