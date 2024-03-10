import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/table/table_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/drawer_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/applogo_widget.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';
import 'package:intl/intl.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key});

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  TableBloc tableBloc = TableBloc();
  final startTime = const TimeOfDay(hour: 9, minute: 0);
  final endTime = const TimeOfDay(hour: 23, minute: 30);
  final step = const Duration(minutes: 30);
  List<String> times = [];
  String? selectedTime;
  final _scrollController = ScrollController();

  @override
  void initState() {
    tableBloc = BlocProvider.of<TableBloc>(context);
    tableBloc.add(FetchSpaces());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      times = getTimes(startTime, endTime, step)
          .map((tod) => tod.format(context))
          .toList();

      for (var data in times) {
        String format = time12to24Format(data);
        TimeOfDay listTime = fromString(format);

        String formattedTime =
            '${listTime.hour.toString().padLeft(2, '0')}:${listTime.minute.toString().padLeft(2, '0')}';
        String currentTime = time12to24Format(
            '${TimeOfDay.now().hour.toString().padLeft(2, '0')}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}');

        var datas = await getDifference(
          currentTime.toString(),
          formattedTime.toString(),
        );

        if (datas.isBetween(0, 15) ||
            datas.isBetween(-15, 0) ||
            currentTime == formattedTime) {
          selectedTime = data;
          setState(() {});
        }

        if (selectedTime == null) {
          selectedTime ??= "9:00 AM";
          setState(() {});
        }

        if (bottomIndex == 3) {
          // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Future.delayed(const Duration(seconds: 1), () {
            if (_scrollController.positions.isNotEmpty) {
              _scrollController.animateTo(
                  ((100.w) * (times.indexOf(selectedTime ?? "")).toDouble()),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            }
          });
          // });
        }
      }

      /*  if (bottomIndex == 4) {
        tableBloc.add(FetchLeveltable(times.first, 1000));
      } */
    });

    super.initState();
  }

  Future<int> getDifference(String time1, String time2) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    var date = dateFormat.format(DateTime.now());
    DateTime a = DateTime.parse('$date $time1:00');
    DateTime b = DateTime.parse('$date $time2:00');
    return b.difference(a).inMinutes;
  }

  String time12to24Format(String time) {
// var time = "12:01 AM";
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    String meridium = time.split(":").last.split(" ").last.toLowerCase();
    if (meridium == "pm") {
      if (h != 12) {
        h = h + 12;
      }
    }
    if (meridium == "am") {
      if (h == 12) {
        h = 00;
      }
    }

    String newTime =
        "${h == 0 ? "00" : h}:${m == 0 ? "00" : m < 10 ? "0$m" : m}";

    return newTime;
  }

  TimeOfDay fromString(String time) {
    int hh = 0;
    if (time.endsWith('PM')) hh = 12;
    time = time.split(' ')[0];
    return TimeOfDay(
      hour: hh +
          int.parse(time.split(":")[0]) %
              24, // in case of a bad time format entered manually by the user
      minute: int.parse(time.split(":")[1]) % 60,
    );
  }

  int selectedSpace = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                _refresh(selectedSpace);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: const Icon(
                  Icons.replay_outlined,
                  color: Colors.black,
                ),
              ))
        ],
        backgroundColor: HexColor("#d4ac2c"),
        elevation: 0,
        leading: const ApplogoButton(),
        title: TextWidget(
          "Dining",
          style: GoogleFonts.belleza(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 33.w,
          ),
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
          builder: (context, state) {
            if (state is SpaceDone) {
              if (selectedSpace == 0) {
                tableBloc.add(FetchLeveltable(selectedTime ?? "",
                    state.spaces.isNotEmpty ? state.spaces.first.id : 0));
              }
              //
              return DefaultTabController(
                  length: state.spaces.length,
                  initialIndex: 0,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      toolbarHeight: 5,
                      bottom: TabBar(
                          onTap: (value) {
                            selectedSpace = state.spaces[value].id;
                            setState(() {});
                            tableBloc.add(FetchLeveltable(
                                selectedTime ?? "", state.spaces[value].id));
                            Future.delayed(const Duration(seconds: 1), () {
                              if (_scrollController.positions.isNotEmpty) {
                                _scrollController.animateTo(
                                    ((100.w) *
                                        (times.indexOf(selectedTime ?? ""))
                                            .toDouble()),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              }
                            });
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
                              state.spaces.length,
                              (index) => Padding(
                                    padding: EdgeInsets.only(bottom: 8.w),
                                    child: TextWidget(
                                      state.spaces[index].name,
                                      fontweight: FontWeight.bold,
                                    ),
                                  ))),
                    ),
                    body: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(state.spaces.length,
                          (id) => levelTableswidget(state.spaces[id].id)),
                    ),
                  ));
            }
            if (state is SpaceLoad || state is TableInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SpaceError) return TextWidget(state.errorMessage);
            return const TextWidget("");
          },
        ),
      ),
    );
  }

  Column levelTableswidget(int levelId) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 30.w,
        ),
        SizedBox(height: 100.w, child: timeListview(levelId)),
        SizedBox(
          height: 30.w,
        ),
        Expanded(
          child: BlocBuilder<TableBloc, TableState>(
              buildWhen: (previous, current) {
            return current is LeveltableDone ||
                current is TableInitial ||
                current is LeveltableLoad ||
                current is LeveltableError;
          }, builder: (context, state) {
            if (state is LeveltableDone) {
              return Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(state.tables.bookedTables.length, (i) {
                  return Container(
                    width: 100.w,
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                        color: state.tables.bookedTables[i].status != "AL"
                            ? HexColor("#d4ac2c")
                            : Colors.red.shade900,
                        shape: BoxShape.circle),
                    child: TextWidget(state.tables.bookedTables[i].name),
                  );
                }),
              );

              /*  ListView.builder(
                  itemCount: state.tables.bookedTables.length,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                          color: HexColor("#d4ac2c"), shape: BoxShape.circle),
                      child:
                          TextWidget(state.tables.bookedTables[index].name),
                    );
                  },
                ); */
            }
            if (state is LeveltableLoad || state is TableInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: TextWidget(""));
          }),
        )
      ],
    );
  }

  timeListview(int id) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) => SizedBox(
              height: 100.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index != 0)
                    SizedBox(
                        /*  padding: EdgeInsets.symmetric(horizontal: 2.w), */
                        width: 50.w,
                        child: Divider(
                          color: Colors.grey.shade800,
                        )),
                  GestureDetector(
                    onTap: () {
                      selectedTime = times[index];
                      setState(() {});
                      tableBloc.add(FetchLeveltable(times[index], id));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.circle,
                              color: HexColor("#d4ac2c"),
                            ),
                            if (selectedTime == times[index])
                              Icon(
                                Icons.check,
                                size: 20.w,
                              )
                          ],
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        TextWidget(
                          times[index],
                          color: Colors.black,
                          size: 17.sp,
                          fontweight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Future<void> _refresh(int id) async {
    // Simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    tableBloc.add(FetchLeveltable(selectedTime ?? "", id));
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
}

extension Range on num {
  bool isBetween(num from, num to) {
    return from < this && this < to;
  }
}
