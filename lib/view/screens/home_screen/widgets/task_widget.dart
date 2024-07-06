import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../model/task_model.dart';
import '../../../../view_model/utils/app_colors.dart';
import 'info_widget.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final void Function()? onDeleteIconPressed;
  const TaskWidget({required this.onDeleteIconPressed,required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.w,
      ),
      decoration: BoxDecoration(
          color: AppColors.babyBlue,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.purpleA, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).tr(),
              ),
              IconButton(
                onPressed: onDeleteIconPressed,

                icon: const Icon(Icons.delete_forever ,
                  color: AppColors.red,),
              ),
            ],
          ),
          Text(task.description ?? '',
              style: Theme.of(context).textTheme.bodySmall)
              .tr(),
          SizedBox(
            height: 8.h,
          ),
          if (task.image != null || (task.image ?? '').isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                task.image ?? '',
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(
            height: 12.h,
          ),
          Row(
            children: [
              Expanded(
                child: InfoWidget(
                  icon: Icons.timer_outlined,
                  text: task.startDate ?? '',
                ),
              ),
              SizedBox(
                width: 12.h,
              ),
              Expanded(
                child: InfoWidget(
                  icon: Icons.timer_off_outlined,
                  text: task.endDate ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}