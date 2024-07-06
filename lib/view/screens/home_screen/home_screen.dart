import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:to_do_app/view/screens/home_screen/widgets/add_task_widget.dart';
import 'package:to_do_app/view/screens/home_screen/widgets/task_widget.dart';
import 'package:to_do_app/view_model/cubits/task/task_cubit.dart';
import 'package:to_do_app/view_model/cubits/theme/theme_cubit.dart';
import '../../../view_model/utils/local_keys.g.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(

      value: ThemeCubit.get(context),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: true,
                  isDismissible: false,
                  showDragHandle: true,
                  builder: (context) {
                    return const AddTaskWidget();
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              title: Text(
                LocaleKeys.name.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    debugPrint(context.locale.toString());
                    if (context.locale.toString() == 'ar') {
                      context.setLocale(
                        const Locale('en'),
                      );
                    } else {
                      context.setLocale(
                        const Locale('ar'),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.translate_sharp,
                    size: 25.sp,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                IconButton(
                  onPressed: () {
                    ThemeCubit.get(context).changeThemeMode();
                  },
                  icon: Icon(
                    ThemeCubit
                        .get(context)
                        .isDark
                        ? Icons.nightlight_round
                        : Icons.wb_sunny_sharp,
                    size: 28.sp,
                  ),
                ),
              ],
            ),

            drawer: const Drawer(),
            body: BlocProvider(
              create: (context) => TaskCubit(),
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.w,
                    ),
                    itemBuilder: (context, index) => TaskWidget(
                      task: TaskCubit.get(context).tasks[index],
                      onDeleteIconPressed: () {
                        TaskCubit.get(context).deleteTask(index);
                      },
                    ),
                    itemCount: TaskCubit.get(context).tasks.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 12.h,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
