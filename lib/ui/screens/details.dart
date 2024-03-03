import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/models/orderlist_model.dart';
import 'package:hotelpro_mobile/route_generator.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/orders/orders_bloc.dart';
import '../../bloc/table/table_bloc.dart';

import '../widgets/dialog_widget.dart';
import '../widgets/text_widget.dart';

class DetailScreen extends StatefulWidget {
  final dynamic data;
  const DetailScreen({super.key, required this.data});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TableBloc tableBloc = TableBloc();
  List<bool> editList = [];
  // List<ItemOrders> items = [];
  OrdersBloc ordersBloc = OrdersBloc();
  TextEditingController notesController = TextEditingController();
  TextEditingController deletereasonController = TextEditingController();
  String role = "";
  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";
    print(role);
  }

  bool? completed;
  @override
  void initState() {
    getRole();
    // initPrinter();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getUserid();
    });

    tableBloc = BlocProvider.of<TableBloc>(context)
      ..stream.listen((event) {
        if (event is PrintKotDone) {
          EasyLoading.showSuccess('Success!');
        }
        if (event is PrintKotLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is PrintKotError) {
          EasyLoading.showError(event.errorMessage);
        }
        if (event is AssignDone) {
          EasyLoading.showSuccess('Success!');
          widget.data["waiter"] = int.parse(userId);
          setState(() {});

          tableBloc.add(FetchTables(widget.data["type"]));
        }
        if (event is AssignLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AssignError) {
          EasyLoading.showError('Failed with Error');
        }
      });

    tableBloc.add(FetchTables(widget.data["type"]));
    ordersBloc = BlocProvider.of<OrdersBloc>(context)
      ..stream.listen((event) {
        if (event is EditOrdersDone || event is EditOrdersNodata) {
          EasyLoading.showSuccess('Success!');
          ordersBloc.add(FetchOrders(widget.data["rId"], widget.data["tId"]));
        }
        if (event is EditOrdersLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is EditOrdersError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    ordersBloc.add(FetchOrders(widget.data["rId"], widget.data["tId"]));

    editList = [];

    super.initState();
  }

  String message = "";
  final info = NetworkInfo();
  late NetworkPrinter printer;
  PosPrintResult? res;
  initPrinter() async {
    const PaperSize paper = PaperSize.mm80;
    // Initialize Bluetooth connection

    final profile = await CapabilityProfile.load();

    printer = NetworkPrinter(paper, profile);

    res = await printer.connect("192.168.29.138", port: 9100);

    // print("printers${res.msg}");
    message = res?.msg ?? "";
    setState(() {});

    if (res == PosPrintResult.success) {
      Fluttertoast.showToast(msg: "Printer connected");
    }
  }

  String userId = "";

  getUserid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("userId") ?? "";

    setState(() {});
  }

  Future<void> _refresh() async {
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    ordersBloc.add(FetchOrders(widget.data["rId"], widget.data["tId"]));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.data["fromtable"]) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', arguments: 2, (Route<dynamic> route) => false);
        } else {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
              "/viewReservation",
              arguments: {"rId": widget.data["rId"], "nonDiner": false},
              (Route<dynamic> route) => false);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#d4ac2c"),
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                if (widget.data["fromtable"]) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      arguments: bottomIndex,
                      (Route<dynamic> route) => false);
                } else {
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(
                      "/viewReservation",
                      arguments: {"rId": widget.data["rId"], "nonDiner": false},
                      (Route<dynamic> route) => false);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.arrow_back_ios),
              )),
          title: TextWidget(
            "Order Items",
            fontweight: FontWeight.bold,
            size: 22.sp,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            BlocBuilder<OrdersBloc, OrdersState>(
              buildWhen: (previous, current) {
                return current is OrdersDone ||
                    current is OrdersLoad ||
                    current is OrdersError;
              },
              builder: (context, state) {
                print("akshaya $state");
                return state is OrdersDone
                    ? (state.orders.isNotEmpty &&
                            state.orders.first.completed == false)
                        ? IconButton(
                            onPressed: () {
                              DialogWidget().dialogWidget(
                                context,
                                "Sure to confirm?",
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);
                                  print(widget.data["rId"]);
                                  ordersBloc.add(CompleteOrder(
                                      state.orders.first.id.toString(),
                                      (widget.data["rId"])));
                                },
                              );
                            },
                            icon: Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                  color: state.orders.first.completed
                                      ? Colors.grey
                                      : Colors.green.shade900,
                                  borderRadius: BorderRadius.circular(35.w)),
                              child: const Icon(
                                Icons.done_sharp,
                                color: Colors.white,
                              ),
                            ))
                        : Container()
                    : Container();
              },
            )
          ],
        ),
        body: RefreshIndicator(
          color: HexColor("#d4ac2c"),
          onRefresh: _refresh,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: BlocBuilder<OrdersBloc, OrdersState>(
                  buildWhen: (previous, current) {
                    return current is OrdersDone ||
                        current is OrdersLoad ||
                        current is OrdersError;
                  },
                  builder: (context, state) {
                    if (state is OrdersDone) {
                      if (state.orders.isNotEmpty) {
                        state.orders.first.itemOrders
                            .toList()
                            .forEach((element) {
                          editList.add(false);
                        });
                      }
                      ordersBloc.add(GetUsername(widget.data["waiter"]));
                      return Column(
                        children: [
                          if (widget.data["waiter"].toString() !=
                              userId.toString())
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                mainAxisAlignment: widget.data["waiter"] == 0
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.spaceBetween,
                                children: [
                                  if (widget.data["waiter"] != 0)
                                    BlocBuilder<OrdersBloc, OrdersState>(
                                      builder: (context, state) {
                                        if (state is GetnameDone) {
                                          return TextWidget(
                                            state.data.username.isNotEmpty
                                                ? "${state.data.username.capitalize()} is serving.."
                                                : "-",
                                            size: 18.sp,
                                            color: Colors.black45,
                                          );
                                        }
                                        if (state is GetnameLoad) {
                                          return const SizedBox(
                                              height: 5,
                                              width: 80,
                                              child: LinearProgressIndicator());
                                        }
                                        if (state is GetnameError) {
                                          return TextWidget(
                                            "Failed to fetch waiter name!",
                                            size: 18.sp,
                                            color: Colors.red.shade900,
                                          );
                                        }
                                        return const TextWidget("");
                                      },
                                    ),
                                  button("Assign to me", () {
                                    tableBloc.add(AssignTables(
                                        widget.data["rId"].toString(),
                                        [widget.data["tId"]]));
                                  }, HexColor("#d4ac2c"),
                                      textcolor: Colors.black)
                                ],
                              ),
                            ),
                          if (widget.data["waiter"].toString() ==
                              userId.toString())
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    /*  if (res == PosPrintResult.success ||
                                        res == PosPrintResult.printInProgress) {
                                      testReceipts(
                                          printer, state.orders.first.itemOrders);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Printer not connected");
                                    } */

                                    tableBloc.add(PrintKotEvent(
                                        widget.data["rId"],
                                        widget.data["waiter"],
                                        kot: true));
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10.w, top: 5.w),
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Colors.grey.shade400)),
                                    child: Row(children: [
                                      Icon(
                                        Icons.receipt,
                                        color: HexColor("#d4ac2c"),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      const TextWidget(
                                        "Print KOT",
                                        color: Colors.black,
                                        fontweight: FontWeight.bold,
                                      )
                                    ]),
                                  ),
                                ),
                                //SizedBox(width: 60, child: TextWidget(message)),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 15.w, top: 5.w),
                                  child: button(
                                      state.orders.isEmpty
                                          ? "Add Order"
                                          : "Add Items", () {
                                    navigatorKey.currentState?.pushNamed(
                                        "/categoryScreen",
                                        arguments: {
                                          "reservId": widget.data["rId"],
                                          "orderId": state.orders.isNotEmpty
                                              ? state.orders.first.id
                                              : null,
                                          "identifier":
                                              widget.data["identifier"],
                                          "update": state.orders.isNotEmpty,
                                          "tableId": widget.data["tId"],
                                          "type": widget.data["type"],
                                          "waiter": widget.data["waiter"],
                                          "fromtable": widget.data["fromtable"]
                                        });
                                  }, HexColor("#d4ac2c"),
                                      textcolor: Colors.black),
                                )
                              ],
                            ),
                          if (state.orders.isNotEmpty)
                            Container(
                              margin: EdgeInsets.all(10.w),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  color: Colors.grey.shade200,
                                  border: Border.all(color: Colors.black)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const TextWidget("Order No : "),
                                      TextWidget(
                                        state.orders.first.orderNo,
                                        fontweight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  state.orders.first.completed
                                      ? Icon(
                                          Icons.verified,
                                          color: Colors.green.shade900,
                                        )
                                      : Icon(
                                          Icons.pending_actions_sharp,
                                          color: Colors.red.shade900,
                                        )
                                ],
                              ),
                            ),
                          Expanded(
                            child: state.orders.isNotEmpty
                                ? ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.w),
                                    itemCount:
                                        state.orders.first.itemOrders.length,
                                    itemBuilder: (context, index) {
                                      return itemCard(state, index);
                                    },
                                  )
                                : const Center(
                                    child: TextWidget("No Order found")),
                          ),
                        ],
                      );
                    }
                    if (state is OrdersLoad) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const TextWidget("error");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void testReceipts(NetworkPrinter printer, List<ItemOrders> items) {
    printer.text(
        'Date ${DateFormat("dd/MM/yyyy hh:mm:ss a").format(DateTime.now())}',
        styles: const PosStyles(align: PosAlign.left));
    printer.text('Your Store Name',
        styles:
            const PosStyles(align: PosAlign.center, height: PosTextSize.size2));
    printer.text('123 Main St, City, Country',
        styles: const PosStyles(align: PosAlign.center));
    printer.text('Tel: +123456789',
        styles: const PosStyles(align: PosAlign.center));
    printer.text(
        'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
        styles: const PosStyles(align: PosAlign.center));
    printer.text('--------------------------------',
        styles: const PosStyles(align: PosAlign.center));
    // printer.hr();
    printer.row([
      PosColumn(text: 'Item', width: 4),
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Price', width: 2),
      PosColumn(text: 'Total', width: 3),
    ]);
    printer.text('--------------------------------',
        styles: const PosStyles(align: PosAlign.center));
    for (var data in items) {
      printer.text(
          '${data.itemName}          ${data.itemQuantity}  ${data.itemPrice}',
          styles: const PosStyles(align: PosAlign.left));
    }
    /*    printer.row([
      PosColumn(
        text: 'Table : LF1',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Order : Samudhra',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]); */
    printer.text('Table : LF1', styles: const PosStyles(align: PosAlign.left));
    printer.text("Samudhra", styles: const PosStyles(align: PosAlign.left));
    printer.text('Waiter ${widget.data["waiter"]}',
        styles: const PosStyles(align: PosAlign.left));
    // printer.emptyLines(1);
    /*  printer.row([
      PosColumn(
        text: 'ITEM',
        width: 3,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'QTY',
        width: 6,
        styles: const PosStyles(align: PosAlign.center),
      ),
      PosColumn(
        text: 'OPERATION',
        width: 3,
        styles: const PosStyles(align: PosAlign.center),
      ),
    ]);
    printer.emptyLines(1);
    for (var data in items) {
      printer.row([
        PosColumn(
          text: data.itemName,
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: data.itemQuantity.toString(),
          width: 6,
          styles: const PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: 'ADD_ITEM',
          width: 3,
          styles: const PosStyles(align: PosAlign.center),
        ),
      ]);
    } */

    printer.feed(2);
    printer.cut();
    printer.disconnect();

    //printer.printCodeTable()
  }

  final _deletedialogKey = GlobalKey<FormState>();
  Container itemCard(OrdersDone state, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: TextWidget(
                  state.orders.first.itemOrders[index].itemName,
                  fontweight: FontWeight.bold,
                  size: 18.sp,
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20.w),
                    decoration: BoxDecoration(
                        color: HexColor("#d4ac2c").withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: HexColor("#d4ac2c"))),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                    child: TextWidget(
                      state.orders.first.itemOrders[index].subcategoryName,
                      size: 17.sp,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.w, left: 5.w),
                    decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.green.shade900)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                    child: TextWidget(
                      "₹ ${state.orders.first.itemOrders[index].itemPrice}",
                      size: 17.sp,
                      fontweight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IgnorePointer(
                ignoring: !editList[index],
                child: quantityCounter(state, index, editList[index]),
              ),
              SizedBox(
                height: 5.w,
              ),
              if (!state.orders.first.completed ||
                  (state.orders.first.completed &&
                      (role == "ROLE_MANAGER" || role == "ROLE_ADMIN")))
                Row(
                  children: [
                    GestureDetector(
                        onTap: (widget.data["waiter"].toString() !=
                                    userId.toString() &&
                                role != "ROLE_ADMIN" &&
                                role != "ROLE_MANAGER")
                            ? null
                            : editList[index]
                                ? () {
                                    DialogWidget().dialogWidget(
                                      context,
                                      "Sure to save?",
                                      () {
                                        Navigator.pop(context);

                                        editList[index] = false;
                                        ordersBloc.add(FetchOrders(
                                            widget.data["rId"],
                                            widget.data["tId"]));

                                        setState(() {});
                                      },
                                      () {
                                        Navigator.pop(context);
                                        ordersBloc.add(EditOrders(
                                            state.orders.first.id.toString(),
                                            state.orders.first.itemOrders[index]
                                                .id
                                                .toString(),
                                            state.orders.first.itemOrders[index]
                                                .itemQuantity
                                                .toString(),
                                            notesController.text));
                                        editList[index] = false;
                                        setState(() {});
                                      },
                                      notefield: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 5.w),
                                        child: Card(
                                          elevation: 1,
                                          child: TextFormField(
                                            minLines: 3,
                                            maxLines: null,
                                            controller: notesController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            decoration: InputDecoration(
                                              alignLabelWithHint: true,
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade500,
                                                      width: 0.4)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade200,
                                                      width: 0.009)),
                                              labelText:
                                                  'Enter any additional information about your order.',
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                : editList
                                        .where((element) => element == true)
                                        .toList()
                                        .isEmpty
                                    ? () {
                                        editList[index] = true;
                                        setState(() {});
                                      }
                                    : null,
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.w),
                              color: (widget.data["waiter"].toString() !=
                                          userId.toString() &&
                                      role != "ROLE_ADMIN" &&
                                      role != "ROLE_MANAGER")
                                  ? Colors.grey
                                  : editList[index]
                                      ? Colors.green
                                      : editList
                                              .where(
                                                  (element) => element == true)
                                              .toList()
                                              .isEmpty
                                          ? HexColor("#d4ac2c")
                                          : Colors.grey,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 5.w, horizontal: 15.w),
                            child: TextWidget(
                              editList[index] ? "Save" : "Edit",
                              color: Colors.white,
                              fontweight: FontWeight.w500,
                            ))),
                    SizedBox(
                      width: 5.w,
                    ),
                    GestureDetector(
                      onTap: (widget.data["waiter"].toString() !=
                                  userId.toString() &&
                              role != "ROLE_ADMIN" &&
                              role != "ROLE_MANAGER")
                          ? null
                          : () {
                              if (editList[index]) {
                                DialogWidget().dialogWidget(
                                  context,
                                  "Sure to cancel?",
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () {
                                    Navigator.pop(context);
                                    editList[index] = false;
                                    ordersBloc.add(FetchOrders(
                                        widget.data["rId"],
                                        widget.data["tId"]));
                                    /*  items = widget.order.itemOrders
                              .map((e) => ItemOrders.fromJson(e.toJson()))
                              .toList(); */
                                    setState(() {});
                                  },
                                );
                              } else if (editList
                                  .where((element) => element == true)
                                  .toList()
                                  .isEmpty) {
                                DialogWidget().dialogWidget(
                                  context,
                                  "Confirm Delete Item from Order?",
                                  () {
                                    deletereasonController.clear();
                                    Navigator.pop(context);
                                  },
                                  () {
                                    if (_deletedialogKey.currentState!
                                        .validate()) {
                                      Navigator.pop(context);
                                      ordersBloc.add(DeleteItem(
                                          state.orders.first.id.toString(),
                                          state
                                              .orders.first.itemOrders[index].id
                                              .toString(),
                                          deletereasonController.text));
                                    }
                                  },
                                  notefield: Form(
                                    key: _deletedialogKey,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.w),
                                      child: Card(
                                        elevation: 1,
                                        child: TextFormField(
                                          minLines: 3,
                                          maxLines: null,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "Please enter valid reason";
                                            }
                                            return null;
                                          },
                                          controller: deletereasonController,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            labelStyle: const TextStyle(
                                                color: Colors.black),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade500,
                                                    width: 0.4)),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey.shade200,
                                                    width: 0.009)),
                                            labelText:
                                                'Enter valid reason to delete',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                      child: Container(
                          decoration: BoxDecoration(
                              color: (widget.data["waiter"].toString() !=
                                          userId.toString() &&
                                      role != "ROLE_ADMIN" &&
                                      role != "ROLE_MANAGER")
                                  ? Colors.grey
                                  : editList[index]
                                      ? Colors.red.shade900
                                      : editList
                                              .where(
                                                  (element) => element == true)
                                              .toList()
                                              .isEmpty
                                          ? Colors.red.shade900
                                          : Colors.grey,
                              borderRadius: BorderRadius.circular(7.w)),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.w, horizontal: 15.w),
                          child: TextWidget(
                            editList[index] ? "Cancel" : "Delete",
                            color: Colors.white,
                            fontweight: FontWeight.w500,
                          )),
                    )
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }

  InputDecoration txtfieldDecoration(bool value) {
    return InputDecoration(
      suffixIcon: Icon(
        Icons.edit,
        color: Colors.grey.shade800,
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      fillColor: Colors.red,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: const BorderSide(color: Colors.black, width: 0.5),
      ),
    );
  }

  quantityCounter(OrdersDone state, int index, bool value) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: value ? HexColor("#d4ac2c") : Colors.grey,
      ),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                state.orders.first.itemOrders[index].itemQuantity =
                    (state.orders.first.itemOrders[index].itemQuantity ?? 0) -
                        1;
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 20.sp,
                ),
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3), color: Colors.white),
            child: Text(
              state.orders.first.itemOrders[index].itemQuantity.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          InkWell(
              onTap: () {
                state.orders.first.itemOrders[index].itemQuantity =
                    (state.orders.first.itemOrders[index].itemQuantity ?? 0) +
                        1;
                setState(() {});
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20.sp,
                ),
              )),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
