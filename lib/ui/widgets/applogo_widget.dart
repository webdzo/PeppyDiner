import 'package:flutter/material.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';

class ApplogoButton extends StatelessWidget {
  final GlobalKey<ScaffoldState>? keys;
  const ApplogoButton({
    super.key,
    this.keys,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
        // (keys ?? drawerKey1).currentState?.openDrawer();
      },
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Image.asset("assets/appLogo.png"),
      ),
    );
  }
}
