import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/addReservation/add_reservation_bloc.dart';
import 'package:hotelpro_mobile/bloc/addReservation/add_reservation_event.dart';
import 'package:hotelpro_mobile/bloc/addReservation/add_reservation_state.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({super.key});

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  AddResevationBloc addResevationBloc = AddResevationBloc();
  String pwd = "";
  String rePwd = "";

  @override
  void initState() {
    addResevationBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is UpdateUsersDone) {
          pwd = "";
          rePwd = "";
          setState(() {});
          EasyLoading.showSuccess('Success!');

          Future.delayed(const Duration(seconds: 2), () {
            addResevationBloc.add(GetusersEvent());
          });
        }
        if (event is UpdateUsersLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is UpdateUsersError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    addResevationBloc.add(GetusersEvent());
    super.initState();
  }

  Future<void> _refresh() async {
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    addResevationBloc.add(GetusersEvent());
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
            "Manage User",
            style: GoogleFonts.belleza(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 33.w,
            ),
            /* color: Colors.black,
              
               */
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: BlocBuilder<AddResevationBloc, AddReservationState>(
            buildWhen: (previous, current) {
              return current is UsersLoad ||
                  current is UsersDone ||
                  current is UsersError;
            },
            builder: (context, state) {
              if (state is UsersLoad) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UsersDone) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        state.users.length,
                        (index) => Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.w, horizontal: 10.w),
                              decoration:
                                  BoxDecoration(color: Colors.grey.shade200),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 10.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        state.users[index].firstname,
                                        fontweight: FontWeight.bold,
                                      ),
                                      TextWidget(
                                        state.users[index].roleName
                                            .capitalize(),
                                        fontweight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.w,
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.w),
                                    child: TextWidget(
                                      state.users[index].email,
                                      fontweight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.w,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      button(
                                          state.users[index].blocked
                                              ? "Unblock"
                                              : "Block", () {
                                        addResevationBloc.add(DeleteusersEvent(
                                            state.users[index].email,
                                            block: true));
                                      }, Colors.red.shade900),
                                      button("Delete", () {
                                        if (state.users[index].deleted ==
                                            false) {
                                          addResevationBloc.add(
                                              DeleteusersEvent(
                                                  state.users[index].email));
                                        }
                                      },
                                          state.users[index].deleted
                                              ? Colors.grey
                                              : Colors.black),
                                      button("Change Password", () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, setstate) {
                                              return AlertDialog(
                                                title: const TextWidget(
                                                  "Change Password",
                                                  fontweight: FontWeight.bold,
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 10.w,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          TextEditingController
                                                              .fromValue(
                                                                  TextEditingValue(
                                                        text: pwd.toString() ??
                                                            "",
                                                        selection: TextSelection
                                                            .fromPosition(
                                                          TextPosition(
                                                              offset:
                                                                  (pwd.toString())
                                                                      .length),
                                                        ),
                                                      )),
                                                      onChanged: (value) {
                                                        pwd = value;
                                                        setstate(() {});
                                                      },
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Cannot be empty";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Password",
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 0,
                                                                horizontal: 5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: HexColor(
                                                                "#d4ac2c"),
                                                          ),
                                                        ),
                                                        //fillColor: Colors.green
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10.w,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          TextEditingController
                                                              .fromValue(
                                                                  TextEditingValue(
                                                        text:
                                                            rePwd.toString() ??
                                                                "",
                                                        selection: TextSelection
                                                            .fromPosition(
                                                          TextPosition(
                                                              offset: (rePwd
                                                                      .toString())
                                                                  .length),
                                                        ),
                                                      )),
                                                      onChanged: (value) {
                                                        rePwd = value;
                                                        setstate(() {});
                                                      },
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "Cannot be empty";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Re-type Password",
                                                        fillColor: Colors.white,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 0,
                                                                horizontal: 5),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          borderSide:
                                                              BorderSide(
                                                            color: HexColor(
                                                                "#d4ac2c"),
                                                          ),
                                                        ),
                                                        //fillColor: Colors.green
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                actions: [
                                                  button("Cancel", () {
                                                    pwd = "";
                                                    rePwd = "";
                                                    setstate(() {});
                                                    navigatorKey.currentState
                                                        ?.pop();
                                                  }, Colors.red.shade900),
                                                  button("Submit", () {
                                                    addResevationBloc.add(
                                                        DeleteusersEvent(
                                                            state.users[index]
                                                                .email,
                                                            change: true,
                                                            pwd: pwd));
                                                    navigatorKey.currentState
                                                        ?.pop();
                                                  }, Colors.green.shade900)
                                                ],
                                              );
                                            });
                                          },
                                        );
                                      }, Colors.blue)
                                    ],
                                  )
                                ],
                              ),
                            )),
                  ),
                );
              }
              if (state is UsersError) {
                return TextWidget(state.erroMsg);
              }
              return const TextWidget("Something went wrong");
            },
          ),
        ),
      ),
    );
  }
}
