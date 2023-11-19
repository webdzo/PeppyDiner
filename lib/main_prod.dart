import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/src/screenutil_init.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/checkout/checkout_bloc.dart';
import 'main_qa.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseUrl.appBaseurl = "http://3.111.162.219/api";
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
        return BlocProvider(
            create: (context) => CheckoutBloc(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Peppy Diner',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              onGenerateRoute: generateRoute,
              // navigatorObservers: [MyNavigatorObserver()],
              initialRoute:
                  ((pref.getString("token") ?? "").isNotEmpty) ? "/home" : "/",
              navigatorKey: navigatorKey,
              builder: EasyLoading.init(),
            ));
      },
    );
  }
}

/* class MyNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    print(routeStack.map((e) => e.settings.name).toList());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
    print(routeStack.map((e) => e.settings.name).toList());
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    routeStack.removeLast();
    print(routeStack.map((e) => e.settings.name).toList());
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute!);
    print(routeStack.map((e) => e.settings.name).toList());
  }
} */
