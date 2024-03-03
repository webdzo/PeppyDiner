import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/space/space_bloc.dart';
import '../widgets/table_widget.dart';

class MyTables extends StatefulWidget {
  const MyTables({super.key});

  @override
  State<MyTables> createState() => _MyTablesState();
}

class _MyTablesState extends State<MyTables> {
  SpaceBloc spaceBloc = SpaceBloc();

  @override
  void initState() {
    getUsername();

    super.initState();
  }

  String username = "";
  String userId = "";

  getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username") ?? "";
    userId = pref.getString("userId") ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#d4ac2c"),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(5.w),
            child: Image.asset("assets/appLogo.png"),
          ),
          title: TextWidget(
            "Hi ${username != "" ? username.capitalize() : username},",
            style: GoogleFonts.belleza(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 33.w,
            ),
            /* color: Colors.black,
            
             */
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () {
                  navigatorKey.currentState!.pushNamed("/profile");
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: DefaultTabController(
            length: 3,
            initialIndex: tableIndex ?? 0,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 15,
                bottom: TabBar(
                  onTap: (value) {
                    tableIndex = value;
                  },
                  automaticIndicatorColorAdjustment: true,
                  indicatorColor: HexColor("#d4ac2c"),
                  indicatorWeight: 5,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                  unselectedLabelStyle:
                      TextStyle(color: Colors.grey, fontSize: 18.sp),
                  tabs: const [
                    Tab(text: "My Tables"),
                    Tab(text: "UnAssigned"),
                    Tab(text: "All Tables"),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BlocProvider(
                    create: (context) => TableBloc(),
                    child: TableWidget(
                      myTable: false,
                      tableList: const [],
                      type: "mytable",
                      userId: userId,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => TableBloc(),
                    child: TableWidget(
                      myTable: false,
                      tableList: const [],
                      type: "unassigned",
                      userId: userId,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => TableBloc(),
                    child: TableWidget(
                      myTable: false,
                      tableList: const [],
                      type: "alltables",
                      userId: userId,
                    ),
                  ),
                ],
              ),
            )));
  }
}
