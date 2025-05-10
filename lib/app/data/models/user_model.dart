import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String? profilePicture;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.profilePicture,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[r'$id'] as String? ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      password: map['password'] as String?,
      profilePicture: map['profilePicture'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{
      'name': name,
      'email': email,
    };
    if (password != null) data['password'] = password;
    if (profilePicture != null) data['profilePicture'] = profilePicture;
    return data;
  }
}
