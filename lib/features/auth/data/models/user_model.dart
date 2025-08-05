import 'package:blogs_app/features/auth/domain/entity/user.dart' show User;

class UserModel extends User {
  UserModel({required super.id, required super.email, required super.name});
   factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ??'',
      email: json['email']??'',
    );
  }
}
