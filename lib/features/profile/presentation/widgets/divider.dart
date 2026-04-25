import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/theme/AppPallete.dart';

Widget divider() {
  return Divider(
    height: 18.h,
    thickness: 0.6,
    color: AppPallete.textSecondary.withOpacity(0.15),
  );
}