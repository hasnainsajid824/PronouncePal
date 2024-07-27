class UserProfileModel {
  String profileName;
  String age;
  double progress;
  int correctly_pronounced_words;
  int total_words_attempted;

  UserProfileModel(
      {required this.profileName,
       required this.age, 
       this.progress = 0, 
       this.correctly_pronounced_words=0,
        this.total_words_attempted = 0
      });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      profileName: json['profile_name'] ?? '',
      age: json['age'] ?? '',
      progress: json['progress'] ?? '',
      correctly_pronounced_words: json['correctly_pronounced_words'] ?? '',
      total_words_attempted: json['total_words_attempted'] ?? '',
    );
  }
}
