import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/view_model/data/network/dio_helper.dart';
import 'package:to_do_app/view_model/data/network/end_point.dart';
import '../../../model/task_model.dart';
import 'package:path/path.dart' show basename;
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static TaskCubit get(context) => BlocProvider.of<TaskCubit>(context);

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  ScrollController controller = ScrollController();

  List<Tasks> tasks = [];
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String? imgName;
  File? imgPath;
  String? downloadUrl;
  int page = 1;
  bool hasMore = true;

  void addTask() {
    Tasks newTask = Tasks(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
    );
    tasks.add(newTask);
    clearControllers();
    emit(AddTaskState());
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    image = null;
  }

  void initController (int index) {
    titleController.text = tasks[index].title ?? '';
    descriptionController.text = tasks[index].description?? '';
    startDateController.text = tasks[index].startDate?? '';
    endDateController.text = tasks[index].endDate?? '';
    // image = tasks[index].image as XFile?;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    emit(DeleteTaskState());
  }

  Future<void> getAllTasks() async {
    emit(GetAllTasksLoading());

    await DioHelper.get(
      endPoint: EndPoints.tasks,
      withToken: true,
    ).then((response) {
      tasks.clear();
      page = 1;
      for (var element in response.data['data']['tasks']) {
        Tasks task = Tasks.fromJson(element);
        tasks.add(task);
      }
      if (tasks.length < 15) {
        hasMore = false;
      }
      emit(GetAllTasksSuccess(tasks));
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.data['message'] == 'Unauthenticated') {
          emit(Unauthenticated());
        } else {
          emit(GetAllTasksFailed(
            error: error.response?.data['message'] ??
                'Something went wrong on getting tasks',
          ));
        }
      } else {
        emit(GetAllTasksFailed(error: 'Something went wrong on getting tasks'));
      }
      throw error;
    });
  }

  Future<void> addTaskToAPI() async {
    emit(AddTaskLoading());

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty) {
      emit(AddTaskFailed(error: 'All fields are required.'));
      return;
    }

    Tasks newTask = Tasks(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'new',
    );
    FormData formData = FormData.fromMap({
      ...newTask.toJson(),
      if (image != null)
        'image': await MultipartFile.fromFile(image?.path ?? '')
    });
    await DioHelper.post(
      endPoint: EndPoints.tasks,
      withToken: true,
      body: formData,
    ).then((value) {
      Tasks task = Tasks.fromJson(value.data['data']);
      tasks.add(task);
      clearControllers();
      emit(AddTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
        emit(
          AddTaskFailed(error: 'Something went wrong on addTask'),
        );
        return;
      }
      emit(
        AddTaskFailed(error: 'Something went wrong on addTask'),
      );
      throw error;
    });
  }

  Future<void> deleteTaskFromAPI(int taskIndex) async {
    emit(DeleteTaskLoading());
    await DioHelper.delete(
      endPoint: '${EndPoints.tasks}/${tasks[taskIndex].id}',
      withToken: true,
    ).then((value) {
      tasks.removeAt(taskIndex);
      emit(DeleteTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
        emit(
          DeleteTaskFailed(error: 'Something went wrong on deleteTask'),
        );
        return;
      }
      emit(
        DeleteTaskFailed(error: 'Something went wrong on deleteTask'),
      );
      throw error;
    });
  }

  void initScrollController() {
    controller.addListener(() {
      if (controller.position.atEdge &&
          controller.position.pixels != 0 &&
          hasMore &&
          state is! GetAllTasksLoading) {
        getMoreTasks();
      }
    });
  }



  Future<void> getMoreTasks() async {
    emit(GetMoreTasksLoading());
    await DioHelper.get(endPoint: EndPoints.tasks, withToken: true, params: {
      'page': ++page,
    }).then((response) {
      for (var element in response.data['data']['tasks']) {
        Tasks task = Tasks.fromJson(element);
        tasks.add(task);
      }
      if (response.data['data']['tasks'].length < 15) {
        hasMore = false;
      }
      emit(GetMoreTasksSuccess());
    }).catchError((error) {
      if (error is DioException) {
        if (error.response?.data['message'] == 'Unauthenticated') {
          emit(Unauthenticated());
        } else {
          emit(GetMoreTasksFailed(
            error: error.response?.data['message'] ??
                'Something went wrong on getting tasks',
          ));
        }
      } else {
        emit(
            GetMoreTasksFailed(error: 'Something went wrong on getting tasks'));
      }
      throw error;
    });
  }

  ///// Firebase Methods   ///////
  Future<void> pickImage() async {
    image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    imgPath = File(image!.path);
    String imageName = basename(image!.path);
    int random = Random().nextInt(99999);
    imgName = '$imageName$random';
    emit(PickImageState());
  }

  /// Upload image to firebase storage  ////
  Future<void> uploadImageToFireStore() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('images/tasks/$imgName');
      await storageRef.putFile(imgPath!);
      downloadUrl = await storageRef.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }


  Future<void> updateTask(int taskIndex) async {
    emit(UpdateTaskLoading());

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        startDateController.text.isEmpty ||
        endDateController.text.isEmpty) {
      emit(UpdateTaskFailed(error: 'All fields are required.'));
      return;
    }

    Tasks updatedTask = Tasks(
      id: tasks[taskIndex].id, // Ensure the task ID is passed
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: 'updated',
      image: downloadUrl, // Use the download URL if the image was changed
    );

    FormData formData = FormData.fromMap({
      ...updatedTask.toJson(),
      if (image != null)
        'image': await MultipartFile.fromFile(image?.path ?? '')
    });

    await DioHelper.post(
      endPoint: '${EndPoints.tasks}/${updatedTask.id}',
      withToken: true,
      body: formData,
    ).then((value) {
      tasks[taskIndex] = Tasks.fromJson(value.data['data']);
      clearControllers();
      emit(UpdateTaskSuccess());
    }).catchError((error) {
      if (error is DioException) {
        emit(UpdateTaskFailed(error: 'Something went wrong on updateTask'));
        return;
      }
      emit(UpdateTaskFailed(error: 'Something went wrong on updateTask'));
      throw error;
    });
  }

}
