import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/availableRooms/availableRooms_bloc.dart';
import 'package:hotelpro_mobile/bloc/availableRooms/availableRooms_event.dart';
import 'package:hotelpro_mobile/bloc/availableRooms/availableRooms_state.dart';
import 'package:hotelpro_mobile/bloc/bloc/billpayment_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/models/billupdate_request.dart';
import 'package:hotelpro_mobile/models/paymentmode_model.dart';
import 'package:hotelpro_mobile/models/payments_model.dart';
import 'package:hotelpro_mobile/models/updatemode_request.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/add_reservation.dart';
import 'package:hotelpro_mobile/ui/widgets/dropdown.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidget;
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/addReservation/add_reservation_bloc.dart';
import '../../bloc/addReservation/add_reservation_event.dart';
import '../../bloc/addReservation/add_reservation_state.dart';
import '../../bloc/orders/orders_bloc.dart';
import '../../bloc/reservations/reservations_bloc.dart';
import '../../models/addOrders_request.dart';
import '../../models/addReserv_request.dart';
import '../../models/availableTables_model.dart';
import '../../route_generator.dart';
import '../widgets/button.dart';
import '../widgets/dialog_widget.dart';
import '../widgets/text_widget.dart';

class ViewResercations extends StatefulWidget {
  final dynamic id;
  const ViewResercations({super.key, required this.id});

  @override
  State<ViewResercations> createState() => _ViewResercationsState();
}

class _ViewResercationsState extends State<ViewResercations> {
  ReservationsBloc reservationBloc = ReservationsBloc();
  AddResevationBloc addResevationBloc = AddResevationBloc();
  OrdersBloc ordersBloc = OrdersBloc();
  AddOrdersRequest addOrdersRequest = AddOrdersRequest();
  String reservId = "";
  String guestName = "";
  String balanceAmount = "";
  String? tempBal;
  List<bool> editGuest = [];
  Map<String, String> guestData = {};
  List<bool> editList = [];
  TextEditingController notesController = TextEditingController();
  BillpaymentBloc billpaymentBloc = BillpaymentBloc();
  BillupdateRequest billupdateRequest = BillupdateRequest(data: BillData());
  List<PaymentmodeModel> paymodes = [];
  List<UpdatemodeRequest> modeReq = [];
  TextEditingController startDate = TextEditingController();

  TextEditingController endDate = TextEditingController();

