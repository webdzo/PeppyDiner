import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/category/category_bloc.dart';
import 'package:hotelpro_mobile/bloc/items/items_bloc.dart';
import 'package:hotelpro_mobile/models/category_model.dart';
import 'package:hotelpro_mobile/models/editItemconfig_request.dart';
import 'package:hotelpro_mobile/models/itemconfig_model.dart';
import 'package:hotelpro_mobile/models/main_category_model.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/widgets/button.dart';
import 'package:hotelpro_mobile/ui/widgets/dropdown.dart';
import 'package:hotelpro_mobile/ui/widgets/text_widget.dart';

class EditItemconfig extends StatefulWidget {
  final ItemConfigModel? items;
  const EditItemconfig({super.key, this.items});

  @override
  State<EditItemconfig> createState() => _EditItemconfigState();
}

class _EditItemconfigState extends State<EditItemconfig> {
  CategoryBloc categoryBloc = CategoryBloc();
  ItemsBloc itemsBloc = ItemsBloc();
  EditItemconfigRequest editItemconfigRequest = EditItemconfigRequest();
  @override
  void initState() {
    if (widget.items == null) {
      editItemconfigRequest.enabled = 1;
      editItemconfigRequest.type = "nonveg";
    }
    itemsBloc = BlocProvider.of(context)
      ..stream.listen((event) {
        if (event is ItemsLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is ItemsError) {
          EasyLoading.showError(event.errorMsg);
        }
        if (event is EditItemsconfigDone) {
          EasyLoading.showSuccess('Success!');
          Navigator.pop(context);
        }
      });
    categoryBloc = BlocProvider.of(context);
    categoryBloc.add(FetchCategory());

    if (widget.items != null) {
      editItemconfigRequest = EditItemconfigRequest(
          subcategory: widget.items?.subcategoryId.toString(),
          description: widget.items?.description,
          enabled: widget.items?.enabled,
          itemname: widget.items?.name,
          price: double.tryParse(widget.items?.price ?? "")?.toInt(),
          type: widget.items?.type,
          expectedTime: widget.items?.expectedTime);
    }
    super.initState();
  }

