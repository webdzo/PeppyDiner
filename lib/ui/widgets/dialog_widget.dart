import 'package:flutter/material.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

import '../../route_generator.dart';
import 'button.dart';

class DialogWidget {
  Future<dynamic> dialogWidget(BuildContext cxt, String title,
      Function()? cancelPress, Function()? okPress,
      {Widget? notefield}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            title,
            fontweight: FontWeight.bold,
            size: 20.sp,
          ),
          content: notefield,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            button(
              "Cancel",
              cancelPress,
              Colors.red.shade900,
            ),
            button(
              "OK",
              okPress,
              Colors.green.shade800,
            )
          ],
        );
      },
    );
  }
}
