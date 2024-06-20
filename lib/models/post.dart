import 'package:gym_gram_app/models/user.dart';
import 'package:gym_gram_app/models/workout.dart';

class Post {
  Post(
      {required this.id,
      required this.workout,
      required this.user,
      required this.photo,
      required this.description,
      required this.numLikes,
      required this.numComments,
      required this.likedBy});

  String id;
  Workout workout;
  ShortUser user;
  String photo;
  String description;
  int numLikes;
  int numComments;
  List<String> likedBy;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] as String,
      user: ShortUser.fromJson(json['user']),
      workout: Workout.fromJson(json['workout']),
      photo: json['photo'] as String,
      description: json['description'] as String,
      numLikes: json['numLikes'] as int,
      numComments: json['numComments'] as int,
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Post copyWith({
    String? id,
    Workout? workout,
    ShortUser? user,
    String? photo,
    String? description,
    int? numLikes,
    int? numComments,
    List<String>? likedBy,
  }) {
    return Post(
      id: id ?? this.id,
      workout: workout ?? this.workout,
      user: user ?? this.user,
      photo: photo ?? this.photo,
      description: description ?? this.description,
      numLikes: numLikes ?? this.numLikes,
      numComments: numComments ?? this.numComments,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
