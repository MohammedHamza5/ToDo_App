import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/view/screens/home_screen/widgets/add_task_widget.dart';
import 'package:to_do_app/view/screens/home_screen/widgets/task_widget.dart';
import 'package:to_do_app/view/screens/login_screen/login_screen.dart';
import 'package:to_do_app/view_model/cubits/task/task_cubit.dart';
import 'package:to_do_app/view_model/cubits/theme/theme_cubit.dart';
import 'package:to_do_app/view_model/data/network/dio_helper.dart';
import '../../../view_model/utils/app_navigate.dart';
import '../../../view_model/utils/local_keys.g.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // create: (context) => TaskCubit(),
      value: TaskCubit.get(context)
        ..getAllTasks()
        ..initScrollController(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            TaskCubit.get(context).clearControllers();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              isDismissible: false,
              showDragHandle: true,
              builder: (context) {
                return BlocProvider.value(
                  value: TaskCubit.get(context), // Use the existing TaskCubit
                  child: const AddTaskWidget(),  // Your AddTaskWidget here
                );
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
            BlocProvider.value(
              value: ThemeCubit.get(context),
              child: BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return AnimatedRotation(
                    duration: const Duration(microseconds: 500),
                    turns: ThemeCubit.get(context).isDark ? 0 : 1,
                    child: IconButton(
                      onPressed: () {
                        ThemeCubit.get(context).changeThemeMode();
                      },
                      icon: Icon(
                        ThemeCubit.get(context).isDark
                            ? Icons.nightlight_round
                            : Icons.wb_sunny_sharp,
                        size: 28.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                await DioHelper.storage.deleteAll();
                AppNavigation.pushAndRemove(context, const LoginScreen());
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
        body: BlocConsumer<TaskCubit, TaskState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              AppNavigation.pushAndRemove(context, const LoginScreen());
            }
          },
          builder: (context, state) {
            if (state is GetAllTasksLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Visibility(
              visible: TaskCubit.get(context).tasks.isNotEmpty,
              replacement: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Lottie.network(
                    'https://lottie.host/ec76677e-5cde-4969-a8ea-d9222f3de4fe/I4gxB4gckO.json',
                  ),
                  const Text(
                    LocaleKeys.no_tasks,
                  ),
                ]),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  await TaskCubit.get(context).getAllTasks();
                },
                child: ListView.separated(
                  controller: TaskCubit.get(context).controller,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.w,
                  ),
                  itemBuilder: (context, index) => TaskWidget(
                    task: TaskCubit.get(context).tasks[index],
                    onDeleteIconPressed: () {
                      TaskCubit.get(context).deleteTaskFromAPI(index);
                    },
                    onTap: () {
                      TaskCubit.get(context).initController(index);
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          isDismissible: false,
                          showDragHandle: true,
                        builder: (context) {
                          return BlocProvider.value(
                            value: TaskCubit.get(context), // Use the existing TaskCubit
                            child: const AddTaskWidget(),  // Your AddTaskWidget here
                          );
                        },
                      );
                    },
                  ),
                  itemCount: TaskCubit.get(context).tasks.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: 12.h,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
