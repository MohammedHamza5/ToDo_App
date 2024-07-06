import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/task_model.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  static TaskCubit get(context) => BlocProvider.of<TaskCubit>(context);

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  List<Task> tasks = [];

  void addTask() {
    Task newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
    );
    tasks.add(newTask);
    emit(AddTaskState());
    // clearControllers();

  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
  }

  void deleteTask (int index) {
    tasks.removeAt(index);
    emit(DeleteTaskState());
  }
}