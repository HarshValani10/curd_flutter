// Set authentication token
import '../../model/categorymodel.dart';

class SetAuthToken {
  final String token;
  SetAuthToken(this.token);
}

// Clear authentication token
class ClearAuthToken {}

// Set categories
class SetCategories {
  final List<CategoryModel> categories;
  SetCategories(this.categories);
}

// Set loading state
class SetLoading {
  final bool isLoading;
  SetLoading(this.isLoading);
}
