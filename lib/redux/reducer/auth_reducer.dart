import '../action/auth_action.dart';

String authReducer(String state, dynamic action) {
  if (action is SetAuthToken) {
    return action.token;
  } else if (action is ClearAuthToken) {
    return "";
  }
  return state;
}
