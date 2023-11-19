import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/models/timestats_model.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../bloc/finance/finance_bloc.dart';
import '../../models/add_exp_request.dart';
import '../../models/expense_cat_model.dart';
import '../../models/itemstats_model.dart';
import '../widgets/text_widget.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  FinanceBloc financeBloc = FinanceBloc();
  List<ExpenseCatModel> expenseCat = [];
  AddExpenseRequest addExpenseRequest = AddExpenseRequest(data: Data());
  List<Map<String, dynamic>> categoryDropdown = [];
  String role = "";
  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";
  }

  TextEditingController itemstartDate = TextEditingController();

  TextEditingController itemendDate = TextEditingController();
  TextEditingController timestartDate = TextEditingController();

  TextEditingController timeendDate = TextEditingController();
  Map<String, double> items = {};
  Map<String, double> category = {};

  @override
  void initState() {
    getRole();

    categoryDropdown = [
      {"name": "Orders", "id": 1, "cat": "order"},
      {"name": "Reservation", "id": 0, "cat": "room_reservation"},
    ];
    financeBloc = BlocProvider.of<FinanceBloc>(context)
      ..stream.listen((event) {
        if (event is AddExpenseLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is AddExpenseError) {
          EasyLoading.showError('Failed with Error');
        }
        if (event is AddExpenseDone) {
          EasyLoading.showSuccess('Success!');
          addExpenseRequest =
              AddExpenseRequest(data: Data(identifier: expenseCat.first.name));

          financeBloc.add(FetchIncome());
          financeBloc.add(FetchFinance());
        }

        if (event is ExpenseCatDone) {
          expenseCat = event.category;
          if (expenseCat.isNotEmpty) {
            addExpenseRequest.data?.identifier = expenseCat.first.name;
          }
          setState(() {});
        }
      });

    // financeBloc.add(FetchFinance());
    financeBloc.add(FetchIncome());
    itemstartDate.text = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
    itemendDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timestartDate.text = DateFormat('yyyy-MM-dd')
        .format(DateTime(DateTime.now().year, DateTime.now().month, 1));
    timeendDate.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    financeBloc.add(FetchItemstats(itemstartDate.text, itemendDate.text));
    financeBloc.add(FetchTimestats(timestartDate.text, timeendDate.text));
    // financeBloc.add(FetchExpenseCat());

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.w,
        backgroundColor: HexColor("#d4ac2c"),
        leading: Padding(
          padding: EdgeInsets.all(5.w),
          child: Image.asset("assets/appLogo.png"),
        ),
        title: Row(
          children: [
            TextWidget(
              "Finance",
              style: GoogleFonts.belleza(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 33.w,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            totalIncomeWidget(),
            SizedBox(
              height: 10.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                  "Item Stats",
                  fontweight: FontWeight.bold,
                  size: 21.sp,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    controller: itemstartDate,
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
                          itemstartDate.text =
                              formattedDate; //set output date to TextField value.
                        });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    controller: itemendDate,
                    readOnly: true,
                    autofocus: false,
                    focusNode: null,
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
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          itemendDate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    //if (_formKey.currentState!.validate()) {
                    financeBloc.add(
                        FetchItemstats(itemstartDate.text, itemendDate.text));

                    /*  addReservRequest = AddReservRequest(
                              prefix: "+91",
                              bookingStart: startDate.text,
                              bookingEnd: endDate.text,
                              roomsBooked: []);
                          availableRooms.add(
                              FetchAvailableRooms(startDate.text, endDate.text)); */
                    //  }
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
            BlocBuilder<FinanceBloc, FinanceState>(
              buildWhen: (previous, current) {
                return current is ItemstatsLoad ||
                    current is ItemstatsDone ||
                    current is ItemstatsError;
              },
              builder: (context, state) {
                if (state is ItemstatsDone) {
                  items = {};
                  category = {};
                  for (var element in state.itemStats.items) {
                    items[element.name] = element.count.toDouble();
                  }
                  for (var element in state.itemStats.categories) {
                    category[element.name] = element.count.toDouble();
                  }

                  return Column(
                    children: [
                      if (state.itemStats.items.isNotEmpty)
                        SfCircularChart(series: <CircularSeries>[
                          DoughnutSeries<Items, dynamic>(
                              enableTooltip: true,
                              onPointTap: (pointInteractionDetails) {},
                              explode: false,
                              sortFieldValueMapper: (datum, index) {
                                return datum.count.toString();
                              },
                              dataLabelMapper: (datum, index) {
                                return ("${datum.name}(${datum.count})");
                              },
                              dataLabelSettings: DataLabelSettings(
                                  labelIntersectAction:
                                      LabelIntersectAction.shift,
                                  showCumulativeValues: true,
                                  connectorLineSettings:
                                      const ConnectorLineSettings(
                                          width: 1.5, type: ConnectorType.line),
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  labelPosition:
                                      ChartDataLabelPosition.outside),
                              //legendIconType: LegendIconType.horizontalLine,
                              dataSource: state.itemStats.items,
                              innerRadius: "45",
                              xValueMapper: (Items data, _) => data.name,
                              yValueMapper: (Items data, _) => data.count,
                              // Mode of grouping
                              groupMode: CircularChartGroupMode.point,
                              groupTo: state.itemStats.items.length.toDouble())
                        ]),
                      if (state.itemStats.items.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              "Items Ordered Count",
                              fontweight: FontWeight.w500,
                              size: 16.sp,
                            ),
                          ],
                        )
                      else
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: const TextWidget("No data"),
                        ),
                      if (state.itemStats.categories.isNotEmpty)
                        SfCircularChart(series: <CircularSeries>[
                          DoughnutSeries<Categories, dynamic>(
                              enableTooltip: true,
                              onPointTap: (pointInteractionDetails) {},
                              explode: false,
                              sortFieldValueMapper: (datum, index) {
                                return datum.count.toString();
                              },
                              dataLabelMapper: (datum, index) {
                                return ("${datum.name}(${datum.count})");
                              },
                              dataLabelSettings: DataLabelSettings(
                                  labelIntersectAction:
                                      LabelIntersectAction.shift,
                                  showCumulativeValues: true,
                                  connectorLineSettings:
                                      const ConnectorLineSettings(
                                          width: 1.5, type: ConnectorType.line),
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  labelPosition:
                                      ChartDataLabelPosition.outside),
                              //legendIconType: LegendIconType.horizontalLine,
                              dataSource: state.itemStats.categories,
                              innerRadius: "45",
                              xValueMapper: (Categories data, _) => data.name,
                              yValueMapper: (Categories data, _) => data.count,
                              // Mode of grouping
                              groupMode: CircularChartGroupMode.point,
                              groupTo: state.itemStats.items.length.toDouble())
                        ]),
                      if (state.itemStats.categories.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              "Item Sales By Category",
                              fontweight: FontWeight.w500,
                              size: 16.sp,
                            ),
                          ],
                        ),
                    ],
                  );
                }
                if (state is ItemstatsLoad) {
                  return const CircularProgressIndicator();
                }
                if (state is ItemstatsError) {
                  return const TextWidget("Error");
                }

                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.w),
                    child: const TextWidget("Please select date"));
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(
                    "Time Stats",
                    fontweight: FontWeight.bold,
                    size: 21.sp,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    controller: timestartDate,
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
                          timestartDate.text =
                              formattedDate; //set output date to TextField value.
                        });
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    controller: timeendDate,
                    readOnly: true,
                    autofocus: false,
                    focusNode: null,
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
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        setState(() {
                          timeendDate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    financeBloc.add(
                        FetchTimestats(timestartDate.text, timeendDate.text));
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
            BlocBuilder<FinanceBloc, FinanceState>(
              buildWhen: (previous, current) {
                return current is TimestatsDone ||
                    current is TimestatsLoad ||
                    current is TimestatsError;
              },
              builder: (context, state) {
                if (state is TimestatsDone) {
                  return SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(
                        canShowMarker: true,
                        shouldAlwaysShow: true,
                        header: "",
                        builder:
                            (data, point, series, pointIndex, seriesIndex) {
                          return Container(
                            padding: EdgeInsets.all(10.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                  "Count : ${data.count}",
                                  color: Colors.white,
                                )
                              ],
                            ),
                          );
                        },
                        enable: true,
                        activationMode: ActivationMode.singleTap),
                    primaryYAxis: NumericAxis(
                        labelStyle:
                            TextStyle(fontSize: 12.sp, color: Colors.black)),
                    primaryXAxis: CategoryAxis(
                        borderColor: HexColor("#d4ac2c"),
                        labelStyle:
                            TextStyle(fontSize: 12.sp, color: Colors.black)),
                    series: <ColumnSeries<TimestatsModel, dynamic>>[
                      ColumnSeries<TimestatsModel, dynamic>(
                        color: HexColor("#d4ac2c"),
                        dataSource: state.timestats,
                        xValueMapper: (TimestatsModel sales, _) => sales.day,
                        yValueMapper: (TimestatsModel sales, _) =>
                            double.parse(sales.total).toInt(),
                      ),
                    ],
                  );
                } else if (state is TimestatsLoad) {
                  return const CircularProgressIndicator();
                } else {
                  return const TextWidget("No data");
                }
              },
            )
          ],
        ),
      ),
    );
  }

  List<Color> colorList = [
    Colors.red.shade900,
    Colors.green.shade900,
    Colors.blue.shade900,
    Colors.yellow.shade900,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.teal
  ];

  BlocBuilder<FinanceBloc, FinanceState> totalIncomeWidget() {
    return BlocBuilder<FinanceBloc, FinanceState>(
      buildWhen: (previous, current) {
        return current is IncomeLoad ||
            current is IncomeDone ||
            current is IncomeNodata ||
            current is IncomeError;
      },
      builder: (context, state) {
       
        if (state is IncomeDone) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.w),
                child: TextWidget(
                  "Total Sales",
                  fontweight: FontWeight.w500,
                  size: 22.sp,
                ),
              ),
              totalsaleWidget(
                  state.incomeData.currTotal, state.incomeData.prevTotal),
            ],
          );
        }
        if (state is IncomeLoad || state is FinanceInitial) {
          return const CircularProgressIndicator();
        }

        return totalsaleWidget("0", "0");
      },
    );
  }

  Row totalsaleWidget(String current, String previous) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: HexColor("#d4ac2c").withOpacity(0.4),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15.w)),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.w),
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.w),
          child: Column(
            children: [
              TextWidget(
                "Current Total",
                size: 17.sp,
                fontweight: FontWeight.w500,
              ),
              SizedBox(
                height: 15.w,
              ),
              TextWidget(
                "₹ $current",
                fontweight: FontWeight.bold,
                size: 21.sp,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: HexColor("#d4ac2c").withOpacity(0.4),
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15.w)),
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.w),
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.w),
          child: Column(
            children: [
              TextWidget(
                "Previous Total",
                fontweight: FontWeight.w500,
                size: 17.sp,
              ),
              SizedBox(
                height: 15.w,
              ),
              TextWidget(
                "₹ $previous",
                fontweight: FontWeight.bold,
                size: 21.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration textdecor() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 5),
      fillColor: Colors.white,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: const BorderSide(
          color: Colors.black,
        ),
      ),
      //fillColor: Colors.green
    );
  }

  Container expansionWidget(dynamic data, int index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      child: ExpansionTile(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
        backgroundColor: Colors.grey.shade300,
        collapsedBackgroundColor: HexColor("#d4ac2c").withOpacity(0.3),
        childrenPadding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 20.w),
        tilePadding: EdgeInsets.symmetric(horizontal: 20.w),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        title: financeCard(data, index),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.sp),
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green)),
                padding: EdgeInsets.all(5.w),
                child: TextWidget("Category : ${data.category}"),
              ),
              SizedBox(
                height: 10.w,
              ),
              const TextWidget(
                "Comments :",
                fontweight: FontWeight.w500,
              ),
              SizedBox(
                height: 10.w,
              ),
              TextWidget(data.comments)
            ],
          ),
        ],
      ),
    );
  }

  financeCard(dynamic data, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(data.identifier),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: TextWidget(
            "₹ ${data.price}",
            fontweight: FontWeight.w600,
            size: 20.sp,
          ),
        )
      ],
    );
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
