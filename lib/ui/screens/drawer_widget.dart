import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

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
        ],
      ),
    );
  }
}