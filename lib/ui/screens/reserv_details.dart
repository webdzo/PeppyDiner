import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/bloc/billpayment_bloc.dart';
import 'package:hotelpro_mobile/models/cakes_model.dart';
import 'package:hotelpro_mobile/models/occasion_model.dart';
import 'package:hotelpro_mobile/models/packages_model.dart';
import 'package:hotelpro_mobile/models/paymentmode_model.dart';
import 'package:hotelpro_mobile/models/user_model.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';

import '../../bloc/addReservation/add_reservation_bloc.dart';
import '../../bloc/addReservation/add_reservation_event.dart';
import '../../bloc/addReservation/add_reservation_state.dart';
import '../../models/addReserv_request.dart';
import '../../route_generator.dart';
import '../widgets/dropdown.dart';
import '../widgets/text_widget.dart';

class ReservationDetails extends StatefulWidget {
  final AddReservRequest addReservRequest;
  const ReservationDetails({super.key, required this.addReservRequest});

  @override
  State<ReservationDetails> createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  TextEditingController adultController = TextEditingController();
  TextEditingController kidsController = TextEditingController();
  AddReservRequest addReservRequest = AddReservRequest();
  AddResevationBloc addResevationBloc = AddResevationBloc();
  int totalPrice = 0;
  bool cake = false;
  List<CakesModel> cakeList = [];
  double cakePrice = 0;
  List<PaymentmodeModel> paymodes = [];
  BillpaymentBloc billpaymentBloc = BillpaymentBloc();
  String payMode = "";
  @override
  void initState() {
    //totalPrice = 50000;
    adultFocus.addListener(_onadultFocusChange);
    kidsFocus.addListener(_onkidsFocusChange);
    billpaymentBloc = BlocProvider.of<BillpaymentBloc>(context)
      ..stream.listen((event) {
        if (event is PaymodeDone) {
          print("akshaya");
          print(event.modes);
          setState(() {
            paymodes = event.modes;
          });
        }
      });
    addResevationBloc = BlocProvider.of<AddResevationBloc>(context)
      ..stream.listen((event) {
        if (event is CakesDone) {
          cakeList = event.cakes;
          setState(() {});
        }
        if (event is AddReservationLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AddReservationDone) {
          EasyLoading.showSuccess('Success!')
              .then((value) => Future.delayed(const Duration(seconds: 2), () {
                    navigatorKey.currentState?.pushNamed("/home");
                  }));
        } else if (event is AddReservationError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    addResevationBloc.add(GetcakesEvent());
    addResevationBloc.add(GetusersEvent());
    addResevationBloc.add(GetoccasionsEvent());
    addResevationBloc.add(GetpackagesEvent());
    addReservRequest = widget.addReservRequest;
    addReservRequest.user = User();
    billpaymentBloc.add(FetchPayModes());
    // addReservRequest.commissionagent ??= "N/A";
    //  adultController.text = (addReservRequest.adults)?.toString() ?? "";
    //  kidsController.text = (addReservRequest.kids)?.toString() ?? "";
    super.initState();
  }

  _onadultFocusChange() {
    debugPrint("adult Focus: ${adultFocus.hasFocus.toString()}");
    setState(() {});
    return adultFocus.hasFocus;
  }

  _onkidsFocusChange() {
    debugPrint("kids Focus: ${kidsFocus.hasFocus.toString()}");
    setState(() {});
    return kidsFocus.hasFocus;
  }

  FocusNode adultFocus = FocusNode();
  FocusNode kidsFocus = FocusNode();
  List gender = ["Male", "Female", "Other"];
  final _formKey = GlobalKey<FormState>();

  String? select;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.w),
          color: HexColor("#d4ac2c"),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const TextWidget(
                        "Total Payment : ",
                        color: Colors.black,
                      ),
                      TextWidget(
                        "₹ ${(addReservRequest.totalPayment ?? 0)}",
                        fontweight: FontWeight.w600,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TextWidget(
                        "Balance : ",
                        color: Colors.black,
                      ),
                      TextWidget(
                        "₹ ${(addReservRequest.totalPayment ?? 0) - (addReservRequest.flatDiscount ?? 0) - (addReservRequest.advancePaid ?? 0) - (addReservRequest.commission ?? 0)}",
                        fontweight: FontWeight.w600,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.w)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addReservRequest.paymentmode = payMode;
                    addReservRequest.balanceAmount =
                        ((addReservRequest.totalPayment ?? 0) -
                            (addReservRequest.flatDiscount ?? 0) -
                            (addReservRequest.advancePaid ?? 0) -
                            (addReservRequest.commission ?? 0));
                    addResevationBloc.add(Addreservation(addReservRequest));
                  }
                },
                child: const TextWidget(
                  "SUBMIT",
                  color: Colors.black,
                  fontweight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          title: TextWidget(
            "Add Details",
            color: Colors.black,
            size: 20.sp,
            fontweight: FontWeight.bold,
          ),
          backgroundColor: HexColor("#d4ac2c"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.w, horizontal: 10.w),
                padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 10.w),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15.w)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue:
                                (addReservRequest.advancePaid ?? "").toString(),
                            onChanged: (value) {
                              addReservRequest.advancePaid =
                                  int.tryParse(value) ?? 0;
                              totalCalc();

                              /*  addReservRequest.balanceAmount =
                                  ((addReservRequest.totalPayment ?? 0) -
                                      (addReservRequest.flatDiscount ?? 0) -
                                      (addReservRequest.advancePaid ?? 0) -
                                      (addReservRequest.commission ?? 0)); */

                              setState(() {});
                            },
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 17.sp),
                              labelText: "Advance Paid",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 0.5),
                              ),
                              //fillColor: Colors.green
                            ),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue: (addReservRequest.flatDiscount ?? "")
                                .toString(),
                            onChanged: (value) {
                              addReservRequest.flatDiscount =
                                  int.tryParse(value) ?? 0;
                              totalCalc();
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              labelText: "Flat Discount",
                              labelStyle: TextStyle(
                                  color: Colors.black, fontSize: 17.sp),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 5),
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 0.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 0.5),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          paymodeDropdown(context, paymodes),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              initialValue: (addReservRequest.commission ?? "")
                                  .toString(),
                              onChanged: (value) {
                                addReservRequest.commission =
                                    int.tryParse(value) ?? 0;
                                totalCalc();
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.black, fontSize: 17.sp),
                                labelText: "Commission",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              /*  Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        const Text("Adult"),
                        quantityCounter(
                          adultController,
                          adultFocus,
                          _onadultFocusChange(),
                          true,
                          (String value) {
                            addReservRequest.adults =
                                (value) == "0" ? 1 : int.tryParse(value);
                            if (adultController.text == "0") {
                              adultController.text =
                                  addReservRequest.adults?.toString() ?? "";
                            }
                            setState(() {});
                          },
                        ),
                        TextWidget(
                          ((showerror) && (addReservRequest.adults == null))
                              ? "Cant be empty"
                              : "",
                          color: Colors.red,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Kids"),
                        quantityCounter(kidsController, kidsFocus,
                            _onkidsFocusChange(), false, (String value) {
                          addReservRequest.kids = int.parse(value);
                          /*  if (kidsController.text == "") {
                            kidsController.text =
                                addReservRequest.kids.toString();
                          } */
                          setState(() {});
                        }),
                        TextWidget(
                          ((showerror) && (kidsController.text.isEmpty))
                              ? "Cant be empty"
                              : "",
                          color: Colors.red,
                        )
                      ],
                    )
                  ],
                ),
              ), */
              agentWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        onChanged: (value) {
                          addReservRequest.user?.name = value;
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
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
                        onChanged: (value) {
                          addReservRequest.totalHeads = value;
                          setState(() {});
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          labelText: "No. of guests",
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
                  onChanged: (value) {
                    addReservRequest.user?.email = value;
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          addReservRequest.user?.phone = value;
                          setState(() {});
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          labelText: "Mobile Number",
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
                  maxLines: 4,
                  onChanged: (value) {
                    addReservRequest.user?.address = value;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
                    labelText: "Address",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextFormField(
                  maxLines: 3,
                  onChanged: (value) {
                    addReservRequest.notes = value;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.w, horizontal: 10.w),
                    labelText: "Special Requests",
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              SizedBox(
                height: 5.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextFormField(
                      onChanged: (value) {
                        addReservRequest.event = value;
                        setState(() {});
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        /*  if (value == null || value.isEmpty) {
                          return "Cannot be empty";
                        } */
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 5),
                        labelText: "Event Name",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                  ),
                  occasionWidget()
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    packagesWidget(),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: HexColor("#d4ac2c"),
                            value: cake,
                            onChanged: (v) {
                              cake = v ?? false;
                              if (!cake) {
                                addReservRequest.quantity = "";
                                cakePrice = 0;
                              }
                              totalCalc();

                              setState(() {});
                            }),
                        const TextWidget("Cake"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (cake)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /* Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: CustomDropdownButton(
                        hint: TextWidget(
                          "Flavour",
                          color: Colors.black54,
                          size: 20.sp,
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        underline: Container(),
                        value: (cakeList.isNotEmpty)
                            ? cakeList
                                .where((element) =>
                                    element.id == addReservRequest.cake)
                                .toList()
                                .first
                            : null,
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
                          addReservRequest.cake = value.id;

                          cakePrice = (double.tryParse(value.price) ?? 0.0);
                          totalCalc();

                          print(cakePrice);

                          setState(() {});
                        },
                        items: cakeList.toList().map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ), */
                    BlocBuilder<AddResevationBloc, AddReservationState>(
                      buildWhen: (previous, current) {
                        return current is CakesDone ||
                            current is CakesError ||
                            current is CakesLoad;
                      },
                      builder: (context, state) {
                        print(state);
                        return cakeFlavour(
                            context, state is CakesDone ? state.cakes : [],
                            loading: state is CakesLoad,
                            error: state is CakesError);
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextFormField(
                        onChanged: (value) {
                          addReservRequest.quantity = value;
                          totalCalc();

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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          labelText: "Qty",
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
              const SizedBox(
                height: 10,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  BlocBuilder<AddResevationBloc, AddReservationState> occasionWidget() {
    return BlocBuilder<AddResevationBloc, AddReservationState>(
      buildWhen: (previous, current) {
        return current is OccasionDone ||
            current is OccasionError ||
            current is OccasionLoad;
      },
      builder: (context, state) {
        return occasionDropdown(
            context, state is OccasionDone ? state.occasions : [],
            loading: state is OccasionLoad, error: state is OccasionError);
      },
    );
  }

  BlocBuilder<AddResevationBloc, AddReservationState> packagesWidget() {
    return BlocBuilder<AddResevationBloc, AddReservationState>(
      buildWhen: (previous, current) {
        return current is PackagesDone ||
            current is PackagesError ||
            current is PackagesLoad;
      },
      builder: (context, state) {
        return packageDropdown(
            context, state is PackagesDone ? state.packages : [],
            loading: state is PackagesLoad, error: state is PackagesError);
      },
    );
  }

  BlocBuilder<AddResevationBloc, AddReservationState> agentWidget() {
    return BlocBuilder<AddResevationBloc, AddReservationState>(
      buildWhen: (previous, current) {
        return current is UsersDone ||
            current is UsersError ||
            current is UsersLoad;
      },
      builder: (context, state) {
        return userseDropdown(context, state is UsersDone ? state.users : [],
            loading: state is UsersLoad, error: state is UsersError);
      },
    );
  }

  totalCalc() {
    addReservRequest.totalPayment =
        ((cakePrice * (int.tryParse(addReservRequest.quantity ?? "") ?? 0))
            .toInt());
    print(addReservRequest.totalPayment);

    addReservRequest.balanceAmount =
        ((cakePrice * (int.tryParse(addReservRequest.quantity ?? "") ?? 0))
                .toInt()) -
            ((addReservRequest.advancePaid ?? 0) +
                (addReservRequest.commission ?? 0) +
                (addReservRequest.flatDiscount ?? 0));
  }

  bool showerror = false;

  Container cakeFlavour(BuildContext context, List<CakesModel> itemList,
      {bool loading = false, bool error = false}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: Colors.grey)),
        child: CustomDropdownButton(
          underline: const Divider(
            color: Colors.transparent,
          ),
          hint: const TextWidget(
            "Select Flavour",
            color: Colors.grey,
          ),
          value: (addReservRequest.cake != null && itemList.isNotEmpty)
              ? itemList
                  .where((element) => element.id == addReservRequest.cake)
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
            addReservRequest.cake = value.id;

            cakePrice = (double.tryParse(value.price) ?? 0.0);
            totalCalc();

            print(cakePrice);

            setState(() {});
          },
          items: itemList.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList(),
        ));
  }

  packageDropdown(BuildContext context, List<PackagesModel> itemList,
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
              "Select package",
              color: Colors.grey,
            ),
            value: (addReservRequest.package != null && itemList.isNotEmpty)
                ? itemList
                    .where((element) => element.id == addReservRequest.package)
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
              addReservRequest.package = value.id;
              setState(() {});
            },
            items: itemList.toList().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              );
            }).toList(),
          )),
    );
  }

  userseDropdown(BuildContext context, List<UsersModel> itemList,
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
              "Select agent",
              color: Colors.grey,
            ),
            value: (addReservRequest.agentId != null && itemList.isNotEmpty)
                ? itemList
                    .where((element) => element.id == addReservRequest.agentId)
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
              addReservRequest.agentId = value.id;
              setState(() {});
            },
            items: itemList.toList().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.username,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              );
            }).toList(),
          )),
    );
  }

  occasionDropdown(BuildContext context, List<OccasionsModel> itemList,
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
              "Select occasion",
              color: Colors.grey,
            ),
            value: (addReservRequest.occasion != null && itemList.isNotEmpty)
                ? itemList
                    .where((element) => element.id == addReservRequest.occasion)
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
              addReservRequest.occasion = value.id;
              setState(() {});
            },
            items: itemList.toList().map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              );
            }).toList(),
          )),
    );
  }

  Container paymodeDropdown(
      BuildContext context, List<PaymentmodeModel> items) {
    print("-------------------");
    print(items);
    return Container(
      alignment: Alignment.center,
      height: 70.w,
      // width: MediaQuery.of(context).size.width * 0.45,
      margin: EdgeInsets.symmetric(horizontal: 5.w),

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
          width: MediaQuery.of(context).size.width * 0.3,
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

  //Use the above widget where you want the radio button
}
