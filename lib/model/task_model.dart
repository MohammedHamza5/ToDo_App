class Tasks {
  String? title;
  String? description;
  String? image;
  String? startDate;
  String? endDate;
  int? id;
  String? status;

  Tasks({
    this.status,
    this.id,
    this.title,
    this.description,
    this.image,
    this.startDate,
    this.endDate,
  });

  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      if (image != null) 'image': image,
      // 'status': status?.toString().split('.').last,
    };
  }

  List<Object?> get props => [title, image, startDate, endDate, status, id];

  // TaskStatus? _getStatusFromString(String? status) {
  //   if (status == null) return null;
  //   switch (status) {
  //     case 'newTask':
  //       return TaskStatus.newTask;
  //     case 'outdated':
  //       return TaskStatus.outdated;
  //     case 'doing':
  //       return TaskStatus.doing;
  //     case 'completed':
  //       return TaskStatus.completed;
  //     default:
  //       return null;
  //   }
  // }
}

enum TaskStatus { newTask, outdated, doing, completed }
