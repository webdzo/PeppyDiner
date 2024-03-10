import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var dropdownList = [
    DropdownModel(id: 1, name: "Section-1"),
    DropdownModel(id: 2, name: "Section-2"),
    DropdownModel(id: 3, name: "Section-3"),
    DropdownModel(id: 4, name: "Section-4"),
    DropdownModel(id: 5, name: "Section-5"),
  ];

  String username = "";
  String pwd = "";
  String email = "";
  String role = "";

  getDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username") ?? "";
    pwd = pref.getString("password") ?? "";
    role = pref.getString("role") ?? "";
    email = pref.getString("email") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    getDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/home', arguments: bottomIndex, (Route<dynamic> route) => true);
        return false;
      },
      child: Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          actions: const [ApplogoButton()],
          backgroundColor: HexColor("#d4ac2c"),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: TextWidget(
            "Profile",
            style: GoogleFonts.belleza(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 33.w,
            ),
            /* color: Colors.black,
                
                 */
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 70.h,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor("#d4ac2c"),
                        image: const DecorationImage(
                            image: AssetImage("assets/profilebg.jpg"),
                            fit: BoxFit.cover)),
                    height: 60.h,
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        //  padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey)),
                        child: Image.asset("assets/appLogo.png"),
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.w, bottom: 10.w),
              child: Column(
                children: [
                  TextWidget(
                    email,
                    fontweight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  TextWidget(
                    role,
                    size: 15.sp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.w),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70.w,
                          child: TextWidget(
                            "Username",
                            fontweight: FontWeight.w500,
                            size: 18.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        SizedBox(
                          height: 70.w,
                          child: TextWidget(
                            "Email",
                            fontweight: FontWeight.w500,
                            size: 18.sp,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        SizedBox(
                          height: 70.w,
                          child: TextWidget(
                            "Role",
                            fontweight: FontWeight.w500,
                            size: 18.sp,
                            color: Colors.grey.shade800,
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70.w,
                        child: TextWidget(
                          username,
                          fontweight: FontWeight.w500,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      SizedBox(
                        height: 70.w,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextWidget(
                          email,
                          fontweight: FontWeight.w500,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      SizedBox(
                        height: 70.w,
                        child: TextWidget(
                          role,
                          fontweight: FontWeight.w500,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: MultiSelectDialogField(
                items: _items,
                initialValue: [
                  DropdownModel(id: 1, name: "Section-1"),
                  DropdownModel(id: 2, name: "Section-2"),
                  DropdownModel(id: 3, name: "Section-3"),
                  DropdownModel(id: 4, name: "Section-4"),
                  DropdownModel(id: 5, name: "Section-5"),
                ],
                title: const Text("Select Section"),
                selectedColor: Colors.black,
                dialogHeight: (MediaQuery.of(context).size.height * 0.07) * 5,
                selectedItemsTextStyle: const TextStyle(color: Colors.black),
                decoration: BoxDecoration(
                  color: HexColor("#d4ac2c").withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                  border: Border.all(
                    color: HexColor("#d4ac2c"),
                    width: 2,
                  ),
                ),
                buttonIcon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                buttonText: const Text(
                  "Select Section",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onConfirm: (results) {
                  //_selectedAnimals = results;
                },
              ),
            ), */

            /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: MultiSelectDialogField(
                barrierColor: Colors.black.withOpacity(0.5),
                onConfirm: (val) {
                  //_selectedAnimals5 = val;
                },
                title: const Text("Select Section"),
                searchHint: "Select Section",
                buttonIcon: const Icon(Icons.keyboard_arrow_down),
                searchTextStyle: const TextStyle(color: Colors.red),
                selectedColor: HexColor("#d4ac2c"),
                checkColor: Colors.black,
                buttonText: const Text("Select Section"),
                dialogHeight: (MediaQuery.of(context).size.height * 0.07) *
                    (dropdownList.length),
                items: _items,
                selectedItemsTextStyle: const TextStyle(color: Colors.black),
                itemsTextStyle: const TextStyle(color: Colors.black),
                initialValue:
                    dropdownList, // setting the value of this in initState() to pre-select values.
              ),
            ), */

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                button("       Logout       ", () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              "Logout",
                              fontweight: FontWeight.bold,
                              size: 22.sp,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close),
                            )
                          ],
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget("Are you sure you want to logout?"),
                          ],
                        ),
                        actions: [
                          button(
                            "Cancel",
                            () async {
                              Navigator.pop(context);
                            },
                            Colors.red,
                          ),
                          button("Ok", () async {
                            Navigator.pop(navigatorKey.currentContext!);
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.clear();
                            navigatorKey.currentState?.pushNamedAndRemoveUntil(
                              "/",
                              (route) {
                                return false;
                              },
                            );
                          }, Colors.green)
                        ],
                      );
                    },
                  );
                }, HexColor("#d4ac2c"), size: 18.sp, textcolor: Colors.black)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DropdownModel {
  final int id;
  final String name;

  DropdownModel({
    required this.id,
    required this.name,
  });
}
