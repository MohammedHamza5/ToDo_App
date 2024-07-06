part of 'task_cubit.dart';

sealed class TaskState {}

final class TaskInitial extends TaskState {}
final class AddTaskState extends TaskState {}
final class DeleteTaskState extends TaskState {}