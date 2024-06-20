enum MuscleGroup {
  back,
  chest,
  biceps,
  triceps,
  shoulders,
  quads,
  hamstrings,
  calves,
  ab,
  forearms,
  trapezius,
  lats,
  glutes,
  unknown,
}

class Exercise {
  //

  Exercise(
      {required this.id,
      required this.name,
      required this.createdBy,
      required this.muscleGroup});

  String id;
  String name;
  String createdBy;
  String muscleGroup;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'] as String,
      name: json['name'] as String,
      createdBy: json['createdBy'] as String,
      muscleGroup: json['muscleGroup'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'createdBy': createdBy,
      'muscleGroup': muscleGroup,
    };
  }
}
