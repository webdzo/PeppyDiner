import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/models/availableTables_model.dart';
import 'package:hotelpro_mobile/models/edittable_request.dart';
import 'package:hotelpro_mobile/models/space_model.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/dialog_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/dropdown.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class ManageTable extends StatefulWidget {
  const ManageTable({super.key});

  @override
  State<ManageTable> createState() => _ManageTableState();
}

class _ManageTableState extends State<ManageTable> {
  final _formKey = GlobalKey<FormState>();
  TableBloc tableBloc = TableBloc();
  @override
  void initState() {
    tableBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is CreateLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is CreatedDone) {
          tableBloc.add(FetchSpaces());
          EasyLoading.showSuccess('Success!');
        }
        if (event is CreateError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    tableBloc.add(FetchSpaces());
    super.initState();
  }

  EdittableRequest edittableRequest = EdittableRequest();

  List<TablesList> tables = [];

  List<SpaceModel> spaces = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          edittableRequest = EdittableRequest();
          dialogMethod(context, null);
        },
        backgroundColor: HexColor("#d4ac2c"),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        actions: const [ApplogoButton()],
        backgroundColor: HexColor("#d4ac2c"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: TextWidget(
          "Manage Tables",
          style: GoogleFonts.belleza(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 33.w,
          ),
          /* color: Colors.black,
              
               */
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
        child: BlocBuilder<TableBloc, TableState>(
          buildWhen: (previous, current) {
            return current is SpaceDone ||
                current is SpaceLoad ||
                current is SpaceError ||
                current is TableInitial;
          },
          builder: (context, spacestate) {
            if (spacestate is SpaceDone) {
              spaces = spacestate.spaces;
              tableBloc.add(GetTables());
              /*  if (selectedSpace == 0) {
                tableBloc.add(FetchLeveltable(selectedTime ?? "",
                    state.spaces.isNotEmpty ? state.spaces.first.id : 0));
              } */
              //
              return DefaultTabController(
                  length: spacestate.spaces.length,
                  initialIndex: 0,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 5,
                      bottom: TabBar(
                          onTap: (value) {
                            // selectedSpace = state.spaces[value].id;
                            // setState(() {});
                            // tableBloc.add(FetchLeveltable(
                            //     selectedTime ?? "", state.spaces[value].id));
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
                          tabs: List.generate(
                              spacestate.spaces.length,
                              (index) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.w),
                                    child: TextWidget(
                                      spacestate.spaces[index].name,
                                      fontweight: FontWeight.bold,
                                    ),
                                  ))),
                    ),
                    body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        spacestate.spaces.length,
                        (id) => BlocBuilder<TableBloc, TableState>(
                          buildWhen: (previous, current) {
                            return current is TableLoad ||
                                current is GetTablesDone ||
                                current is TableError;
                          },
                          builder: (context, state) {
                            if (state is TableLoad) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is GetTablesDone) {
                              tables = state.tables
                                  .where((element) =>
                                      element.category ==
                                      spacestate.spaces[id].id)
                                  .toList();
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10.w),
                                itemCount: tables.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.w),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        border: Border(
                                            left: BorderSide(
                                                color: HexColor("#d4ac2c"),
                                                width: 5.w))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                tables[index].name,
                                                fontweight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                height: 12.w,
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: const TextWidget(
                                                            "Floor : "),
                                                      ),
                                                      Container(
                                                        child: TextWidget(
                                                          tables[index].floor,
                                                          fontweight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: const TextWidget(
                                                            "Occupancy : "),
                                                      ),
                                                      Container(
                                                        child: TextWidget(
                                                          tables[index]
                                                              .occupancy,
                                                          fontweight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ]),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                edittableRequest =
                                                    EdittableRequest(
                                                  name:
                                                      state.tables[index].name,
                                                  category: state
                                                      .tables[index].category,
                                                  floor:
                                                      state.tables[index].floor,
                                                  occupancy: state
                                                      .tables[index].occupancy,
                                                );
                                                dialogMethod(context,
                                                    state.tables[index].id);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.w),
                                                      color: Colors
                                                          .green.shade900),
                                                  height: 50.w,
                                                  width: 50.w,
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                DialogWidget().dialogWidget(
                                                  context,
                                                  "Are you sure you want to delete?",
                                                  () {
                                                    Navigator.pop(context);
                                                  },
                                                  () {
                                                    Navigator.pop(context);
                                                    tableBloc.add(DeleteTables(
                                                        state
                                                            .tables[index].id));
                                                  },
                                                );
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.w),
                                                      color:
                                                          Colors.red.shade900),
                                                  height: 50.w,
                                                  width: 50.w,
                                                  child: const Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                            if (state is TableError) {
                              const TextWidget("Error");
                            }

                            return Container();
                          },
                        ),
                      ),
                    ),
                  ));
            }
            if (spacestate is SpaceLoad || spacestate is TableInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (spacestate is SpaceError) {
              return TextWidget(spacestate.errorMessage);
            }
            return const TextWidget("");
          },
        ),
      ),
    );
  }

  Future<dynamic> dialogMethod(BuildContext context, int? id) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setstate) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller:
                        TextEditingController.fromValue(TextEditingValue(
                      text: edittableRequest.name?.toString() ?? "",
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            offset:
                                edittableRequest.name?.toString().length ?? 0),
                      ),
                    )),
                    onChanged: (value) {
                      edittableRequest.name = value;
                      setstate(() {});
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: HexColor("#d4ac2c"),
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  typesDropdown(context, spaces),
                  SizedBox(
                    height: 10.w,
                  ),
                  floorDropdown(context, ["0", "1", "2", "3", "4", "5"]),
                  SizedBox(
                    height: 10.w,
                  ),
                  TextFormField(
                    controller:
                        TextEditingController.fromValue(TextEditingValue(
                      text: edittableRequest.occupancy?.toString() ?? "",
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            offset:
                                edittableRequest.occupancy?.toString().length ??
                                    0),
                      ),
                    )),
                    onChanged: (value) {
                      edittableRequest.occupancy = value;
                      setstate(() {});
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Occupancy",
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: HexColor("#d4ac2c"),
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ],
              ),
              title: Center(
                child: TextWidget(
                  id == null ? "Add Table" : "Edit Table",
                  fontweight: FontWeight.bold,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                button("Cancel", () {
                  navigatorKey.currentState?.pop();
                }, Colors.red.shade900),
                button("Submit", () {
                  if (_formKey.currentState!.validate()) {
                    navigatorKey.currentState?.pop();
                    tableBloc.add(CreateTables(edittableRequest, id: id));
                  }
                }, Colors.green.shade900)
              ],
            ),
          );
        });
      },
    );
  }

  floorDropdown(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: const TextWidget(
            "Floor",
            fontweight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
        Container(
          alignment: Alignment.center,
          height: 70.w,
          // width: MediaQuery.of(context).size.width * 0.45,
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: CustomDropdownButton(
              value: (edittableRequest.floor != null)
                  ? items
                      .where((element) => element == edittableRequest.floor)
                      .toList()
                      .first
                  : null,
              hint: TextWidget(
                "Floor",
                color: Colors.black54,
                size: 20.sp,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              underline: Container(),
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
              dropdownColor: Colors.black,
              iconEnabledColor: Colors.black,
              iconDisabledColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              onChanged: (dynamic value) {
                edittableRequest.floor = value;
                setState(() {});
              },
              items: items.toList().map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }

  typesDropdown(BuildContext context, List<SpaceModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: const TextWidget(
            "Category",
            fontweight: FontWeight.w500,
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
        Container(
          alignment: Alignment.center,
          height: 70.w,
          // width: MediaQuery.of(context).size.width * 0.45,
          margin: EdgeInsets.symmetric(horizontal: 0.w),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: CustomDropdownButton(
              value: (edittableRequest.category != null)
                  ? items
                      .where(
                          (element) => element.id == edittableRequest.category)
                      .toList()
                      .first
                  : null,
              hint: TextWidget(
                "Category",
                color: Colors.black54,
                size: 20.sp,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              underline: Container(),
              icon: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
              dropdownColor: Colors.black,
              iconEnabledColor: Colors.black,
              iconDisabledColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                edittableRequest.category = value.id;
                setState(() {});
              },
              items: items.toList().map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }
}
