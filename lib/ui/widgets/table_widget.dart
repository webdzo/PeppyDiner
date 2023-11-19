import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/models/table_model.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

import 'button.dart';

class TableWidget extends StatefulWidget {
  final bool myTable;
  final String type;
  final String userId;
  List<TableModel> tableList;
  final bool nonDiner;
  TableWidget({
    Key? key,
    this.myTable = false,
    this.tableList = const [],
    required this.type,
    required this.userId,
    this.nonDiner = false,
  }) : super(key: key);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {
  List<int> selectedTable = [];
  TableBloc tableBloc = TableBloc();
  @override
  void initState() {
    tableBloc = BlocProvider.of<TableBloc>(context)
      ..stream.listen((event) {
        if (event is AssignDone) {
          selectedTable = [];
          EasyLoading.showSuccess('Success!');

          tableBloc.add(FetchTables(widget.type, nonDiner: widget.nonDiner));
        }
        if (event is AssignLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AssignError) {
          EasyLoading.showError('Failed with Error');
          tableBloc.add(FetchTables(widget.type, nonDiner: widget.nonDiner));
        }
      });

    if (bottomIndex == 0 || bottomIndex == 1 || bottomIndex == 2) {
      tableBloc.add(FetchTables(widget.type, nonDiner: widget.nonDiner));
    }

    super.initState();
  }

  ExpansionTileController controller = ExpansionTileController();

  String type = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(
      buildWhen: (previous, current) {
        return current is TableLoad ||
            current is TableInitial ||
            current is TableError ||
            current is TableNodata ||
            current is TableDone;
      },
      builder: (context, state) {
     
        if (state is TableLoad || state is TableInitial) {
          return Center(
            child: SizedBox(
                height: 30.w,
                width: 30.w,
                child: const CircularProgressIndicator()),
          );
        }
        if (state is TableDone) {
          widget.tableList = state.tables;
          return widget.tableList.isNotEmpty
              ? ListView.builder(
                  itemCount: widget.tableList.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        listCardwidget(index, context),
                        if (widget.nonDiner)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: SizedBox(
                                /*   width: 600,
                            height: 200, */
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    /// background image
                                    Container(
                                      color: Colors.deepPurple,
                                    ),
                                    CustomPaint(
                                      painter: CardPaint(),
                                      size: const Size(100, 20),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextWidget(
                                        widget.tableList[index].diningType
                                                .isNotEmpty
                                            ? widget.tableList[index].diningType
                                                .capitalize()
                                            : "-",
                                        fontweight: FontWeight.w500,
                                        size: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                )
              : Center(
                  child: TextWidget((widget.nonDiner || widget.myTable)
                      ? "No Reservations found"
                      : "No Tables Found"));
        }
        if (state is TableNodata) {
          return Center(
              child: TextWidget((widget.nonDiner || widget.myTable)
                  ? "No Reservations found"
                  : "No Tables Found"));
          // Lottie.asset('assets/nodata.json')
        }
        if (state is TableError) {
          return const Center(child: TextWidget("Error"));
        }
        return const TextWidget("Error");
      },
    );
  }

  GestureDetector listCardwidget(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed("/viewReservation", arguments: {
          "rId": widget.nonDiner
              ? widget.tableList[index].id
              : widget.tableList[index].reservationId,
          "nonDiner": (widget.tableList[index].diningType == "takeaway" ||
              widget.tableList[index].diningType == "delivery")
        }).then((value) =>
            tableBloc.add(FetchTables(widget.type, nonDiner: widget.nonDiner)));
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.w),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              animationDuration: const Duration(milliseconds: 500),
              tapHeaderToExpand: (widget.type == "past" ||
                      widget.type == "current" ||
                      widget.type == "upcoming")
                  ? false
                  : true,
              hasIcon: false,
            ),
            collapsed: const SizedBox(
              height: 2,
            ),
            header: listViewcontent(index, context),
            expanded: expandedWidget(index, context),
          )),
    );
  }

  Center expandedWidget(int index, BuildContext context) {
    return Center(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              widget.tableList[index].tableSelected.length,
              (i) => Stack(
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          if (widget.tableList[index].tableSelected[i]
                                      .waiterId ==
                                  0 &&
                              !selectedTable.contains(widget
                                  .tableList[index].tableSelected[i].tableId)) {
                            selectedTable.add(widget
                                .tableList[index].tableSelected[i].tableId);
                            setState(() {});
                          } else {
                            if (widget.type != "mytable") {
                              Fluttertoast.showToast(msg: "Already Assigned");
                            }
                          }
                        },
                        onTap: () {
                          if (!selectedTable.contains(widget
                              .tableList[index].tableSelected[i].tableId)) {
                            if (selectedTable.isEmpty) {
                              if (widget.tableList[index].tableSelected[i]
                                      .waiterId ==
                                  0) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextWidget(
                                              "Please assign to Proceed!")
                                        ],
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      actions: [
                                        button(
                                          "Cancel",
                                          () {
                                            Navigator.pop(context);
                                          },
                                          Colors.grey,
                                        ),
                                        button("Assign", () {
                                          Navigator.pop(context);
                                          tableBloc.add(AssignTables(
                                              widget.tableList[index]
                                                  .reservationId
                                                  .toString(),
                                              [
                                                widget.tableList[index]
                                                    .tableSelected[i].tableId
                                              ]));
                                        }, Colors.green,
                                            textcolor: Colors.white)
                                      ],
                                    );
                                  },
                                );
                              } else {
                                navigatorKey.currentState!
                                    .pushNamed("/details", arguments: {
                                  "rId": widget.tableList[index].reservationId,
                                  "tId": widget.tableList[index]
                                      .tableSelected[i].tableId,
                                  "type": widget.type,
                                  "identifier":
                                      widget.tableList[index].identifier,
                                  "waiter": widget.tableList[index]
                                      .tableSelected[i].waiterId,
                                  "fromtable": true
                                });
                              }
                            }
                          } else {
                            /*  selectedTable.remove(widget
                                .tableList[index].tableSelected[i].tableId);
                            setState(() {}); */
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.w),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                              color: ((widget.userId ==
                                          (widget.tableList[index]
                                              .tableSelected[i].waiterId
                                              .toString())) &&
                                      widget.type == "alltables")
                                  ? Colors.green.shade700
                                  : (widget.tableList[index].tableSelected[i]
                                                  .waiterId ==
                                              0 &&
                                          (widget.type == "alltables" ||
                                              widget.type == "unassigned"))
                                      ? Colors.grey
                                      : HexColor("#d4ac2c"),
                              shape: BoxShape.circle),
                          child: TextWidget(widget
                              .tableList[index].tableSelected[i].tableName
                              .toString()),
                        ),
                      ),
                      if (selectedTable.contains(
                          widget.tableList[index].tableSelected[i].tableId))
                        GestureDetector(
                          onTap: () {
                            selectedTable.remove(widget
                                .tableList[index].tableSelected[i].tableId);
                            setState(() {});
                          },
                          child: Container(
                              margin: EdgeInsets.all(5.w),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              )),
                        ),
                    ],
                  ))),
    );
  }

  Container listViewcontent(int index, BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 15.w, horizontal: 15.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: Row(
                      children: [
                        TextWidget(
                          "${widget.tableList[index].identifier} ",
                          fontweight: FontWeight.w600,
                          size: 18.sp,
                        ),
                        if (widget.tableList[index].guestName.isNotEmpty)
                          TextWidget(
                            "- ${widget.tableList[index].guestName}",
                            size: 18.sp,
                            fontweight: FontWeight.w600,
                          ),
                      ],
                    ),
                  ),
                  if (widget.nonDiner)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Ordered Date : ",
                              size: 16.sp,
                            ),
                            TextWidget(
                              widget.tableList[index].created,
                              fontweight: FontWeight.w500,
                              size: 16.sp,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Ordered Time : ",
                              size: 16.sp,
                            ),
                            TextWidget(
                              widget.tableList[index].createdTime,
                              fontweight: FontWeight.w500,
                              size: 16.sp,
                            )
                          ],
                        )
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                "Reservation Time",
                                size: 16.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                "Pax",
                                size: 16.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                "Tables",
                                size: 16.sp,
                                //  color: Colors.black45,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                "Notes",
                                size: 16.sp,
                                //  color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                " : ",
                                size: 16.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                " : ",
                                size: 16.sp,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: const TextWidget(
                                " : ",
                                size: 12,
                                //  color: Colors.black45,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: const TextWidget(
                                " : ",
                                size: 12,
                                //  color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                widget.tableList[index].startTime,
                                size: 16.sp,
                                fontweight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                widget.tableList[index].pax,
                                size: 16.sp,
                                fontweight: FontWeight.bold,
                              ),
                            ),
                            /*  Container(
                              padding: EdgeInsets.only(bottom: 0.w),
                              child: TextWidget(
                                // widget.tableList[index],
                                '-',
                                size: 16.sp,
                                fontweight: FontWeight.bold,
                              ),
                            ), */
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                widget.tableList[index].bookedTables,
                                size: 16.sp, fontweight: FontWeight.bold,
                                //  color: Colors.black45,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15.w),
                              child: TextWidget(
                                widget.tableList[index].notes,
                                size: 16.sp, fontweight: FontWeight.bold,
                                //  color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 15.w,
                  ),
                  if (selectedTable.isNotEmpty)
                    button("Assign", () {
                      tableBloc.add(AssignTables(
                          widget.tableList[index].reservationId.toString(),
                          selectedTable));
                    }, HexColor("#d4ac2c"), textcolor: Colors.black),
                  /*   if (widget.myTable)
                    Row(
                      children: [
                        button("Order Food", () {
                          NavigationService.navigatorKey.currentState
                              ?.pushNamed("/details", arguments: {
                            "rId": widget.tableList[index].reservationId,
                            /*  "tId":
                                    widget.tableList[index].tableSelected[i].tableId */
                          });
                        }, HexColor("#d4ac2c")),
                      ],
                    ) */
                  //  else if (widget.type == "unassigned")
                  /*  button("Assign", () {
                    tableBloc.add(AssignTables(
                        widget.tableList[index].reservationId.toString(),
                        //   widget.tableList[index].tableSelected[i].tableId
                        0.toString()));
                  }, HexColor("#d4ac2c")), */
                ],
              ),
              Column(
                children: [
                  if (widget.type == "past" ||
                      widget.type == "current" ||
                      widget.type == "upcoming")
                    if (!widget.nonDiner)
                      if (widget.type != "past")
                        if (widget.tableList[index].status != "OP")
                          button("   Open   ", () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  content: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextWidget(
                                          "Are you sure you want to Open?"),
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
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                      tableBloc.add(CloseReservation(
                                          widget.tableList[index].reservationId
                                              .toString(),
                                          close: false,
                                          open: true));
                                    }, Colors.green)
                                  ],
                                );
                              },
                            );

                            /*   */
                          }, Colors.blue.shade700),
                  SizedBox(
                    height: 5.w,
                  ),
                  if (!widget.nonDiner && (widget.type != "past"))
                    button("   Cancel  ", () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget("Are you sure you want to Cancel?"),
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
                                tableBloc.add(CloseReservation(
                                    widget.nonDiner
                                        ? widget
                                            .tableList[index].orders.first.id
                                            .toString()
                                        : widget.tableList[index].reservationId
                                            .toString(),
                                    close: true,
                                    nonDiner: widget.nonDiner));
                              }, Colors.green)
                            ],
                          );
                        },
                      );
                    }, Colors.redAccent.shade700),
                  if (widget.type != "past" &&
                      widget.tableList[index].orders.isNotEmpty &&
                      ((widget.tableList[index].orders.first.completed) ==
                          false))
                    button("   Cancel  ", () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget("Are you sure you want to Cancel?"),
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
                                tableBloc.add(CloseReservation(
                                    widget.nonDiner
                                        ? widget
                                            .tableList[index].orders.first.id
                                            .toString()
                                        : widget.tableList[index].reservationId
                                            .toString(),
                                    close: true,
                                    nonDiner: widget.nonDiner));
                              }, Colors.green)
                            ],
                          );
                        },
                      );
                    }, Colors.redAccent.shade700),
                  SizedBox(
                    height: 5.w,
                  ),
                  if (widget.nonDiner)
                    if (widget.type != "past" &&
                        widget.tableList[index].orders.isNotEmpty &&
                        ((widget.tableList[index].orders.first.completed) ==
                            false))
                      button("Complete", () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextWidget(
                                      "Are you sure you want to Complete?"),
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
                                  tableBloc.add(CloseReservation(
                                      widget.nonDiner
                                          ? widget
                                              .tableList[index].orders.first.id
                                              .toString()
                                          : widget
                                              .tableList[index].reservationId
                                              .toString(),
                                      close: false,
                                      open: false,
                                      nonDiner: widget.nonDiner,
                                      nonDiveResrvid:
                                          widget.tableList[index].id));
                                }, Colors.green)
                              ],
                            );
                          },
                        );

                        /*   */
                      }, Colors.green.shade900),
                  if (!widget.nonDiner && widget.type != "past")
                    button("Complete", () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                    "Are you sure you want to Complete?"),
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
                                tableBloc.add(CloseReservation(
                                    widget.nonDiner
                                        ? widget
                                            .tableList[index].orders.first.id
                                            .toString()
                                        : widget.tableList[index].reservationId
                                            .toString(),
                                    close: false,
                                    open: false,
                                    nonDiner: widget.nonDiner,
                                    nonDiveResrvid:
                                        widget.tableList[index].id));
                              }, Colors.green)
                            ],
                          );
                        },
                      );

                      /*   */
                    }, Colors.green.shade700),
                  SizedBox(
                    height: 20.w,
                  ),
                ],
              )
            ],
          ),
          if (widget.type != "past" &&
              widget.type != "current" &&
              widget.type != "upcoming")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Divider(),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400, shape: BoxShape.circle),
                      child: Icon(
                        Icons.keyboard_double_arrow_down,
                        color: Colors.black,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
                const Divider()
              ],
            )
        ],
      ),
    );
  }

  /* Container iconbuttonWidget(Color color, String iconData) {
    return TextButton(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8.w)),
        child: TextWidget(
          iconData,
          color: Colors.white,
          size: 18.sp,
        ));
  } */
}

class CardPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = HexColor("#d4ac2c");

    Path path = Path()
      ..lineTo(size.width * .7, 0)
      ..lineTo(size.width * .6, size.height * .6)
      ..lineTo(size.width * .8, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
