import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/orders/orders_bloc.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/expand_card.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KdsScreen extends StatefulWidget {
  const KdsScreen({super.key});

  @override
  State<KdsScreen> createState() => _KdsScreenState();
}

class _KdsScreenState extends State<KdsScreen> {
  OrdersBloc ordersBloc = OrdersBloc();
  List<bool>? isExpanded;

  ValueNotifier role = ValueNotifier("");

  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role.value = pref.getString("role") ?? "";
    setState(() {});
  }

  @override
  void initState() {
    getRole();
    ordersBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is EditOrdersLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is EditOrdersDone) {
          EasyLoading.showSuccess("Done");
          ordersBloc.add(OngoingOrders());
          ordersBloc.add(CurrentOrders());
        }
        if (event is EditOrdersError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    ordersBloc.add(OngoingOrders());
    super.initState();
  }

  _refresh() async {
    // Simulate a delay

    if (selectedIndex == 1) {
      ordersBloc.add(CurrentOrders());
    } else {
      ordersBloc.add(OngoingOrders());
    }
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: role,
        builder: (context, snapshot, _) {
          return Scaffold(
            drawer: role.value != "ROLE_CHEF" ? const NavDrawer() : null,
            appBar: AppBar(
              backgroundColor: HexColor("#d4ac2c"),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: TextWidget(
                "Kitchen Display System",
                style: GoogleFonts.belleza(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 33.w,
                ),
              ),
              actions: [
                /*  GestureDetector(
                  onTap: () {
                    _refresh();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: const Icon(
                      Icons.replay_outlined,
                      color: Colors.black,
                    ),
                  )), */
                if (role == "ROLE_CHEF")
                  GestureDetector(
                    onTap: () {
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
                                navigatorKey.currentState
                                    ?.pushNamedAndRemoveUntil(
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
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.logout),
                    ),
                  ),
                const ApplogoButton(),
              ],
            ),
            body: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    toolbarHeight: 15,
                    bottom: TabBar(
                      onTap: (value) {
                        if (value == 1) {
                          ordersBloc.add(CurrentOrders());
                        } else {
                          ordersBloc.add(OngoingOrders());
                        }
                        selectedIndex = value;
                        setState(() {});
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
                        Tab(text: "Ongoing"),
                        Tab(text: "Current"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    //   clipBehavior: Clip.none,
                    children: [
                      BlocBuilder<OrdersBloc, OrdersState>(
                        buildWhen: (previous, current) {
                          return current is OrdersLoad ||
                              current is OngoingDone ||
                              current is OrdersError ||
                              current is OrdersNodata;
                        },
                        builder: (context, state) {
                          print("stateee $state");
                          if (state is OrdersLoad || state is OrdersInitial) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is OrdersNodata) {
                            return const Center(
                                child: TextWidget("No orders found"));
                          }
                          if (state is OngoingDone) {
                            return state.orders.isEmpty
                                ? const Center(
                                    child: TextWidget("No orders found"))
                                : ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.w),
                                    itemCount: state.orders.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.w),
                                            color: HexColor("#d4ac2c")
                                                .withOpacity(0.2)),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5.w, horizontal: 10.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 15.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              state.orders[index].itemName,
                                              fontweight: FontWeight.w500,
                                            ),
                                            TextWidget(
                                                "x${state.orders[index].totalQuantity}")
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          }
                          return const Center(child: TextWidget("error"));
                        },
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: BlocBuilder<OrdersBloc, OrdersState>(
                              buildWhen: (previous, current) {
                                return current is OrdersLoad ||
                                    current is OrdersDone ||
                                    current is OrdersError ||
                                    current is OrdersNodata;
                              },
                              builder: (context, state) {
                                print("akshayaa $state");
                                if (state is OrdersLoad) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (state is OrdersNodata) {
                                  return const Center(
                                      child: TextWidget("No orders found"));
                                }
                                if (state is OrdersDone) {
                                  if (isExpanded?.isEmpty ?? true) {
                                    isExpanded = List.generate(
                                      state.orders.length,
                                      (index) => false,
                                    );
                                  }
                                  return ListView.builder(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.w),
                                    itemCount: state.orders.length,
                                    itemBuilder: (context, index) {
                                      return ExpandCardWidget(
                                          isExpanded: true,
                                          onRowClick: () {
                                            for (int i = 0;
                                                i < isExpanded!.length;
                                                i++) {
                                              if (i == index) {
                                                isExpanded?[i] =
                                                    !(isExpanded?[i] ?? false);
                                              } else {
                                                isExpanded?[i] = false;
                                              }
                                            }
                                            setState(() {});
                                          },
                                          header: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.w,
                                                horizontal: 10.w),
                                            color: HexColor("#d4ac2c")
                                                .withOpacity(0.2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    TextWidget(
                                                      state.orders[index]
                                                          .orderNo,
                                                      fontweight:
                                                          FontWeight.bold,
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.w)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10.w,
                                                              vertical: 5.w),
                                                      child: TextWidget(
                                                        state.orders[index]
                                                            .diningType
                                                            .capitalize(),
                                                        fontweight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    if (state.orders[index]
                                                        .itemOrders
                                                        .every((item) =>
                                                            item.completed)) {
                                                      ordersBloc.add(KotEdit(
                                                          state.orders[index].id
                                                              .toString(),
                                                          close: true));
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.all(5.w),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.w),
                                                        color: state
                                                                .orders[index]
                                                                .itemOrders
                                                                .every((item) =>
                                                                    item
                                                                        .completed)
                                                            ? Colors
                                                                .red.shade100
                                                            : Colors
                                                                .grey.shade100),
                                                    child: Icon(
                                                      Icons.close_rounded,
                                                      color: state.orders[index]
                                                              .itemOrders
                                                              .every((item) =>
                                                                  item.completed)
                                                          ? Colors.red.shade900
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          body: Column(
                                            children: [
                                              Container(
                                                height: 0.2,
                                                color: const Color.fromARGB(
                                                    246, 0, 0, 0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.w),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.w),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                                color: HexColor("#d4ac2c")
                                                    .withOpacity(0.2),
                                                child: Column(
                                                  children: List.generate(
                                                      state.orders[index]
                                                          .itemOrders.length,
                                                      (itemIndex) => Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        5.w),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.w,
                                                                      vertical:
                                                                          15.w),
                                                                  child: Row(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          const TextWidget(
                                                                              "\u2022 "),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.6,
                                                                            child:
                                                                                TextWidget(
                                                                              "${state.orders[index].itemOrders[itemIndex].itemName}  x${state.orders[index].itemOrders[itemIndex].itemQuantity}",
                                                                              size: 17.sp,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (!state
                                                                              .orders[index]
                                                                              .itemOrders[itemIndex]
                                                                              .completed) {
                                                                            ordersBloc.add(KotEdit(state.orders[index].id.toString(),
                                                                                itemId: state.orders[index].itemOrders[itemIndex].id.toString(),
                                                                                status: "Completed",
                                                                                reason: ""));
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(10.w),
                                                                          color: state.orders[index].itemOrders[itemIndex].completed
                                                                              ? Colors.grey
                                                                              : Colors.green.shade900,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.check,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )),
                                                                    SizedBox(
                                                                      width:
                                                                          10.w,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          ordersBloc.add(KotEdit(
                                                                              state.orders[index].id.toString(),
                                                                              itemId: state.orders[index].itemOrders[itemIndex].id.toString(),
                                                                              status: "Rejected",
                                                                              reason: ""));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.all(10.w),
                                                                          color: Colors
                                                                              .red
                                                                              .shade900,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ))
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                ),
                                              ),
                                            ],
                                          ));
                                    },
                                  );
                                }
                                return const Center(
                                  child: TextWidget("error"),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
