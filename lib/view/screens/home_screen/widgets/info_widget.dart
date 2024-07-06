import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../view_model/utils/app_colors.dart';

class InfoWidget extends StatelessWidget {

  final IconData icon ;
  final String text;
  const InfoWidget({required this.text ,required this.icon,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(
          color: AppColors.purpleA,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
              icon
          ),
          SizedBox(
            width: 6.w,
          ),
          Expanded(
            child: Text(
              text,
              style:
              Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
