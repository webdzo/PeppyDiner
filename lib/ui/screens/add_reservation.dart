import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../bloc/addReservation/add_reservation_bloc.dart';
import '../../bloc/addReservation/add_reservation_event.dart';
import '../../bloc/addReservation/add_reservation_state.dart';
import '../../bloc/availableRooms/availableRooms_bloc.dart';
import '../../bloc/availableRooms/availableRooms_event.dart';
import '../../bloc/availableRooms/availableRooms_state.dart';
import '../../models/addReserv_request.dart';
import '../../models/availableTables_model.dart';
import '../../route_generator.dart';
import '../widgets/search_bar.dart';
import '../widgets/text_widget.dart';

class AddReservation extends StatefulWidget {
  final int? id;
  const AddReservation({super.key, this.id});

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  final _formKey = GlobalKey<FormState>();
  AddReservRequest addReservRequest = AddReservRequest();
  TextEditingController startDate = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController endDate = TextEditingController();
  FocusNode startfocusNode = FocusNode();
  FocusNode endfocusNode = FocusNode();
  AvailableRoomsBloc availableRooms = AvailableRoomsBloc();
  AddResevationBloc addResevationBloc = AddResevationBloc();
  int extraRooms = 0;
  @override
  void initState() {
    addReservRequest = AddReservRequest(selectedTables: [], user: User());
    //addReservRequest.totalPayment = 50000;

    availableRooms = BlocProvider.of<AvailableRoomsBloc>(context);
    addResevationBloc = BlocProvider.of<AddResevationBloc>(context)
      ..stream.listen((event) {
        if (event is AddReservationDone) {
          navigatorKey.currentState?.pushReplacementNamed("/viewReservation",
              arguments: {"rId": widget.id});
        } else if (event is AddReservationError) {}
      });
    startDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    endDate.text = TimeOfDay.now().to24hours();
    addReservRequest.time = endDate.text;
    addReservRequest.date = startDate.text;

    availableRooms.add(FetchAvailableRooms(startDate.text, endDate.text));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomSheet: BlocBuilder<AvailableRoomsBloc, AvailableRoomsState>(
        builder: (context, state) {
          return (state is AvailableRoomsDone &&
                  (addReservRequest.selectedTables?.isNotEmpty ?? false))
              ? Container(
                  decoration: BoxDecoration(
                      color: HexColor("#d4ac2c"),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
                  //  height: MediaQuery.of(context).size.height * 0.2,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //  if (widget.id != 0 && widget.id != null)
                      /* Row(
                        children: [
                          const TextWidget("Total Room Price : "),
                          TextWidget(
                            "₹  ${addReservRequest.totalPayment}",
                            fontweight: FontWeight.w600,
                            size: 20.sp,
                          ),
                        ],
                      ), */
                      (widget.id != 0 && widget.id != null)
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    /*   addReservRequest.totalPayment =
                                        double.tryParse(addReservRequest
                                                    .roomsBooked
                                                    ?.toList()
                                                    .fold("0", (previousValue,
                                                        element) {
                                                  return (double.parse(
                                                              previousValue) +
                                                          (double.parse(
                                                              element.price ??
                                                                  "0.0")))
                                                      .toString();
                                                }).toString() ??
                                                "0.0")
                                            ?.toInt(); */
                                    addResevationBloc.add(Updatereservation(
                                        addReservRequest, widget.id ?? 0));
                                  },
                                  child: TextWidget(
                                    "Save",
                                    color: Colors.black,
                                    size: 21.sp,
                                    fontweight: FontWeight.w600,
                                  )),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    addReservRequest.totalPayment = 0;
                                    addReservRequest.balanceAmount ??=
                                        addReservRequest.totalPayment;

                                    navigatorKey.currentState
                                        ?.pushNamed("/reservDetails",
                                            arguments: addReservRequest)
                                        .then((value) {
                                      addReservRequest.totalPayment =
                                          addReservRequest.totalPayment;

                                      addReservRequest.balanceAmount =
                                          addReservRequest.balanceAmount;
                                    });
                                  },
                                  child: const TextWidget(
                                    "PROCEED",
                                    color: Colors.black,
                                    fontweight: FontWeight.w600,
                                  )),
                            ),
                    ],
                  ),
                )
              : Container(
                  height: 10,
                );
        },
      ),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100.w,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              )
            : const SizedBox(
                height: 1,
                width: 1,
              ),
        leadingWidth: Navigator.canPop(context) ? 80.w : 1,
        backgroundColor: HexColor("#d4ac2c"),
        title: Row(
          children: [
            /*  Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Image.asset(
                  "assets/insideIcon.png",
                height: 80.w,
                width: 80.w,
              ),
            ), */
            TextWidget(
              "Add Reservation",
              color: Colors.black,
              fontweight: FontWeight.bold,
              size: 23.sp,
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: HexColor("#d4ac2c")),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            addReservRequest.date = startDate.text;
                          });

                          startfocusNode.unfocus();
                        } else {}
                      },
                    ),
                  ),
                  Icon(
                    Icons.swap_horiz,
                    color: Colors.grey.shade800,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      decoration: calendarDecoration(),
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
                            addReservRequest.time = endDate.text;
                          });
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        addReservRequest = AddReservRequest(
                            selectedTables: [],
                            date: startDate.text,
                            time: endDate.text);
                        availableRooms.add(
                            FetchAvailableRooms(startDate.text, endDate.text));
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(25)),
                      margin: const EdgeInsets.all(3.0),
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.check,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              child: searchBox(searchController, "Search", "Search here", () {
                setState(() {});
              }),
            ),
            BlocBuilder<AvailableRoomsBloc, AvailableRoomsState>(
              builder: (context, state) {
                if (state is AvailableRoomsLoad) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.w),
                    child: const CircularProgressIndicator(),
                  );
                }
                if (state is AvailableRoomsDone) {
                  List<TablesList> searchData = searchController.text.isEmpty
                      ? state.reservationList.tablesList
                      : state.reservationList.tablesList
                          .where((element) => (element.name
                              .toLowerCase()
                              .toString()
                              .startsWith(searchController.text.toLowerCase())))
                          .toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: searchData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(right: 20.w, left: 5.w),
                                    height: 35.w,
                                    width: 35.w,
                                    child: Checkbox(
                                        activeColor: HexColor("#d4ac2c"),
                                        value:
                                            (addReservRequest.selectedTables ??
                                                    [])
                                                .contains(searchData[index]),
                                        onChanged: (bool? value) {
                                          if ((addReservRequest
                                                      .selectedTables ??
                                                  [])
                                              .contains(searchData[index])) {
                                            addReservRequest.selectedTables!
                                                .remove(searchData[index]);
                                          } else {
                                            addReservRequest.selectedTables!
                                                .add(searchData[index]);
                                          }

                                          /*      */
                                          setState(() {});
                                        }),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        searchData[index].name.toString(),
                                        fontweight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: HexColor("#d4ac2c").withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(3),
                                    border:
                                        Border.all(color: HexColor("#d4ac2c"))),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 3.w),
                                child: TextWidget(
                                  "Floor ${searchData[index].floor}",
                                  fontweight: FontWeight.w500,
                                  size: 17.sp,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.w),
                    child: const Text("No Tables Available"));
              },
            )
          ],
        ),
      ),
    );
  }

  double totalCacl(AvailableRoomsDone state) {
    return 0; /* ((addReservRequest.roomsBooked?.toList().fold(0,
                (previousValue, element) {
              return (double.parse(previousValue.toString()) +
                      (double.parse(element.price ?? "0.0")))
                  .toInt();
            })) ??
            0) +
        ((double.tryParse(state.reservationList.extraBedCost) ?? 0) *
            (double.tryParse(addReservRequest.roomsBooked?.toList().fold("0",
                            (previousValue, element) {
                          return (double.parse(previousValue) +
                                  (double.parse(
                                      (element.extraBeds ?? 0).toString())))
                              .toString();
                        }).toString() ??
                        "0.0")
                    ?.toInt() ??
                0)); */
  }

  InputDecoration calendarDecoration() {
    return InputDecoration(
      suffixIcon: Icon(
        Icons.calendar_month,
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

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
