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
import '../widgets/dropdown.dart';
import '../widgets/table_widget.dart';

class Nondining extends StatefulWidget {
  const Nondining({super.key});

  @override
  State<Nondining> createState() => _NondiningState();
}

class _NondiningState extends State<Nondining> {
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

  String selectedCategory = "takeaway";

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  button("Add Orders", () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextWidget("Select Type"),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.close))
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.w),
                                ),
                                child: CustomDropdownButton(
                                  underline: Container(),
                                  icon: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: HexColor("#d4ac2c"),
                                        fill: 0.5,
                                      ),
                                    ],
                                  ),
                                  dropdownColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (values) {
                                    selectedCategory = values;

                                    setState(() {});
                                  },
                                  items: ["takeaway", "delivery"].map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            button("Submit", () {
                              Navigator.pop(context);

                              navigatorKey.currentState
                                  ?.pushNamed("/categoryScreen", arguments: {
                                "reservId": 0,
                                "orderId": null,
                                "identifier": "",
                                "update": false,
                                "tableId": "",
                                "type": selectedCategory,
                                "waiter": "",
                              });
                            }, HexColor("#d4ac2c"), textcolor: Colors.black)
                          ],
                        );
                      },
                    );
                  }, HexColor("#d4ac2c"), textcolor: Colors.black),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  initialIndex: nondineIndex ?? 0,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 5,
                      bottom: TabBar(
                        onTap: (value) {
                          nondineIndex = value;
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
                          Tab(text: "Current"),
                          Tab(text: "Past"),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: BlocProvider(
                            create: (context) => TableBloc(),
                            child: TableWidget(
                              myTable: true,
                              tableList: const [],
                              type: "current",
                              userId: userId,
                              nonDiner: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.w),
                          child: BlocProvider(
                            create: (context) => TableBloc(),
                            child: TableWidget(
                              myTable: false,
                              tableList: const [],
                              type: "past",
                              userId: userId,
                              nonDiner: true,
                            ),
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
