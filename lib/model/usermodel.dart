import 'dart:convert';

class UserModel {
  final String idToken;

  UserModel({required this.idToken});

  /// Factory method to create an instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idToken: json["id_token"],
    );
  }

  /// Convert `UserModel` to JSON (useful if needed for local storage)
  Map<String, dynamic> toJson() {
    return {
      "id_token": idToken,
    };
  }

  /// Convert API response string to `UserModel`
  static UserModel fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserModel.fromJson(jsonMap);
  }
}
