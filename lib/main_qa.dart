import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/src/screenutil_init.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseUrl {
  static String appBaseurl = "";
}

int? reservIndex;
int? nondineIndex;
int? tableIndex;
int bottomIndex = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseUrl.appBaseurl = "http://13.200.118.169/api";

  // http://65.2.117.47/api/
  pref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

late SharedPreferences pref;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      scale: 1.2,
      designSize: const Size(826.9, 392.7),
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Peppy Diner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: generateRoute,
          // navigatorObservers: [MyNavigatorObserver()],
          initialRoute: ((pref.getString("token") ?? "").isNotEmpty)
              ? ((pref.getString("role") ?? "") == "ROLE_CHEF"
                  ? "/kdsScreen"
                  : "/home")
              : "/",
          navigatorKey: navigatorKey,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
