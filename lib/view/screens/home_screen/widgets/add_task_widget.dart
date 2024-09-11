import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/view_model/cubits/task/task_cubit.dart';
import 'package:to_do_app/view_model/utils/app_colors.dart';
import '../../../../view_model/utils/app_navigate.dart';
import '../../../../view_model/utils/local_keys.g.dart';

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // create: (context) => TaskCubit(),
      value: TaskCubit.get(context)..addTaskToAPI(),
      child: BlocBuilder<TaskCubit, TaskState>(buildWhen: (previous, current) {
        return current is PickImageState;
      }, builder: (context, state) {
        return SafeArea(
          child: Form(
            key: TaskCubit.get(context).formState,
            child: ListView(
              padding: EdgeInsetsDirectional.only(
                top: 12.h,
                start: 12.w,
                end: 12.w,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              shrinkWrap: true,
              children: [
                Text(
                  LocaleKeys.add_task.tr(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                TextFormField(
                  controller: TaskCubit.get(context).titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.fieldRequired.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.title.tr(),
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                TextFormField(
                  controller: TaskCubit.get(context).descriptionController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.description.tr(),
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                TextFormField(
                  controller: TaskCubit.get(context).startDateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.fieldRequired.tr();
                    }
                    return null;
                  },
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.startDate.tr(),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    ).then(
                      (value) {
                        if (value != null) {
                          TaskCubit.get(context).startDateController.text =
                              DateFormat('yyyy-MM-dd').format(value);
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 14.h,
                ),
                TextFormField(
                  controller: TaskCubit.get(context).endDateController,
                  keyboardType: TextInputType.none,
                  readOnly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.fieldRequired.tr();
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleKeys.endDate.tr(),
                  ),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    ).then(
                      (value) {
                        if (value != null) {
                          TaskCubit.get(context).endDateController.text =
                              DateFormat('yyyy-MM-dd').format(value);
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Visibility(
                  visible: TaskCubit.get(context).image == null,
                  replacement: Image.file(
                    File(
                      TaskCubit.get(context).image?.path ?? '',
                    ),
                    height: 200.h,
                    fit: BoxFit.cover,
                  ),
                  child: InkWell(
                    onTap: () {
                      TaskCubit.get(context).pickImage();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.image_outlined),
                        SizedBox(
                          height: 6.h,
                        ),
                        const Text(LocaleKeys.upload_image),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                BlocBuilder<TaskCubit, TaskState>(
                  buildWhen: (previous, current) {
                    return current is AddTaskLoading ||
                        current is AddTaskSuccess ||
                        current is AddTaskFailed;
                  },
                  builder: (context, state) {
                    return Visibility(
                      visible: state is AddTaskLoading,
                      child: const LinearProgressIndicator(),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (TaskCubit.get(context)
                        .formState
                        .currentState!
                        .validate()) {
                      TaskCubit.get(context).addTaskToAPI().then((value) {
                        AppNavigation.pop(context);
                        TaskCubit.get(context).uploadImageToFireStore();
                      });
                    } else {
                      return;
                    }
                  },
                  child: Text(
                    LocaleKeys.submit.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
