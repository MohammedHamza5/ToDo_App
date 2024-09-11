part of 'task_cubit.dart';

abstract class TaskState {}

final class TaskInitial extends TaskState {}

final class AddTaskState extends TaskState {}

final class DeleteTaskState extends TaskState {}

final class GetAllTasksLoading extends TaskState {}

final class GetAllTasksSuccess extends TaskState {
  final List<Tasks> tasks;

  GetAllTasksSuccess(this.tasks);
}

final class GetAllTasksFailed extends TaskState {
 final String? error;

  GetAllTasksFailed({this.error});
}

final class Unauthenticated extends TaskState{}

final class AddTaskLoading extends TaskState{}
final class AddTaskSuccess extends TaskState{}
final class AddTaskFailed extends TaskState{
  final String? error;

  AddTaskFailed({this.error});
}

final class DeleteTaskLoading extends TaskState{}
final class DeleteTaskSuccess extends TaskState{}
final class DeleteTaskFailed extends TaskState{
  final String? error;

  DeleteTaskFailed({this.error});
}

final class GetMoreTasksLoading extends TaskState{}
final class GetMoreTasksSuccess extends TaskState{}
final class GetMoreTasksFailed extends TaskState{
  final String? error;

  GetMoreTasksFailed({this.error});
}

final class PickImageState extends TaskState{}


class UpdateTaskLoading extends TaskState {}

class UpdateTaskSuccess extends TaskState {}

class UpdateTaskFailed extends TaskState {
  final String error;

  UpdateTaskFailed({required this.error});
}