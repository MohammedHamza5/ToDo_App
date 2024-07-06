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
    return BlocProvider(
      create: (context) => TaskCubit(),
      child: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
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
                      context: context,firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    ).then(
                          (value) {
                        if (value != null) {
                          TaskCubit.get(context).startDateController.text =
                              DateFormat('dd-MM-yyyy').format(value);
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.fieldRequired.tr();
                    }
                    return null;
                  },
                  keyboardType: TextInputType.none,
                  readOnly: true,
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
                              DateFormat('dd-MM-yyyy').format(value);
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    TaskCubit.get(context).addTask();
                    if (TaskCubit.get(context)
                        .formState
                        .currentState!
                        .validate()) {
                      TaskCubit.get(context).addTask();
                      AppNavigation.pop(context);
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
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}