import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/category/category_bloc.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  CategoryBloc categoryBloc = CategoryBloc();

  @override
  void initState() {
    categoryBloc = BlocProvider.of(context);
    categoryBloc.add(FetchCategory());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: HexColor("#d4ac2c"),
          onPressed: () {},
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
        appBar: AppBar(
          backgroundColor: HexColor("#d4ac2c"),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(5.w),
            child: Image.asset("assets/appLogo.png"),
          ),
          title: TextWidget(
            "Configuration",
            style: GoogleFonts.belleza(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 33.w,
            ),
            /* color: Colors.black,
            
             */
          ),
        ),
        body: DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 15,
                bottom: TabBar(
                  onTap: (value) {
                    if (value == 0) {
                      categoryBloc.add(FetchCategory());
                    }
                    if (value == 1) {
                      categoryBloc.add(FetchSubCategory(0, all: true));
                    }
                    // tableIndex = value;
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
                  tabs: const [
                    Tab(text: "Category"),
                    Tab(text: "Sub-Category"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryDone) {
                        return state.category.isNotEmpty
                            ? ListView.builder(
                                itemCount: state.category.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 15.w),
                                      child: TextWidget(
                                        state.category[index].name,
                                        fontweight: FontWeight.bold,
                                      ));
                                },
                              )
                            : const Center(
                                child: TextWidget(
                                  "No data",
                                  color: Colors.black,
                                ),
                              );
                      }
                      if (state is CategoryLoad) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Container();
                    },
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is SubCategoryDone) {
                        return state.subcategory.isNotEmpty
                            ? ListView.builder(
                                itemCount: state.subcategory.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.w),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 15.w),
                                      child: TextWidget(
                                        state.subcategory[index].name ?? "-",
                                        fontweight: FontWeight.bold,
                                      ));
                                },
                              )
                            : const Center(
                                child: TextWidget(
                                  "No data",
                                  color: Colors.black,
                                ),
                              );
                      }
                      if (state is SubCategoryLoad) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Container();
                    },
                  ),
                ],
              ),
            )));
  }
}