  int? catId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            button("Submit", () {
              print(editItemconfigRequest.toJson());
              itemsBloc.add(EditItemconfigEvent(
                  editItemconfigRequest, widget.items?.id ?? 0));
            }, HexColor("#d4ac2c"), textcolor: Colors.black, size: 20.sp),
            SizedBox(
              width: 10.w,
            ),
            button("Cancel", () {
              Navigator.pop(context);
            }, Colors.grey, textcolor: Colors.black, size: 20.sp),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: HexColor("#d4ac2c"),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        /*   leading: Padding(
          padding: EdgeInsets.all(5.w),
          child: Image.asset("assets/appLogo.png"),
        ), */
        title: TextWidget(
          widget.items == null ? "Add Item" : "Edit Item",
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
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.w,
            ),
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.45,
              child: TextFormField(
                initialValue: editItemconfigRequest.itemname ?? "",
                onChanged: (value) {
                  editItemconfigRequest.itemname = value;
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  labelText: "Item Name",
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: HexColor("#d4ac2c")),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: HexColor("#d4ac2c")),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: HexColor("#d4ac2c")),
                  ),
                  //fillColor: Colors.green
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            SizedBox(
              child: TextFormField(
                initialValue: editItemconfigRequest.description ?? "",
                onChanged: (value) {
                  editItemconfigRequest.description = value;
                  setState(() {});
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  labelText: "Item Description",
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.grey),
                  floatingLabelStyle: TextStyle(color: HexColor("#d4ac2c")),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: HexColor("#d4ac2c")),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: HexColor("#d4ac2c")),
                  ),
                  //fillColor: Colors.green
                ),
              ),
            ),
            SizedBox(
              height: 20.w,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: TextFormField(
                    initialValue: editItemconfigRequest.price?.toString() ?? "",
                    onChanged: (value) {
                      editItemconfigRequest.price = int.tryParse(value) ?? 0;
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
                      labelText: "Price",
                      fillColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelStyle: TextStyle(color: HexColor("#d4ac2c")),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: HexColor("#d4ac2c")),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: HexColor("#d4ac2c")),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.w,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 0.w,
                    ),
                    const TextWidget("Enabled"),
                    Switch(
                        activeColor: HexColor("#d4ac2c"),
                        value: (editItemconfigRequest.enabled ?? false) == 0
                            ? false
                            : true,
                        onChanged: (va) {
                          if (va) {
                            editItemconfigRequest.enabled = 1;
                          } else {
                            editItemconfigRequest.enabled = 0;
                          }
                          setState(() {});
                        }),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextWidget("Choose a Category"),
                SizedBox(
                  height: 20.w,
                ),
                yesNowidget(),
                SizedBox(
                  height: 25.w,
                ),
                BlocConsumer<CategoryBloc, CategoryState>(
                  listener: (context, state) {
                    if (state is CategoryDone) {
                      if (widget.items != null) {
                        catId = state.category
                            .where((element) =>
                                element.name == widget.items?.categoryName)
                            .toList()
                            .first
                            .id;
                        editItemconfigRequest.category = state.category
                            .where((element) =>
                                element.name == widget.items?.categoryName)
                            .toList()
                            .first
                            .id
                            .toString();
                      }
                      if (editItemconfigRequest.subcategory != null) {
                        categoryBloc.add(FetchSubCategory(catId ?? 0));
                      }
                    }
                  },
                  listenWhen: (previous, current) {
                    return current is CategoryLoad ||
                        current is CategoryDone ||
                        current is CategoryError;
                  },
                  buildWhen: (previous, current) {
                    return current is CategoryLoad ||
                        current is CategoryDone ||
                        current is CategoryError;
                  },
                  builder: (context, state) {
                    return categoryDropdown(
                        context, state is CategoryDone ? state.category : [],
                        loading: state is CategoryLoad);
                  },
                ),
                SizedBox(
                  height: 25.w,
                ),
                BlocBuilder<CategoryBloc, CategoryState>(
                  buildWhen: (previous, current) {
                    return current is SubCategoryLoad ||
                        current is SubCategoryDone ||
                        current is SubCategoryError;
                  },
                  builder: (context, state) {
                    return subcategoryDropdown(context,
                        state is SubCategoryDone ? state.subcategory : [],
                        loading: state is SubCategoryLoad);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Row yesNowidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              height: 10,
              width: 25,
              child: Radio(
                activeColor: HexColor("#d4ac2c"),
                value: true,
                groupValue: editItemconfigRequest.type == "veg",
                onChanged: (val) {
                  editItemconfigRequest.type = "veg";
                  setState(() {});
                },
              ),
            ),
            const Text(
              'Veg',
              //style: style1,
            ),
          ],
        ),
        const SizedBox(
          width: 30,
        ),
        Row(
          children: [
            SizedBox(
              height: 10,
              width: 25,
              child: Radio(
                activeColor: HexColor("#d4ac2c"),
                value: false,
                groupValue: editItemconfigRequest.type == "veg",
                onChanged: (val) {
                  editItemconfigRequest.type = "nonveg";
                  setState(() {});
                },
              ),
            ),
            const Text(
              'Non-Veg',
              //style: style1,
            ),
          ],
        ),
      ],
    );
  }

  Container categoryDropdown(
      BuildContext context, List<MainCategoryModel> itemList,
      {bool loading = false, bool error = false}) {
    /*  if (itemList.isNotEmpty) {
      print(itemList
          .where((element) => element.name == editItemconfigRequest.category)
          .toList()
          .first);
    } */
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(color: Colors.grey)),
        child: CustomDropdownButton(
          value: (loading ||
                  itemList.isEmpty ||
                  editItemconfigRequest.category == null)
              ? null
              : itemList
                  .where((element) =>
                      element.id.toString() == editItemconfigRequest.category)
                  .toList()
                  .first,
          underline: const Divider(
            color: Colors.transparent,
          ),
          hint: const TextWidget(
            "-- Select Category --",
            color: Colors.grey,
          ),
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
                        color: HexColor("#d4ac2c"),
                      ),
                    ),
          onChanged: (value) {
            editItemconfigRequest.category = value.id.toString();
            categoryBloc.add(FetchSubCategory(value.id));
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

  Container subcategoryDropdown(
      BuildContext context, List<CategoryModel> itemList,
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
            "-- Select SubCategory --",
            color: Colors.grey,
          ),
          value: (loading ||
                  itemList.isEmpty ||
                  editItemconfigRequest.subcategory == null)
              ? null
              : itemList
                  .where((element) =>
                      element.id.toString() ==
                      editItemconfigRequest.subcategory)
                  .toList()
                  .first,
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
                        color: HexColor("#d4ac2c"),
                      ),
                    ),
          onChanged: (value) {
            editItemconfigRequest.subcategory = value.id.toString();
            setState(() {});
          },
          items: itemList.toList().map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item.name ?? "-",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.black),
              ),
            );
          }).toList(),
        ));
  }
}
