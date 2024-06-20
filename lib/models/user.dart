class User {
  User(
      {required this.id,
      required this.username,
      this.email,
      required this.photo,
      this.role,
      required this.numFollowers,
      required this.numFollowing,
      required this.followedBy,
      required this.following,
      required this.savedWorkouts});

  final String id;
  final String username;
  final String? email;
  final String photo;
  final String? role;
  final int numFollowers;
  final int numFollowing;
  final List<String> followedBy;
  final List<String> following;
  final List<String> savedWorkouts;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'] as String,
        username: json['username'] as String,
        email: json['email'] as String?,
        photo: json['photo'] as String,
        role: json['role'] as String?,
        numFollowers: json['numFollowers'] as int,
        numFollowing: json['numFollowing'] as int,
        following: (json['following'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        followedBy: (json['followedBy'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        savedWorkouts: (json['savedWorkouts'] as List<dynamic>)
            .map((w) => w as String)
            .toList());
  }
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? photo,
    String? role,
    int? numFollowers,
    int? numFollowing,
    List<String>? followedBy,
    List<String>? following,
    List<String>? savedWorkouts,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      role: role ?? this.role,
      numFollowers: numFollowers ?? this.numFollowers,
      numFollowing: numFollowing ?? this.numFollowing,
      followedBy: followedBy ?? this.followedBy,
      following: following ?? this.following,
      savedWorkouts: savedWorkouts ?? this.savedWorkouts,
    );
  }
}

class ShortUser {
  ShortUser({required this.id, required this.username, required this.photo});

  final String id;
  final String username;
  final String photo;

  factory ShortUser.fromJson(Map<String, dynamic> json) {
    return ShortUser(
      id: json['_id'] as String,
      username: json['username'] as String,
      photo: json['photo'] as String,
    );
  }
}
