import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/space/space_bloc.dart';
import '../../route_generator.dart';
import '../widgets/button.dart';
import '../widgets/table_widget.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
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
          ),
          actions: [
             Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: GestureDetector(
                onTap: () {
                  navigatorKey.currentState!.pushNamed("/itemconfig");
                },
                child: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  button("Add Reservation", () {
                    navigatorKey.currentState?.pushNamed("/addReservation");
                  }, HexColor("#d4ac2c"), textcolor: Colors.black),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 3,
                  initialIndex: reservIndex ?? 1,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 5,
                      bottom: TabBar(
                        onTap: (value) {
                          reservIndex = value;
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
                          Tab(text: "Past"),
                          Tab(text: "Current"),
                          Tab(text: "Upcoming"),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        BlocProvider(
                          create: (context) => TableBloc(),
                          child: TableWidget(
                            myTable: true,
                            tableList: const [],
                            type: "past",
                            userId: userId,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => TableBloc(),
                          child: TableWidget(
                            myTable: true,
                            tableList: const [],
                            type: "current",
                            userId: userId,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => TableBloc(),
                          child: TableWidget(
                            myTable: true,
                            tableList: const [],
                            type: "upcoming",
                            userId: userId,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }
}
