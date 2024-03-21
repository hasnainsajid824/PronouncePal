class UserProfileModel {
  String profileName;
  String age;

  UserProfileModel({required this.profileName,required this.age});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      profileName: json['profile_name'] ?? '',
      age:json['age'] ?? '',
    );
  }
}