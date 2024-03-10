import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    getRole();
    // TODO: implement
    // initState
    super.initState();
  }

  String role = "";
//testing
  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: HexColor("#d4ac2c"),
            ),
            child: Column(
              children: [
                const ApplogoButton(),
                Text(
                  'Peppy Diner',
                  style: GoogleFonts.belleza(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 33.w,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              print("akkk tt $bottomIndex");
              navigatorKey.currentState
                  ?.pushReplacementNamed("/home", arguments: bottomIndex);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Manage Items'),
            onTap: () {
              // Navigator.of(context).pop();
              navigatorKey.currentState!.pushReplacementNamed("/itemconfig");
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Manage User'),
            onTap: () {
              // Navigator.of(context).pop();
              navigatorKey.currentState!.pushReplacementNamed("/userConfig");
            },
          ),
          if (role == "ROLE_ADMIN")
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Reports'),
              onTap: () {
                // Navigator.of(context).pop();
                navigatorKey.currentState!.pushReplacementNamed("/reports");
              },
            ),
        ],
      ),
    );
  }
}
