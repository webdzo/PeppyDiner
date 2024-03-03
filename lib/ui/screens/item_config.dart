import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/items/items_bloc.dart';
import 'package:hotelpro_mobile/models/itemconfig_model.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class ItemConfig extends StatefulWidget {
  const ItemConfig({super.key});

  @override
  State<ItemConfig> createState() => _ItemConfigState();
}

class _ItemConfigState extends State<ItemConfig> {
  ItemsBloc itemsBloc = ItemsBloc();
  List<int> selectedItems = [];
  List<ItemConfigModel> items = [];
  List<ItemConfigModel> initialItems = [];
  String selectedFilter = "";

  @override
  void initState() {
    itemsBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is EnableItemsDone) {
          EasyLoading.showSuccess('Success!');
          itemsBloc.add(FetchItemConfig());
          selectedItems = [];
        }
        if (event is EnableItemsLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is EnableItemsError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    itemsBloc.add(FetchItemConfig());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorKey.currentState!
              .pushNamed("/edititemconfig", arguments: null);
        },
        backgroundColor: HexColor("#d4ac2c"),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: HexColor("#d4ac2c"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        /*  leading: Padding(
          padding: EdgeInsets.all(5.w),
          child: Image.asset("assets/appLogo.png"),
        ), */
        title: TextWidget(
          "All Items",
          style: GoogleFonts.belleza(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 33.w,
          ),
          /* color: Colors.black,
            
             */
        ),
      ),
      body: BlocBuilder<ItemsBloc, ItemsState>(
        buildWhen: (previous, current) {
          return current is ItemsLoad ||
              current is ItemconfigDone ||
              current is ItemsError;
        },
        builder: (context, state) {
          if (state is ItemconfigDone) {
            initialItems = state.items;
            if (selectedFilter == "") {
              items = state.items;
            } else if (selectedFilter == "enabled") {
              items =
                  state.items.where((element) => element.enabled == 1).toList();
            } else if (selectedFilter == "disabled") {
              items =
                  state.items.where((element) => element.enabled == 0).toList();
            } else if (selectedFilter == "veg") {
              items = state.items
                  .where((element) => element.type == "veg")
                  .toList();
            } else if (selectedFilter == "nv") {
              items = state.items
                  .where((element) => element.type == "nonveg")
                  .toList();
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20.w,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: TextWidget(
                                      "Filter By",
                                      size: 22.sp,
                                      fontweight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.w,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      selectedFilter = "";
                                      items = initialItems;
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    titleTextStyle: TextStyle(fontSize: 18.sp),
                                    title: const TextWidget(
                                      "All",
                                    ),
                                    trailing: selectedFilter == ""
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      selectedFilter = "enabled";
                                      items = state.items
                                          .where(
                                              (element) => element.enabled == 1)
                                          .toList();
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    titleTextStyle: TextStyle(fontSize: 18.sp),
                                    title: const TextWidget(
                                      "Enabled",
                                    ),
                                    trailing: selectedFilter == "enabled"
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      selectedFilter = "disabled";
                                      items = state.items
                                          .where(
                                              (element) => element.enabled == 0)
                                          .toList();

                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    titleTextStyle: TextStyle(fontSize: 18.sp),
                                    title: const TextWidget("Disabled"),
                                    trailing: selectedFilter == "disabled"
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      selectedFilter = "nv";
                                      items = state.items
                                          .where((element) =>
                                              element.type == "nonveg")
                                          .toList();

                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    titleTextStyle: TextStyle(fontSize: 18.sp),
                                    title: const TextWidget("Nonveg"),
                                    trailing: selectedFilter == "nv"
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  ListTile(
                                    onTap: () {
                                      selectedFilter = "veg";
                                      items = state.items
                                          .where((element) =>
                                              element.type == "veg")
                                          .toList();

                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    titleTextStyle: TextStyle(fontSize: 18.sp),
                                    title: const TextWidget("Veg"),
                                    trailing: selectedFilter == "veg"
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                          )
                                        : null,
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10.w),
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.w),
                              border: Border.all(color: Colors.black)),
                          child: const Icon(
                            Icons.filter_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        button("Enable", () {
                          if (selectedItems.isNotEmpty) {
                            itemsBloc.add(EnableItems(selectedItems, true));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select items",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                            selectedItems.isNotEmpty
                                ? HexColor("#d4ac2c")
                                : Colors.grey.shade500,
                            textcolor: Colors.black),
                        SizedBox(
                          width: 10.w,
                        ),
                        button("Disable", () {
                          if (selectedItems.isNotEmpty) {
                            itemsBloc.add(EnableItems(selectedItems, false));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select items",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                            selectedItems.isNotEmpty
                                ? HexColor("#d4ac2c")
                                : Colors.grey.shade500,
                            textcolor: Colors.black),
                        SizedBox(
                          width: 10.w,
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          navigatorKey.currentState!
                              .pushNamed("/edititemconfig",
                                  arguments: items[index])
                              .then(
                                  (value) => itemsBloc.add(FetchItemConfig()));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 8.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 15.w),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.black38),
                                borderRadius: BorderRadius.circular(20.w)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        activeColor: HexColor("#d4ac2c"),
                                        value: selectedItems
                                            .contains(items[index].id),
                                        onChanged: (bool? value) {
                                          if ((value ?? false) &&
                                              !(selectedItems
                                                  .contains(items[index].id))) {
                                            selectedItems.add(items[index].id);
                                          } else {
                                            selectedItems
                                                .remove(items[index].id);
                                          }
                                          setState(() {});
                                        }),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: TextWidget(
                                                items[index].name,
                                                fontweight: FontWeight.bold,
                                                size: 19.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Icon(
                                              Icons.verified,
                                              color: items[index].enabled == 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                              size: 20.sp,
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10.w),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              items[index].type == "veg"
                                                  ? Image.asset(
                                                      "assets/vegLogo.png",
                                                      width: 20.w)
                                                  : Image.asset(
                                                      "assets/nonveg.png",
                                                      width: 25.w),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 0.w),
                                                decoration: BoxDecoration(
                                                    color: HexColor("#d4ac2c")
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    border: Border.all(
                                                        color: HexColor(
                                                            "#d4ac2c"))),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 3.w),
                                                child: TextWidget(
                                                  items[index].categoryName,
                                                  size: 17.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 0.w),
                                                decoration: BoxDecoration(
                                                    color: HexColor("#d4ac2c")
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    border: Border.all(
                                                        color: HexColor(
                                                            "#d4ac2c"))),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 3.w),
                                                child: TextWidget(
                                                  items[index].subcategoryName,
                                                  size: 17.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    TextWidget(
                                      "₹ ${items[index].price}",
                                      fontweight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        itemsBloc
                                            .add(DeleteItems(items[index].id));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red.shade900,
                                              borderRadius:
                                                  BorderRadius.circular(5.w)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 7.w),
                                          child: TextWidget(
                                            "Delete",
                                            color: Colors.white,
                                            size: 15.sp,
                                          )),
                                    )
                                  ],
                                )
                              ],
                            )),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (state is ItemsLoad) {
            return const Center(child: CircularProgressIndicator());
          }
          return const TextWidget("error");
        },
      ),
    );
  }
}
