import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/models/availableTables_model.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class ManageTable extends StatefulWidget {
  const ManageTable({super.key});

  @override
  State<ManageTable> createState() => _ManageTableState();
}

class _ManageTableState extends State<ManageTable> {
  TableBloc tableBloc = TableBloc();
  @override
  void initState() {
    tableBloc = BlocProvider.of(context);
    tableBloc.add(FetchSpaces());
    super.initState();
  }

  List<TablesList> tables = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
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
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                    color:
                                                        Colors.green.shade900),
                                                height: 50.w,
                                                width: 50.w,
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.w),
                                                    color: Colors.red.shade900),
                                                height: 50.w,
                                                width: 50.w,
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                )),
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
}