  String role = "";
  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";
    print(role);
  }

  bool isCardPresent(String current) {
    for (var payment in modeReq) {
      if (payment.mode == current) {
        return true;
      }
    }
    return false;
  }

  bool isSumGreaterThanTotal(int totalAmount, int enteredAmount) {
    int sum = 0;
    for (var payment in modeReq) {
      sum += double.tryParse(payment.value.toString())?.toInt() ?? 0;
    }

    print("${sum + enteredAmount} --- $totalAmount");
    return sum + enteredAmount > totalAmount;
  }

  AvailableRoomsBloc availableRooms = AvailableRoomsBloc();
  List<TablesList> tableList = [];
  @override
  void initState() {
    getRole();
    availableRooms = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is FetchRoomsDone) {
          tableList = event.tableList;
          setState(() {});
        }
      });

    availableRooms.add(FetchRooms());
    billpaymentBloc = BlocProvider.of<BillpaymentBloc>(context)
      ..stream.listen((event) {
        if (event is UpdateLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is UpdateDone) {
          EasyLoading.showSuccess('Success!');
        } else if (event is UpdateError) {
          EasyLoading.showError('Failed with Error');
        }
        if (event is PaymodeDone) {
          print("akshaya");
          print(event.modes);
          setState(() {
            paymodes = event.modes;
          });
        }
      });
    billpaymentBloc.add(FetchPayModes());
    // billpaymentBloc.add(FetchDiscount());
    billpaymentBloc.add(FetchService(id: widget.id["rId"].toString()));
    billpaymentBloc.add(FetchBill(widget.id["rId"].toString()));

    addResevationBloc = BlocProvider.of<AddResevationBloc>(context)
      ..stream.listen((event) {
        if (event is AddReservationDone) {
          EasyLoading.showSuccess('Success!');
          Future.delayed(const Duration(seconds: 1), () {
            reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
          });
        }
        if (event is AddReservationLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AddReservationError) {
          EasyLoading.showError('Failed with Error');
          reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
        }
      });

    reservationBloc = BlocProvider.of<ReservationsBloc>(context)
      ..stream.listen((event) {
        if (event is SwapDone) {
          EasyLoading.showSuccess('Success!');
          Future.delayed(const Duration(seconds: 2), () {
            reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
          });
        }
        if (event is SwapLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is SwapError) {
          EasyLoading.showError('Failed with Error');
        }
        if (event is MarkDone) {
          EasyLoading.showSuccess('Success!');
          Future.delayed(const Duration(seconds: 2), () {
            reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
          });
        }
        if (event is MarkLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is MarkError) {
          EasyLoading.showError('Failed with Error');
        }
        //  print(event);
        if (event is ReservationDetailsDone) {
          /*  event.reservationList.guests.toList().forEach((element) {
            editGuest.add(false);
          }); */
        }
        if (event is PaynowDone) {
          payController.text = "";
          modeReq = [];
          EasyLoading.showSuccess('Success!');
          Future.delayed(const Duration(seconds: 2), () {
            reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
          });
        }
        if (event is PaynowLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is PaynowError) {
          EasyLoading.showError('Failed with Error');
          Future.delayed(const Duration(seconds: 2), () {
            reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
          });
        }

        if (event is SplitDone) {
          selectedSplit = "0";
          EasyLoading.showSuccess('Success!');
        }
        if (event is SplitLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is SplitError) {
          selectedSplit = "0";
          EasyLoading.showError('Failed with Error');
        }

        if (event is PrintDone) {
          EasyLoading.showSuccess('Success!');
        }
        if (event is PrintLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is PrintError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    ordersBloc = BlocProvider.of<OrdersBloc>(context)
      ..stream.listen((event) {
        if (event is EditOrdersDone) {
          EasyLoading.showSuccess('Success!');
          reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));
        }
        if (event is EditOrdersLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is EditOrdersError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    reservationBloc.add(ReservationDetailsEvent(widget.id["rId"]));

    super.initState();
  }

  TextEditingController payController = TextEditingController();

  ValueNotifier<String> checkIn = ValueNotifier("details");
  List<TablesList> roomDetails = [];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
            '/home',
            arguments: widget.id["nonDiner"] ? 1 : 0,
            (Route<dynamic> route) => true);
        return false;
      },
      child: Scaffold(
        appBar: appbarWidget(context),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: (widget.id["nonDiner"] ?? false)
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      if (widget.id["nonDiner"] ?? false) nondinerToggle(),
                      swapButtons()
                    ],
                  ),
                ),
                ValueListenableBuilder<String>(
                    valueListenable: checkIn,
                    builder: (context, snapshot, _) {
                      return snapshot == "details"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                detailsWidget(),
                              ],
                            )
                          : ordersWidget();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column billsummaryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              BlocBuilder<BillpaymentBloc, BillpaymentState>(
                buildWhen: (previous, current) {
                  return current is BillDone ||
                      current is BillError ||
                      current is BillLoad;
                },
                builder: (context, state) {
                  if (state is BillDone) {
                    print(state.bill.toJson());
                    billupdateRequest.data.serviceCharge ??=
                        state.bill.serviceCharge;
                    billupdateRequest.data.flatDiscount ??=
                        state.bill.flatDiscount.toString();
                    billupdateRequest.data.taxGst ??=
                        state.bill.taxGst.toString();

                    billupdateRequest.data.paymentType ??=
                        state.bill.flatDiscountType.toString();
                  }

                  if (billupdateRequest.data.serviceCharge == null) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {});
                    });
                  }

                  return TextFormField(
                    controller:
                        TextEditingController.fromValue(TextEditingValue(
                      text: billupdateRequest.data.taxGst?.toString() ?? "",
                      selection: TextSelection.fromPosition(
                        TextPosition(
                            offset: (billupdateRequest.data.taxGst.toString())
                                .length),
                      ),
                    )),
                    onChanged: (value) {
                      billupdateRequest.data.taxGst = value;
                      setState(() {});
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          )),
                          child: const Icon(Icons.percent)),
                      labelText: "Tax",
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
                  );
                },
              ),
              SizedBox(
                height: 10.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.w,
        ),
        const Divider(
          height: 2,
          color: Colors.black,
        ),
        SizedBox(
          height: 10.w,
        ),
        BlocBuilder<BillpaymentBloc, BillpaymentState>(
          buildWhen: (previous, current) {
            return current is BillDone ||
                current is BillError ||
                current is BillLoad;
          },
          builder: (context, state) {
            return typesDropdown(context, typeList);
          },
        ),
        // BlocBuilder<BillpaymentBloc, BillpaymentState>(
        //   buildWhen: (previous, current) {
        //     return current is PaymentsDone ||
        //         current is PaymentsError ||
        //         current is PaymentsLoad;
        //   },
        //   builder: (context, state) {

        //     return typesDropdown(context, typeList);
        //   },
        // ),
        SizedBox(
          height: 20.w,
        ),
        discountWidget(),
        SizedBox(
          height: 20.w,
        ),
        const Divider(
          height: 1,
          color: Colors.black,
        ),
        SizedBox(
          height: 10.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: const TextWidget(
            "Service Charge",
            fontweight: FontWeight.bold,
          ),
        ),
        IgnorePointer(
            ignoring: (role != "ROLE_MANAGER" && role != "ROLE_ADMIN"),
            child: serviceWidget()),
        SizedBox(
          height: 10.w,
        ),
        // BlocBuilder<BillpaymentBloc, BillpaymentState>(
        //   buildWhen: (previous, current) {
        //     return current is PaymentsDone ||
        //         current is PaymentsError ||
        //         current is PaymentsLoad;
        //   },
        //   builder: (context, state) {
        //     return paymentDropdown(
        //         context, state is PaymentsDone ? state.payments : []);
        //   },
        // ),
        SizedBox(
          height: 5.w,
        ),
        Center(
          child: button("Update", () {
            billpaymentBloc.add(UpdateBill(
                billupdateRequest..data, widget.id["rId"].toString()));
          }, HexColor("#d4ac2c"), textcolor: Colors.black, size: 20.sp),
        )
      ],
    );
  }

  Container paymentDropdown(
      BuildContext context, List<PaymentsModel> payments) {
    return Container(
      alignment: Alignment.center,
      height: 70.w,
      // width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: CustomDropdownButton(
          value: (billupdateRequest.data.paymentMode != null &&
                  billupdateRequest.data.paymentMode != "")
              ? payments
                  .where((element) =>
                      element.paymentName == billupdateRequest.data.paymentMode)
                  .toList()
                  .first
              : null,
          hint: TextWidget(
            "Payment Mode",
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
            billupdateRequest.data.paymentMode = value.paymentName;
            setState(() {});
          },
          items: payments.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.paymentName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList()),
    );
  }

  typesDropdown(BuildContext context, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: const TextWidget(
            "Discount Type",
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
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(5.w),
          ),
          child: CustomDropdownButton(
              value: (billupdateRequest.data.paymentType != null &&
                      billupdateRequest.data.paymentType != "")
                  ? ["fixed", "percentage"]
                      .where((element) =>
                          element == billupdateRequest.data.paymentType)
                      .toList()
                      .first
                  : null,
              hint: TextWidget(
                "Discount Type",
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
                billupdateRequest.data.paymentType = value.toString();
                setState(() {});
              },
              items: ["fixed", "percentage"].toList().map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.capitalize(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                );
              }).toList()),
        ),
      ],
    );
  }

  String payMode = "";
  Container paymodeDropdown(
      BuildContext context, List<PaymentmodeModel> items) {
    print("-------------------");
    print(items);
    return Container(
      alignment: Alignment.center,
      height: 70.w,
      // width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.symmetric(horizontal: 0.w),

      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.7,
        ),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: CustomDropdownButton(
          value: (payMode != "")
              ? items
                  .where((element) => element.paymentName == payMode)
                  .toList()
                  .first
              : null,
          hint: TextWidget(
            "Select Mode",
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
            for (var data in modeReq) {
              log(data.toJson().toString());
            }
            payMode = value.paymentName.toString();
            setState(() {});
          },
          items: items.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.paymentName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList()),
    );
  }

  ValueListenableBuilder<String> swapButtons() {
    return ValueListenableBuilder<String>(
        valueListenable: checkIn,
        builder: (context, snapshot, _) {
          return snapshot == "orders"
              ? BlocBuilder<ReservationsBloc, ReservationsState>(
                  builder: (context, state) {
                    return state is ReservationDetailsDone
                        ? TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: HexColor("#d4ac2c")),
                            onPressed: () {
                              navigatorKey.currentState?.pushNamed(
                                  "/categoryScreen",
                                  arguments: {
                                    "reservId":
                                        state.reservationList.reservation.id,
                                    "orderId": state.reservationList.reservation
                                            .orders.isNotEmpty
                                        ? state.reservationList.reservation
                                            .orders.first.id
                                        : null,
                                    "identifier": state
                                        .reservationList.reservation.identifier,
                                    "update": state.reservationList.reservation
                                        .orders.isNotEmpty,
                                    "tableId": "",
                                    "type": state
                                        .reservationList.reservation.diningType,
                                    "waiter": "",
                                  }).then((value) => reservationBloc.add(
                                  ReservationDetailsEvent(widget.id["rId"])));
                            },
                            child: TextWidget(
                              state.reservationList.reservation.orders.isEmpty
                                  ? "Order Food"
                                  : "Add Items",
                              color: Colors.black,
                              fontweight: FontWeight.w600,
                            ))
                        : Container();
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          reservationBloc.add(PrintEvent(reservId.toString()));
                        },
                        child: const Text(
                          "Print Bill",
                          style: TextStyle(color: Colors.white),
                        )),
                    SizedBox(
                      width: 5.w,
                    ),
                    Row(
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                              side: const BorderSide(color: Colors.black),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const TextWidget(
                                      "Split bills for this reservation",
                                      fontweight: FontWeight.bold,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        userseDropdown(context, splitDtas),
                                      ],
                                    ),
                                    actions: [
                                      button("Cancel", () {
                                        payController.text = "";
                                        Navigator.pop(context);
                                      }, Colors.red, size: 18.sp),
                                      button("Submit", () {
                                        Navigator.pop(context);
                                        reservationBloc.add(SplitEvent(
                                            reservId.toString(),
                                            selectedSplit.toString()));
                                      }, Colors.green, size: 18.sp)
                                    ],
                                  );
                                },
                              );

                              //http://13.200.118.169/api/reservations/133/split-bill
                            },
                            child: const TextWidget(
                              "Split Bill",
                              color: Colors.black,
                            )),
                        SizedBox(
                          width: 10.w,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              payController.clear();
                              payMode = paymodes.first.paymentName;
                              payController.text =
                                  (double.tryParse(balanceAmount.toString()) ??
                                          0)
                                      .toInt()
                                      .toString();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setstate) {
                                    print(
                                        "$balanceAmount-$tempBal ${((double.tryParse(balanceAmount) ?? 0) - (double.tryParse(tempBal ?? "") ?? 0)).toString()}");
                                    return BlocProvider(
                                      create: (context) => billpaymentBloc,
                                      child: AlertDialog(
                                        title: TextWidget(
                                          "Balance Amount: Rs. ${((double.tryParse(balanceAmount) ?? 0) - (double.tryParse(tempBal ?? "") ?? 0)).toString()}",
                                          fontweight: FontWeight.bold,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            paymodeDropdown(context, paymodes),
                                            TextFormField(
                                              decoration: const InputDecoration(
                                                  labelText: "Enter Amount"),
                                              controller: payController,
                                            ),
                                            SizedBox(
                                              height: 10.w,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                button("Add", () {
                                                  if (!isCardPresent(payMode)) {
                                                    if (!isSumGreaterThanTotal(
                                                        double.tryParse(balanceAmount
                                                                    .toString())
                                                                ?.toInt() ??
                                                            0,
                                                        double.tryParse(
                                                                    payController
                                                                        .text)
                                                                ?.toInt() ??
                                                            0)) {
                                                      if (payMode.isNotEmpty &&
                                                          payController.text
                                                              .isNotEmpty) {
                                                        modeReq.add(
                                                            UpdatemodeRequest(
                                                                mode: payMode,
                                                                value:
                                                                    payController
                                                                        .text));

                                                        payMode = "";
                                                        payController.clear();
                                                        tempBal = modeReq
                                                            .fold(
                                                                0,
                                                                (previousValue,
                                                                        element) =>
                                                                    previousValue +
                                                                    (int.tryParse(
                                                                            element.value) ??
                                                                        0))
                                                            .toString();
                                                        setstate(() {});
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Entered amount is higher than the balance amount",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.red,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    }
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please select some other payment mode",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                    payMode = "";
                                                    setstate(() {});
                                                  }
                                                }, HexColor("#d4ac2c"),
                                                    textcolor: Colors.black),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.w,
                                            ),
                                            Column(
                                                children: List.generate(
                                                    modeReq.length,
                                                    (index) => Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    color: HexColor(
                                                                            "#d4ac2c")
                                                                        .withOpacity(
                                                                            0.3),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal: 10
                                                                            .w,
                                                                        vertical: 5
                                                                            .w),
                                                                    child:
                                                                        TextWidget(
                                                                      modeReq[index]
                                                                          .mode,
                                                                      fontweight:
                                                                          FontWeight
                                                                              .w500,
                                                                    )),
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                TextWidget(
                                                                    "Rs.${modeReq[index].value}")
                                                              ],
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  modeReq
                                                                      .removeAt(
                                                                          index);
                                                                  tempBal = modeReq
                                                                      .fold(
                                                                          0,
                                                                          (previousValue, element) =>
                                                                              previousValue +
                                                                              (int.tryParse(element.value) ?? 0))
                                                                      .toString();
                                                                  setstate(
                                                                      () {});
                                                                },
                                                                child: const Icon(
                                                                    Icons
                                                                        .close_rounded))
                                                          ],
                                                        )))
                                          ],
                                        ),
                                        actions: [
                                          button("Cancel", () {
                                            tempBal = null;
                                            modeReq = [];
                                            payController.text = "";
                                            Navigator.pop(context);
                                          }, Colors.red, size: 18.sp),
                                          button("Submit", () {
                                            if (modeReq.isNotEmpty) {
                                              tempBal = null;
                                              Navigator.pop(context);
                                              reservationBloc.add(PaynowEvent(
                                                  reservId.toString(),
                                                  modeReq));
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please add the payment details");
                                            }
                                          }, Colors.green, size: 18.sp)
                                        ],
                                      ),
                                    );
                                  });
                                },
                              );
                              /*   */
                            },
                            child: const TextWidget(
                              "Pay Now",
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                );
        });
  }

  ValueListenableBuilder<String> nondinerToggle() {
    return ValueListenableBuilder<String>(
        valueListenable: checkIn,
        builder: (context, value, _) {
          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        checkIn.value = "details";
                        reservationBloc
                            .add(ReservationDetailsEvent(widget.id["rId"]));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              color: value == "details"
                                  ? HexColor("#d4ac2c")
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.w),
                                  bottomLeft: Radius.circular(10.w))),
                          child: TextWidget(
                            "Details",
                            fontweight: FontWeight.bold,
                            color: value == "details"
                                ? Colors.black
                                : HexColor("#d4ac2c"),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        checkIn.value = "orders";
                        //ordersBloc.add(FetchOrders(widget.id));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                              color: value == "orders"
                                  ? HexColor("#d4ac2c")
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.w),
                                  bottomRight: Radius.circular(10.w))),
                          child: TextWidget(
                            "Orders",
                            fontweight: FontWeight.bold,
                            color: value == "orders"
                                ? Colors.black
                                : HexColor("#d4ac2c"),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  AppBar appbarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () {
          navigatorKey.currentState
              ?.pushReplacementNamed("/home", arguments: bottomIndex);
          // Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: HexColor("#d4ac2c"),
      title: TextWidget(
        "View Reservation",
        color: Colors.black,
        fontweight: FontWeight.w700,
        size: 22.sp,
      ),
      actions: [
        GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const TextWidget(
                      "Backdate reservation",
                      fontweight: FontWeight.bold,
                    ),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const TextWidget(
                            "Your reservation will backdate to the date chosen"),
                        SizedBox(
                          height: 10.w,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                            decoration: calendarDecoration(),
                            readOnly: true,
                            autofocus: false,
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return "Select date";
                              }
                              return null;
                            },
                            focusNode: null,
                            controller: startDate,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,

                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                        primary: HexColor("#d4ac2c"),
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child ?? const Text(""),
                                  );
                                },
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);

                                setState(() {
                                  startDate.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                        ),
                        Icon(
                          Icons.swap_vert,
                          color: Colors.grey.shade800,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                            validator: (value) {
                              if ((value ?? "").isEmpty) {
                                return "Select date";
                              }
                              return null;
                            },
                            decoration: calendarDecoration(timer: true),
                            controller: endDate,
                            readOnly: true,
                            autofocus: false,
                            focusNode: null,
                            onTap: () async {
                              final TimeOfDay? result = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, childWidget) {
                                    return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            // Using 24-Hour format
                                            alwaysUse24HourFormat: true),
                                        // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                                        child: childWidget!);
                                  });

                              if (result != null) {
                                String formattedDate = result.to24hours();

                                setState(() {
                                  endDate.text = formattedDate;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            button("Cancel", () {
                              startDate.clear();
                              endDate.clear();
                              Navigator.pop(context);
                            }, Colors.red.shade900),
                            SizedBox(
                              width: 10.w,
                            ),
                            button("Submit", () {
                              reservationBloc.add(BackdateEvent(
                                  reservId.toString(),
                                  "${startDate.text}T${endDate.text}:00Z"));
                              navigatorKey.currentState?.pop();
                            }, Colors.green.shade900)
                          ],
                        )
                      ],
                    ),
                  );
                },
              ).then((value) {
                setState(() {});
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
            ))
      ],
    );
  }

  ordersWidget() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: BlocBuilder<ReservationsBloc, ReservationsState>(
              buildWhen: (previous, current) {
                return current is ReservationsError ||
                    current is ReservationsLoad ||
                    current is ReservationDetailsDone;
              },
              builder: (context, state) {
                if (state is ReservationDetailsDone) {
                  if (state.reservationList.reservation.orders.isNotEmpty) {
                    state.reservationList.reservation.orders.first.itemOrders
                        .toList()
                        .forEach((element) {
                      editList.add(false);
                    });
                  }
                  return state.reservationList.reservation.orders.isNotEmpty
                      ? Column(
                          children: [
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
                                        state.reservationList.reservation.orders
                                            .first.orderNo,
                                        fontweight: FontWeight.bold,
                                      )
                                    ],
                                  ),
                                  state.reservationList.reservation.orders.first
                                          .completed
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
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.w),
                                itemCount: state.reservationList.reservation
                                    .orders.first.itemOrders.length,
                                itemBuilder: (context, index) {
                                  return itemCard(state, index);
                                },
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.w),
                          child: const Center(
                            child: TextWidget("No Orders Found"),
                          ),
                        );
                }
                if (state is ReservationsLoad) {
                  return const Center(
                    child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CircularProgressIndicator()),
                  );
                }

                if (state is ReservationsError) {
                  return Text(state.errorMsg);
                }

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.w),
                  child: const Center(
                    child: TextWidget("Something went wrong"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextEditingController deletereasonController = TextEditingController();
  final _deletedialogKey = GlobalKey<FormState>();
  Container itemCard(ReservationDetailsDone state, int index) {
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
              TextWidget(
                state.reservationList.reservation.orders.first.itemOrders[index]
                    .itemName,
                fontweight: FontWeight.bold,
                size: 20.sp,
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
                      state.reservationList.reservation.orders.first
                          .itemOrders[index].subcategoryName,
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
                      "₹ ${state.reservationList.reservation.orders.first.itemOrders[index].itemPrice}",
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
              /*  Row(
                children: [
                  GestureDetector(
                      onTap: editList[index]
                          ? () {
                              DialogWidget().dialogWidget(
                                context,
                                "Sure to save?",
                                () {
                                  Navigator.pop(context);

                                  editList[index] = false;
                                  reservationBloc.add(ReservationDetailsEvent(
                                      widget.id["rId"]));

                                  setState(() {});
                                },
                                () {
                                  Navigator.pop(context);
                                  ordersBloc.add(EditOrders(
                                      state.reservationList.reservation.orders
                                          .first.id
                                          .toString(),
                                      state.reservationList.reservation.orders
                                          .first.itemOrders[index].id
                                          .toString(),
                                      state.reservationList.reservation.orders
                                          .first.itemOrders[index].itemQuantity
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
                            color: editList[index]
                                ? Colors.green
                                : editList
                                        .where((element) => element == true)
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
                    onTap: () {
                      if (editList[index]) {
                        DialogWidget().dialogWidget(context, "Sure to cancel?",
                            () {
                          Navigator.pop(context);
                        }, () {
                          Navigator.pop(context);
                          editList[index] = false;
                          reservationBloc
                              .add(ReservationDetailsEvent(widget.id["rId"]));

                          setState(() {});
                        });
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
                            if (_deletedialogKey.currentState!.validate()) {
                              Navigator.pop(context);
                              ordersBloc.add(DeleteItem(
                                  state.reservationList.reservation.orders.first
                                      .id
                                      .toString(),
                                  state.reservationList.reservation.orders.first
                                      .itemOrders[index].id
                                      .toString(),
                                  deletereasonController.text));
                            } else {}
                          },
                          notefield: Form(
                            key: _deletedialogKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.w),
                              child: Card(
                                elevation: 1,
                                child: TextFormField(
                                  minLines: 3,
                                  maxLines: null,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
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
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade500,
                                            width: 0.4)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 0.009)),
                                    labelText: 'Enter valid reason to delete',
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
                            color: editList[index]
                                ? Colors.red.shade900
                                : editList
                                        .where((element) => element == true)
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
              ), */
            ],
          )
        ],
      ),
    );
  }

  ordersCard(ReservationDetailsDone state, int index) {
    return Dismissible(
      key: Key('item $index'),
      secondaryBackground: Container(
        color: Colors.transparent,
      ),
      background: Container(
          color: Colors.red.shade900,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15.w),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          )),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          ordersBloc.add(DeleteOrder(
              state.reservationList.reservation.orders[index].id.toString()));
        } else {
          // ordersBloc.add(FetchOrders(widget.id));
        }
      },
      child: GestureDetector(
        onTap: () {
          /*  navigatorKey.currentState
              ?.pushNamed("/orderItems", arguments: state.orders[index])
              .then((value) => ordersBloc.add(FetchOrders(widget.id))); */
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.w),
              color: Colors.grey.shade200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                          color: state.reservationList.reservation.orders[index]
                                  .completed
                              ? Colors.green
                              : Colors.red.shade900,
                          borderRadius: BorderRadius.circular(30.w)),
                      child: Icon(
                        state.reservationList.reservation.orders[index]
                                .completed
                            ? Icons.done
                            : Icons.pending_actions,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 25.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          TextWidget(
                            "", // state.orders[index].guestName.toString(),
                            fontweight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          TextWidget(
                            "", // state.orders[index].guestContact.toString(),
                            fontweight: FontWeight.w400,
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  TextWidget(
                    "# ${state.reservationList.reservation.orders[index].orderNo}",
                    fontweight: FontWeight.bold,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.w),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.blue)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
                    child: TextWidget(
                        "Ordered on : ${DateFormat("yyyy-MM-dd").format(DateTime.parse(state.reservationList.reservation.orders[index].createdAt))}"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  File createFileFromBytes(Uint8List bytes) => File.fromRawPath(bytes);

  detailsWidget() {
    return Column(
      children: [
        BlocBuilder<ReservationsBloc, ReservationsState>(
            buildWhen: (previous, current) {
          return current is ReservationsLoad ||
              current is ReservationNodata ||
              current is ReservationDetailsDone ||
              current is ReservationsError;
        }, builder: (context, state) {
          if (state is ReservationNodata) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100.w),
              child: const TextWidget("No Data"),
            );
          }
          if (state is ReservationsLoad) {
            return const Center(
              child: SizedBox(
                  height: 60, width: 60, child: CircularProgressIndicator()),
            );
          }
          if (state is ReservationDetailsDone) {
            return Column(
              children: [
                paymentContainer(
                    "Total Amount",
                    " ₹ ${state.reservationList.reservation.totalPayment}",
                    Colors.pink),
                paymentContainer(
                    "Amount Paid",
                    "₹ ${state.reservationList.reservation.advancePaid}",
                    Colors.blue),
                dividerWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    button("Mark as No cost", () {
                      DialogWidget().dialogWidget(context, "Are you sure?", () {
                        Navigator.pop(context);
                      }, () {
                        Navigator.pop(context);
                        reservationBloc
                            .add(MarkUpdate(reservId.toString(), "NS"));
                      },
                          notefield: const TextWidget(
                              "Are you sure you want to mark this Reservation as No Cost? "));

                      //akshaya
                      // reservationBloc.add(MarkUpdate(reservId.toString(), "NS"));
                    }, HexColor("#d4ac2c"), textcolor: Colors.black),
                    if (state.reservationList.reservation.status != "OP")
                      SizedBox(
                        width: 15.w,
                      ),
                    if (state.reservationList.reservation.status == "")
                      button("Mark as No show", () {
                        DialogWidget().dialogWidget(
                          context,
                          "Sure to confirm?",
                          () {
                            Navigator.pop(context);
                          },
                          () {
                            print(state.reservationList.reservation.status);
                            Navigator.pop(context);
                            reservationBloc
                                .add(MarkUpdate(reservId.toString(), "noshow"));
                          },
                        );
                      }, HexColor("#d4ac2c"), textcolor: Colors.black),
                  ],
                ),
                dividerWidget(),
              ],
            );
          } else {
            return const TextWidget("Something went wrong");
          }
        }),
        SizedBox(
          height: 20.w,
        ),
        Center(
          child: TextWidget(
            "Bill Summary",
            size: 22.sp,
            fontweight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 20.w,
        ),
        billsummaryWidget(),
        SizedBox(
          height: 20.w,
        ),
        BlocBuilder<ReservationsBloc, ReservationsState>(
          buildWhen: (previous, current) {
            return current is ReservationsLoad ||
                current is ReservationNodata ||
                current is ReservationDetailsDone ||
                current is ReservationsError;
          },
          builder: (context, state) {
            if (state is ReservationNodata) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 100.w),
                child: const TextWidget("No Data"),
              );
            }
            if (state is ReservationsLoad) {
              return const Center(
                child: SizedBox(
                    height: 60, width: 60, child: CircularProgressIndicator()),
              );
            }
            if (state is ReservationDetailsDone) {
              reservId = state.reservationList.reservation.id.toString();

              balanceAmount = state.reservationList.reservation.balanceAmount;
              return userDetailswidget(state, context);
            }
            if (state is ReservationsError) {
              return Text(state.errorMsg);
            }
            return const Text("Something went wrong");
          },
        ),
      ],
    );
  }

  Column userDetailswidget(ReservationDetailsDone state, BuildContext context) {
    return Column(
      children: [
        dividerWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Tables Booked",
                size: 20.sp,
                fontweight: FontWeight.w700,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: HexColor("#d4ac2c")),
                  onPressed: () {
                    navigatorKey.currentState?.pushNamed("/addReservation",
                        arguments: {
                          "id": state.reservationList.reservation.id
                        });
                  },
                  child: const TextWidget(
                    "Add Tables",
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        Column(
          children: state.reservationList.reservation.tablesSelected.isEmpty
              ? [
                  Icon(
                    Icons.no_meeting_room,
                    color: Colors.grey,
                    size: 60.w,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextWidget("No tables found"),
                  )
                ]
              : List.generate(
                  state.reservationList.reservation.bookedTables.length,
                  (index) => Dismissible(
                      key: Key('item $index'),
                      secondaryBackground: Container(
                        color: Colors.transparent,
                      ),
                      background: Container(
                          color: Colors.red.shade900,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15.w),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          )),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.startToEnd) {
                          reservationBloc.add(DeleteroomEvent(
                              widget.id["rId"].toString(),
                              state.reservationList.reservation
                                  .tablesSelected[index]));
                        } else {}
                      },
                      child: GestureDetector(
                          onTap: () {
                            print(
                                "waiterr${state.reservationList.reservation.bookedTables[index].waiterId}");
                            navigatorKey.currentState!
                                .pushNamed("/details", arguments: {
                              "rId": state.reservationList.reservation.id,
                              "tId": state.reservationList.reservation
                                  .bookedTables[index].tableId,
                              "type": "",
                              "identifier":
                                  state.reservationList.reservation.identifier,
                              "waiter": state.reservationList.reservation
                                  .bookedTables[index].waiterId,
                              "fromtable": false
                            }).then((value) {
                              reservationBloc.add(
                                  ReservationDetailsEvent(widget.id["rId"]));
                            });
                          },
                          child: roomListwidget(state, index)))),
        ),
        dividerWidget(),
        guestWidget(state),
        userDataWidget(context, state),
        button("Submit", () {
          addResevationBloc.add(
              UpdateGuest(guestData, state.reservationList.reservation.id));
        }, HexColor("#d4ac2c"), textcolor: Colors.black, size: 20.sp),
        dividerWidget(),
        SizedBox(
          height: 10.w,
        ),
        SizedBox(
          height: 10.w,
        ),
        cakeDetail(state),
      ],
    );
  }

  Padding userDataWidget(BuildContext context, ReservationDetailsDone state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    initialValue: state.reservationList.reservation.user.name,
                    onChanged: (value) {
                      guestData["name"] = value;
                      // addReservRequest.user?.name = value;
                      setState(() {});
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    initialValue: state.reservationList.reservation.user.phone,
                    onChanged: (value) {
                      guestData["phone"] = value;
                      setState(() {});
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Mobile";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      labelText: "Phone No.",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: state.reservationList.reservation.user.email,
              onChanged: (value) {
                guestData["email"] = value;
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                labelText: "Email",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(),
                ),
                //fillColor: Colors.green
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding guestWidget(ReservationDetailsDone state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const TextWidget(
                "Total No of. Guests : ",
                fontweight: FontWeight.bold,
              ),
              TextWidget(
                  state.reservationList.reservation.totalHeads.toString())
            ],
          ),
          IconButton(
              onPressed: () {
                addguestDialog(
                    state.reservationList.reservation.totalHeads.toString());
              },
              icon: const Icon(Icons.edit_note_outlined))
        ],
      ),
    );
  }

  discountWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: TextEditingController.fromValue(TextEditingValue(
              text: billupdateRequest.data.flatDiscount?.toString() ?? "",
              selection: TextSelection.fromPosition(
                TextPosition(
                    offset: (billupdateRequest.data.taxGst.toString()).length),
              ),
            )),
            onChanged: (value) {
              billupdateRequest.data.flatDiscount = value;
              setState(() {});
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  )),
                  child: billupdateRequest.data.paymentType == "fixed"
                      ? const Icon(Icons.currency_rupee)
                      : const Icon(Icons.percent)),
              labelText: "Discount",
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: HexColor("#d4ac2c"),
                ),
              ),
              //fillColor: Colors.green
            ),
          )
        ],
      ),
    );

    /* BlocBuilder<BillpaymentBloc, BillpaymentState>(
      buildWhen: (previous, current) {
        return current is DiscountLoad ||
            current is DiscountError ||
            current is DiscountDone;
      },
      builder: (context, state) {
        print("discount stattt$state");
        if (state is DiscountDone) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: TextEditingController.fromValue(TextEditingValue(
                    text: billupdateRequest.data.flatDiscount?.toString() ?? "",
                    selection: TextSelection.fromPosition(
                      TextPosition(
                          offset: (billupdateRequest.data.taxGst.toString())
                              .length),
                    ),
                  )),
                  onChanged: (value) {
                    billupdateRequest.data.flatDiscount = value;
                    setState(() {});
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        )),
                        child: billupdateRequest.data.paymentType == "fixed"
                            ? const Icon(Icons.currency_rupee)
                            : const Icon(Icons.percent)),
                    labelText: "Discount",
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: HexColor("#d4ac2c"),
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                )
              ],
            ),
          );
        }
        if (state is DiscountLoad || state is BillpaymentInitial) {
          return LinearProgressIndicator(
            minHeight: 4.0,
            color: HexColor("#d4ac2c"),
          );
        }
        return const TextWidget("error");
      },
    ); */
  }

  BlocBuilder<BillpaymentBloc, BillpaymentState> serviceWidget() {
    return BlocBuilder<BillpaymentBloc, BillpaymentState>(
      buildWhen: (previous, current) {
        // print("stattt $previous-$current");
        return current is BillpaymentInitial ||
            current is ServiceLoad ||
            current is ServiceError ||
            current is ServiceDone;
      },
      builder: (context, state) {
        print("service stattt$state");
        if (state is ServiceDone) {
          return Wrap(
            direction: Axis.horizontal,
            children: List.generate(state.charges.length, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio(
                      value: state.charges[index].percentage,
                      groupValue: billupdateRequest.data.serviceCharge,
                      onChanged: (value) {
                        print(value);
                        billupdateRequest.data.serviceCharge = value;
                        setState(() {});
                      }),
                  TextWidget("${state.charges[index].percentage} %")
                ],
              );
            }),
          );
        }
        if (state is ServiceLoad || state is BillpaymentInitial) {
          return LinearProgressIndicator(
            minHeight: 4.0,
            color: HexColor("#d4ac2c"),
          );
        }
        if (state is ServiceError) {
          return TextWidget(state.msg);
        }
        return const TextWidget("Something went wrong");
      },
    );
  }

  Padding cakeDetail(ReservationDetailsDone state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "Cake",
                fontweight: FontWeight.bold,
                size: 22.sp,
              ),
              if (state.reservationList.reservation.diningType == "takeaway" ||
                  state.reservationList.reservation.diningType == "delivery")
                Padding(
                  padding: EdgeInsets.only(top: 10.w),
                  child: const TextWidget("Not Applicable"),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const TextWidget(
                          "Flavour   :  ",
                          fontweight: FontWeight.w500,
                        ),
                        TextWidget(
                          state.reservationList.reservation.cake.name.isEmpty
                              ? "-"
                              : state.reservationList.reservation.cake.name,
                          fontweight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const TextWidget(
                          "Quantity :  ",
                          fontweight: FontWeight.w500,
                        ),
                        TextWidget(
                          state.reservationList.reservation.quantity.isEmpty
                              ? "0kg"
                              : "${state.reservationList.reservation.quantity}kg",
                          fontweight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  AddReservRequest addrequest = AddReservRequest();

  guestDetails() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Guest Details",
                size: 20.sp,
                fontweight: FontWeight.w700,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: HexColor("#d4ac2c")),
                  onPressed: () {
                    addrequest = AddReservRequest();
                    //  addguestDialog();
                  },
                  child: const TextWidget(
                    "Add Guest",
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        /*  BlocBuilder<ReservationsBloc, ReservationsState>(
          buildWhen: (previous, current) {
            return current is ReservationsLoad ||
                current is ReservationNodata ||
                current is ReservationDetailsDone ||
                current is ReservationsError;
          },
          builder: (context, state) {
            if (state is ReservationNodata) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 100.w),
                child: const TextWidget("No Data"),
              );
            }
            if (state is ReservationsLoad) {
              return const Center(
                child: SizedBox(
                    height: 60, width: 60, child: CircularProgressIndicator()),
              );
            }
            if (state is ReservationDetailsDone) {
              return Container();
            }

            return const TextWidget("Something went wrong");
          },
        ), */
      ],
    );
  }

  void addguestDialog(String heads) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setstate) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget("Edit No. Of Guests"),
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
                TextFormField(
                  initialValue: heads,
                  onChanged: (value) {
                    heads = value;
                    setState(() {});
                  },
                  decoration: textfieldDecor("Occupancy"),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              button("Submit", () {
                Navigator.pop(context);
                addResevationBloc.add(UpdateGuestcount(
                  heads,
                  widget.id["rId"],
                ));
              }, HexColor("#d4ac2c"), textcolor: Colors.black)
            ],
          );
        });
      },
    );
  }

  String selectedRoom = "";

  Container roomListwidget(ReservationDetailsDone state, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextWidget(
                "⦿",
                size: 25.sp,
              ),
              SizedBox(
                width: 15.w,
              ),
              Row(
                children: [
                  TextWidget(
                    state.reservationList.reservation.bookedTables[index]
                        .tableName,
                    fontweight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setstate) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  "Select table",
                                  size: 22.sp,
                                  fontweight: FontWeight.w500,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close))
                              ],
                            ),
                            content: Wrap(
                                runSpacing: 5.w,
                                spacing: 5.w,
                                children: List.generate(
                                    tableList.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            selectedRoom =
                                                tableList[index].id.toString();
                                            setstate(() {});
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(15.w),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(30.w),
                                                color: selectedRoom ==
                                                        tableList[index]
                                                            .id
                                                            .toString()
                                                    ? HexColor("#d4ac2c")
                                                    : Colors.white),
                                            child: TextWidget(
                                              tableList[index].name,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ))),
                            actions: [
                              button("Cancel", () {
                                Navigator.pop(context);
                                selectedRoom = "";
                                setstate(() {});
                              }, Colors.red),
                              button("Swap", () {
                                DialogWidget().dialogWidget(
                                  context,
                                  "Sure to confirm?",
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () {
                                    reservationBloc.add(SwapEvent(
                                        reservId.toString(),
                                        state.reservationList.reservation
                                            .bookedTables[index].tableId
                                            .toString(),
                                        selectedRoom));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              }, Colors.green)
                            ],
                          );
                        });
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.swap_horiz,
                      size: 35.sp,
                    ),
                  )),
              SizedBox(
                width: 20.w,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.blue)),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
                child: const TextWidget(
                  "View Order",
                  fontweight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding dividerWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      child: const Divider(
        height: 5,
        thickness: 0.5,
        color: Colors.grey,
      ),
    );
  }

  InputDecoration textfieldDecor(String title) {
    return InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
        labelText: title,
        fillColor: Colors.white,
        focusColor: Colors.grey,
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: Colors.grey),
        )
        //fillColor: Colors.green
        );
  }

  OutlineInputBorder textfieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        color: HexColor("#d4ac2c"),
      ),
    );
  }

  List gender = ["Male", "Female", "Other"];
  /* Row addRadioButton(int btnValue, String title, Function(dynamic)? onChanged,
      {dynamic value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: HexColor("#d4ac2c"),
          value: gender[btnValue],
          groupValue: (value == 0)
              ? "Female"
              : (value == 1)
                  ? "Male"
                  : addrequest.guestgender,
          onChanged: onChanged,
        ),
        Text(title)
      ],
    );
  } */

  String discount = "";
  Container paymentContainer(String title, String value, Color color,
      {bool flatDiscount = false}) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: color, width: 0.6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextWidget(
                  title,
                  fontweight: FontWeight.w500,
                ),
                SizedBox(
                  width: 10.w,
                ),
                if (flatDiscount)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                  "Edit Flat Discount",
                                  fontweight: FontWeight.bold,
                                  size: 22.sp,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.close))
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            content: TextFormField(
                              initialValue: value,
                              onChanged: (value) {
                                discount = value;
                                setState(() {});
                              },
                            ),
                            actions: [
                              button(
                                "Save",
                                () {
                                  Navigator.pop(context);
                                  reservationBloc.add(EditdiscountEvent(
                                      widget.id["rId"].toString(), discount));
                                },
                                Colors.green,
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                        padding: EdgeInsets.all(5.w),
                        decoration: const BoxDecoration(
                            color: Colors.amber, shape: BoxShape.circle),
                        child: Icon(
                          Icons.edit,
                          size: 20.sp,
                        )),
                  )
              ],
            ),
            TextWidget(
              value,
              fontweight: FontWeight.w700,
              size: 20.sp,
            ),
          ],
        ));
  }

  /*  Future<Uint8List> makePdf(ReservationsDetailsModel invoice) async {
    final imageLogo = pdfWidget.MemoryImage(
        (await rootBundle.load('assets/pdfLogo.png')).buffer.asUint8List());
    pdfWidget.TextStyle headingStyle = pdfWidget.TextStyle(
      fontWeight: pdfWidget.FontWeight.bold,
      fontSize: 7,
    );
    pdfWidget.TextStyle subdataStyle = const pdfWidget.TextStyle(
      fontSize: 7,
    );

    final tableRows = <pdfWidget.TableRow>[
      pdfWidget.TableRow(
          decoration: pdfWidget.BoxDecoration(
            color: PdfColor.fromHex("#e5d57d"),
            border: const pdfWidget.Border(
              top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
              bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            ),
          ),
          children: [
            headingWidget(
              'Date',
              style: headingStyle,
            ),
            headingWidget(
              'Description',
              style: headingStyle,
            ),
            headingWidget(
              'Quantity',
              style: headingStyle,
            ),
            headingWidget(
              'Price',
              style: headingStyle,
            ),
            headingWidget(
              'Amount',
              style: headingStyle,
            ),
          ])
    ];
    for (var data in invoice.roomDetails) {
      tableRows.add(const pdfWidget.TableRow(
          decoration: pdfWidget.BoxDecoration(
            border: pdfWidget.Border(
              top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
              bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            ),
          ),
          children: [
             subheadingWidget(
              data.values.first.bookedDate ?? "",
              style: subdataStyle,
            ),
            subheadingWidget(
              data.values.first.name ?? "",
              style: subdataStyle,
            ),
            subheadingWidget(
              data.values.first.occupancy?.adults?.toString() ?? "",
              style: subdataStyle,
            ),
            subheadingWidget(
              data.values.first.price ?? "",
              style: subdataStyle,
            ),
            subheadingWidget(
              data.values.first.modifiedPrice ?? "",
              style: subdataStyle,
            ),
          ]));
    }
    tableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Extra Beds",
            style: subdataStyle,
          ),
          subheadingWidget(
            invoice.totalExtraBeds.toString(),
            style: subdataStyle,
          ),
          subheadingWidget(
            invoice.extraBedCost.toString(),
            style: subdataStyle,
          ),
          subheadingWidget(
            "0.00",
            style: subdataStyle,
          ),
        ]));
    tableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Flat Discount",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            invoice.flatDiscount,
            style: subdataStyle,
          ),
        ]));
    tableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: headingStyle,
          ),
          subheadingWidget(
            "",
            style: headingStyle,
          ),
          subheadingWidget(
            "",
            style: headingStyle,
          ),
          subheadingWidget(
            "Total(Rs)",
            style: headingStyle,
          ),
          subheadingWidget(
            invoice.totalPayment,
            style: headingStyle,
          ),
        ]));
    final ordertableRows = <pdfWidget.TableRow>[
      pdfWidget.TableRow(
          decoration: pdfWidget.BoxDecoration(
            color: PdfColor.fromHex("#e5d57d"),
            border: const pdfWidget.Border(
              top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
              bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            ),
          ),
          children: [
            headingWidget(
              'Date',
              style: headingStyle,
            ),
            headingWidget(
              'Description',
              style: headingStyle,
            ),
            headingWidget(
              'Quantity',
              style: headingStyle,
            ),
            headingWidget(
              'Price',
              style: headingStyle,
            ),
            headingWidget(
              'Amount',
              style: headingStyle,
            ),
          ])
    ];
    for (var data in invoice.orders) {
      for (var items in data.itemOrders) {
        print(items);
        ordertableRows.add(pdfWidget.TableRow(
            decoration: const pdfWidget.BoxDecoration(
              border: pdfWidget.Border(
                top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
                bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
              ),
            ),
            children: [
              subheadingWidget(
                (items.createdAt.toString().contains("T") ?? false)
                    ? DateFormat("yyyy-MM-dd")
                        .format(DateTime.parse(items.createdAt))
                    : items.createdAt ?? "",
                style: subdataStyle,
              ),
              subheadingWidget(
                items.itemName ?? "",
                style: subdataStyle,
              ),
              subheadingWidget(
                items.itemQuantity.toString() ?? "",
                style: subdataStyle,
              ),
              subheadingWidget(
                items.itemPrice ?? "",
                style: subdataStyle,
              ),
              subheadingWidget(
                ((double.tryParse(items.itemPrice) ?? 0) * items.itemQuantity)
                        .toString() ??
                    "",
                style: subdataStyle,
              ),
            ]));
      }
    }
    ordertableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Total(Rs.)",
            style: headingStyle,
          ),
          subheadingWidget(
            invoice.totalOrderAmount.toString() ?? "",
            style: subdataStyle,
          ),
        ]));
    ordertableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Discount",
            style: headingStyle,
          ),
          subheadingWidget(
            invoice.flatDiscount,
            style: subdataStyle.copyWith(color: PdfColor.fromHex("#FF0000")),
          ),
        ]));
    ordertableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Tax",
            style: headingStyle,
          ),
          subheadingWidget(
            "0.00 %",
            style: subdataStyle.copyWith(color: PdfColor.fromHex("#FF0000")),
          ),
        ]));
    ordertableRows.add(pdfWidget.TableRow(
        decoration: const pdfWidget.BoxDecoration(
          border: pdfWidget.Border(
            top: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
            bottom: pdfWidget.BorderSide(width: 1, color: PdfColors.black),
          ),
        ),
        children: [
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "",
            style: subdataStyle,
          ),
          subheadingWidget(
            "Total Amount: (Rs.)",
            style: headingStyle,
          ),
          subheadingWidget(
            ((double.tryParse(invoice.totalPayment) ?? 0) +
                    (double.tryParse(invoice.totalOrderAmount.toString()) ??
                        0) -
                    (double.tryParse(invoice.flatDiscount) ?? 0))
                .toString(),
            style: subdataStyle.copyWith(color: PdfColor.fromHex("#FF0000")),
          ),
        ]));
    final pdf = pdfWidget.Document(pageMode: PdfPageMode.fullscreen);
    pdf.addPage(pdfWidget.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return <pdfWidget.Widget>[
            pdfWidget.Column(
                crossAxisAlignment: pdfWidget.CrossAxisAlignment.start,
                children: [
                  pdfWidget.Row(
                      mainAxisAlignment:
                          pdfWidget.MainAxisAlignment.spaceBetween,
                      children: [
                        pdfWidget.SizedBox(
                          height: 150,
                          width: 150,
                          child: pdfWidget.Image(imageLogo),
                        ),
                        pdfWidget.Column(
                            crossAxisAlignment:
                                pdfWidget.CrossAxisAlignment.start,
                            children: [
                              pdfWidget.Text("P.O, 193B, Pudumund,"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text("Ooty,Tamil Nadu 643007,"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text("9886883115"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text(
                                  "reservations@thesilentretreatfarn.com"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text("www.thesilentretreatfarms.com")
                            ])
                      ]),
                  pdfWidget.SizedBox(height: 30),
                  pdfWidget.Row(children: [
                    pdfWidget.Column(
                        crossAxisAlignment: pdfWidget.CrossAxisAlignment.start,
                        children: [
                          pdfWidget.Text("Invoive No: "),
                          pdfWidget.SizedBox(height: 5),
                          pdfWidget.Text("Date: "),
                        ]),
                    pdfWidget.Column(
                        crossAxisAlignment: pdfWidget.CrossAxisAlignment.start,
                        children: [
                          pdfWidget.Text(invoice.invoice.invoiceNo),
                          pdfWidget.SizedBox(height: 5),
                          pdfWidget.Text((invoice.invoice.createdAt
                                      .toString()
                                      .contains("T") ??
                                  false)
                              ? DateFormat("yyyy-MM-dd").format(
                                  DateTime.parse(invoice.invoice.createdAt))
                              : invoice.invoice.createdAt),
                        ])
                  ]),
                  pdfWidget.SizedBox(height: 50),
                  pdfWidget.Row(
                      mainAxisAlignment: pdfWidget.MainAxisAlignment.start,
                      children: [
                        pdfWidget.Column(
                            crossAxisAlignment:
                                pdfWidget.CrossAxisAlignment.start,
                            children: [
                              pdfWidget.Text("Billed To:",
                                  style:
                                      const pdfWidget.TextStyle(fontSize: 18)),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text("Reddy"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text("9876543210"),
                              pdfWidget.SizedBox(height: 5),
                              pdfWidget.Text(
                                  "nanjundareddyanudi@rediffmail.com"),
                            ])
                      ]),
                  pdfWidget.SizedBox(height: 30),
                  pdfWidget.Text(
                      "PAXl Adults: ${invoice.occupancy.adults}, Children: ${invoice.occupancy.kids}"),
                  pdfWidget.SizedBox(height: 20),
                  pdfWidget.Text("Rooms Booked"),
                  pdfWidget.SizedBox(height: 10),
                  pdfWidget.Table(
                    children: tableRows,
                    defaultVerticalAlignment:
                        pdfWidget.TableCellVerticalAlignment.middle,
                  ),
                  pdfWidget.SizedBox(height: 20),
                  pdfWidget.Text("Items Ordered"),
                  pdfWidget.SizedBox(height: 10),
                  pdfWidget.Table(
                    children: ordertableRows,
                    defaultVerticalAlignment:
                        pdfWidget.TableCellVerticalAlignment.middle,
                  ),
                  pdfWidget.SizedBox(height: 30),
                  pdfWidget.Text("THANK YOU FOR YOUR BUSINESS"),
                ])
          ];
        }));

    return pdf.save();
  } */

  headingWidget(String heading, {pdfWidget.TextStyle? style, PdfColor? color}) {
    return pdfWidget.Container(
      color: color,
      alignment: pdfWidget.Alignment.centerRight,
      padding: const pdfWidget.EdgeInsets.all(2.0),
      child: heading == ""
          ? pdfWidget.Container(height: 8, color: color)
          : pdfWidget.Text(heading, style: style),
    );
  }

  subheadingWidget(String subheading,
      {pdfWidget.TextStyle? style, PdfColor? color}) {
    return pdfWidget.Container(
      color: color,
      alignment: pdfWidget.Alignment.centerRight,
      padding: const pdfWidget.EdgeInsets.all(2.0),
      child: subheading == ""
          ? pdfWidget.Container(height: 8, color: color)
          : pdfWidget.Text(subheading, style: style),
    );
  }

  quantityCounter(ReservationDetailsDone state, int index, bool value) {
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
                state.reservationList.reservation.orders.first.itemOrders[index]
                    .itemQuantity = (state.reservationList.reservation.orders
                        .first.itemOrders[index].itemQuantity) -
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
              state.reservationList.reservation.orders.first.itemOrders[index]
                  .itemQuantity
                  .toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          InkWell(
              onTap: () {
                state.reservationList.reservation.orders.first.itemOrders[index]
                    .itemQuantity = (state.reservationList.reservation.orders
                        .first.itemOrders[index].itemQuantity) +
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

  String selectedSplit = "0";
  List splitDtas = [1, 2, 3, 4, 5];
  userseDropdown(BuildContext context, List itemList,
      {bool loading = false, bool error = false}) {
    return SizedBox(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: Colors.grey)),
          child: CustomDropdownButton(
            width: MediaQuery.of(context).size.width * 0.26,
            underline: const Divider(
              color: Colors.transparent,
            ),
            hint: const TextWidget(
              "",
              color: Colors.grey,
            ),
            value: selectedSplit == "0" ? null : selectedSplit,
            icon: error
                ? Container(
                    padding: EdgeInsets.all(8.w),
                    width: 60.sp,
                    height: 60.sp,
                    child: Icon(
                      Icons.error,
                      size: 25.sp,
                      color: Colors.red.shade900,
                    ))
                : loading
                    ? Container(
                        padding: EdgeInsets.all(14.w),
                        width: 60.sp,
                        height: 60.sp,
                        child: const CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.all(8.w),
                        width: 60.sp,
                        height: 60.sp,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 50.sp,
                          color: HexColor("#135a92"),
                        ),
                      ),
            onChanged: (value) {
              selectedSplit = value.toString();
              setState(() {});
              /* reservationBloc.add(SplitEvent(
                  reservId.toString(), payController.text.toString())); */
            },
            items: itemList.toList().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              );
            }).toList(),
          )),
    );
  }

  List typeList = ["fixed", "percentage"];
  typeDropdown(BuildContext context, List itemList,
      {bool loading = false, bool error = false}) {
    return SizedBox(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 19.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(color: Colors.grey)),
          child: CustomDropdownButton(
            width: MediaQuery.of(context).size.width * 0.26,
            underline: const Divider(
              color: Colors.transparent,
            ),
            hint: const TextWidget(
              "Select Type",
              color: Colors.grey,
            ),
            value: billupdateRequest.data.paymentType != null
                ? itemList
                    .where((element) =>
                        element == billupdateRequest.data.paymentType)
                    .toList()
                    .first
                : null,
            icon: error
                ? Container(
                    padding: EdgeInsets.all(8.w),
                    width: 60.sp,
                    height: 60.sp,
                    child: Icon(
                      Icons.error,
                      size: 25.sp,
                      color: Colors.red.shade900,
                    ))
                : loading
                    ? Container(
                        padding: EdgeInsets.all(14.w),
                        width: 60.sp,
                        height: 60.sp,
                        child: const CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.all(8.w),
                        width: 60.sp,
                        height: 60.sp,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 50.sp,
                          color: HexColor("#135a92"),
                        ),
                      ),
            onChanged: (value) {
              billupdateRequest.data.paymentType = value.toString();
              setState(() {});
            },
            items: itemList.toList().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              );
            }).toList(),
          )),
    );
  }

  InputDecoration calendarDecoration({bool timer = false}) {
    return InputDecoration(
      suffixIcon: Icon(
        timer ? Icons.access_time : Icons.calendar_month,
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
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
