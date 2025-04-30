class UserModel {
  final String id;
  final String name;
  final String email;
  final String? password;
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
      id: map['\$id'] as String,
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
