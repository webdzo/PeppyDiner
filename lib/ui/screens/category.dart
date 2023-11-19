import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/checkout/checkout_bloc.dart';
import 'package:hotelpro_mobile/bloc/orders/orders_bloc.dart';
import 'package:hotelpro_mobile/bloc/reservations/reservations_bloc.dart';
import 'package:hotelpro_mobile/models/addOrders_request.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/category/category_bloc.dart';
import '../../models/additem_model.dart' as addItem;
import '../../route_generator.dart';
import '../widgets/rounded_button.dart';
import '../widgets/text_widget.dart';

class CategoryScreen extends StatefulWidget {
  final dynamic roomDetails;

  const CategoryScreen({super.key, required this.roomDetails});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late CategoryBloc categoryBloc;
  ReservationsBloc reservationsBloc = ReservationsBloc();
  late CheckoutBloc checkoutBloc;

  String? selectedCategory;
  late OrdersBloc ordersBloc;
  AddOrdersRequest addOrdersRequest = AddOrdersRequest();
  TextEditingController notesController = TextEditingController();
  @override
  void initState() {
    getUsername();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
    categoryBloc = BlocProvider.of<CategoryBloc>(context);
    ordersBloc = BlocProvider.of<OrdersBloc>(context);
    reservationsBloc = BlocProvider.of<ReservationsBloc>(context);

    categoryBloc.add(FetchSubCategory(1));
    ordersBloc = BlocProvider.of<OrdersBloc>(context)
      ..stream.listen(
        (event) {
          if (event is AddOrdersLoad) {
            EasyLoading.show(status: 'loading...');
          }
          if (event is AddOrdersError) {
            EasyLoading.showError('Failed with Error');
          }
          if (event is AddOrdersDone) {
            EasyLoading.showSuccess('Success!');

            checkoutBloc.checkoutDone.cartItems = [];
            Navigator.pop(context);
            if (widget.roomDetails["reservId"] == "0") {
              navigatorKey.currentState
                  ?.pushReplacementNamed("/home", arguments: 1);
            } else if (widget.roomDetails["tableId"] == "") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/viewReservation',
                  arguments: {
                    "rId": int.parse(widget.roomDetails["reservId"].toString()),
                    "nonDiner": true
                  },
                  (Route<dynamic> route) => false);
            } else {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                "/details",
                arguments: {
                  "rId": int.parse(widget.roomDetails["reservId"]),
                  "tId":
                      int.tryParse(widget.roomDetails["tableId"].toString()) ??
                          0,
                  "type": widget.roomDetails["type"],
                  "identifier": widget.roomDetails["identifier"],
                  "waiter": widget.roomDetails["waiter"],
                  "fromtable": widget.roomDetails["fromtable"]
                },
                (route) {
                  return false;
                },
              );
            }
          }
        },
      );

    super.initState();
  }

  String username = "";

  getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username") ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomCurvewidget(checkoutBloc.checkoutDone.cartItems
          .fold("0", (previousValue, element) {
        return (double.parse(previousValue) +
                ((element.quantity ?? 0) *
                    double.parse(element.price ?? "0.0")))
            .toString();
      })),
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(5.w),
          child: Image.asset("assets/appLogo.png"),
        ),
        backgroundColor: HexColor("#d4ac2c"),
        elevation: 1,
        title: TextWidget(
          "Hi ${username != "" ? username.capitalize() : username},",
          style: GoogleFonts.belleza(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 33.w,
          ),
        ),
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(
                (widget.roomDetails["tableId"] != "" &&
                        widget.roomDetails["tableId"] != null)
                    ? 80.w
                    : 40.w),
            child: Column(
              children: [
                if (widget.roomDetails["tableId"] != "" &&
                    widget.roomDetails["tableId"] != null)
                  const Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (widget.roomDetails["tableId"] != "")
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.w),
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black38),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.restaurant_menu_rounded,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7.w,
                                  ),
                                  TextWidget(
                                    widget.roomDetails["tableId"].toString(),
                                    color: Colors.black54,
                                  )
                                ]),
                              ),
                            ],
                          ),
                      ]),
                ),
              ],
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(15.w),
                  child: TextWidget(
                    "Categories",
                    size: 22.sp,
                    fontweight: FontWeight.bold,
                  ),
                ),
                const RoundedBackButton()
              ],
            ),
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            buildWhen: (previous, current) {
              return current is SubCategoryLoad ||
                  current is SubCategoryDone ||
                  current is SubCategoryError;
            },
            builder: (context, state) {
              if (state is SubCategoryLoad) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SubCategoryDone) {
                return Expanded(
                    child: SingleChildScrollView(
                  child: Wrap(
                    children: List.generate(state.subcategory.length,
                        (index) => gridWidget(state, index)),
                  ),
                ));
              }

              return const Center(child: TextWidget("No Data"));
            },
          ),
        ],
      ),
    );
  }

  GestureDetector gridWidget(SubCategoryDone state, int index) {
    return GestureDetector(
      onTap: () {
        navigatorKey.currentState?.pushNamed("/itemsScreen", arguments: {
          "suCat": state.subcategory[index].name,
          "categoryName": selectedCategory,
          "categoryId": state.subcategory[index].id.toString(),
          "roomDetail": widget.roomDetails["reservId"].toString(),
          "orderId": widget.roomDetails["orderId"].toString(),
          "identifier": widget.roomDetails["identifier"].toString(),
          "update": widget.roomDetails["update"],
          "tableId": widget.roomDetails["tableId"],
          "type": widget.roomDetails["type"],
          "waiter": widget.roomDetails["waiter"],
          "fromtable": widget.roomDetails["fromtable"],
          "bloc":checkoutBloc
        }).then((value) {
          setState(() {});
        });
      },
      child: Container(
        width: 160.w,
        height: 200.w,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.w),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Image.network(
            "https://thumbs.dreamstime.com/b/chinese-soup-instant-23685234.jpg",
            fit: BoxFit.fitHeight,
            height: 100.w,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 15.w,
            ),
            child: TextWidget(
              state.subcategory[index].name ?? "--",
              textalign: TextAlign.center,
              fontweight: FontWeight.w500,
              size: 16.sp,
            ),
          )
        ]),
      ),
    );
  }

  Stack bottomCurvewidget(String amount, {bool bottomSheet = false}) {
    return Stack(
      children: [
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            return Container(
              color: HexColor("#d4ac2c"), //change
              height: 155.w,
              padding: EdgeInsets.only(right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          margin: EdgeInsets.all(15.w),
                          padding: EdgeInsets.all(15.w),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.restaurant_rounded)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            "₹ $amount",
                            size: 27.sp,
                            color: Colors.white,
                            fontweight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: 8.w,
                          ),
                          const TextWidget(
                            "Extra charges may apply",
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        "${checkoutBloc.checkoutDone.cartItems.length.toString()} items in cart",
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 3.w,
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            backgroundColor: Colors.grey.shade200,
                          ),
                          onPressed: checkoutBloc
                                  .checkoutDone.cartItems.isNotEmpty
                              ? () {
                                  if (widget.roomDetails["update"]) {
                                    if (bottomSheet) Navigator.pop(context);

                                    addItem.AddItemsRequest addItemsRequest =
                                        addItem.AddItemsRequest(
                                            data: List.from(checkoutBloc
                                                .checkoutDone.cartItems
                                                .map((e) =>
                                                    addItem.Data.fromJson(
                                                        e.toJson()))),
                                            reservationId: int.parse(
                                                widget.roomDetails["reservId"]),
                                            notes: notesController.text);

                                    bottomSheet
                                        ? ordersBloc.add(AddItems(
                                            addItemsRequest,
                                            widget.roomDetails["orderId"]))
                                        : bottomsheetWidget(checkoutBloc
                                            .checkoutDone.cartItems);
                                  } else {
                                    if (bottomSheet) Navigator.pop(context);
                                    addOrdersRequest = AddOrdersRequest(
                                        data: Data(
                                            tableDetails: TableDetails(
                                                tableId: int.tryParse(widget
                                                        .roomDetails["tableId"]
                                                        .toString()) ??
                                                    0,
                                                reservationIdentifier: widget
                                                    .roomDetails["identifier"],
                                                diningType: widget.roomDetails["tableId"] == ""
                                                    ? widget.roomDetails["type"]
                                                    : "dining",
                                                deliveryPartner: "",
                                                isDraft: false,
                                                waiterId: int.tryParse(widget
                                                        .roomDetails["waiter"]
                                                        .toString()) ??
                                                    0,
                                                notes: notesController.text),
                                            orders: checkoutBloc.checkoutDone.cartItems));
                                    bottomSheet
                                        ? ordersBloc
                                            .add(AddOrders(addOrdersRequest))
                                        : bottomsheetWidget(checkoutBloc
                                            .checkoutDone.cartItems);
                                  }
                                }
                              : () {
                                  Fluttertoast.showToast(
                                      msg: "Please select items",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                          child: TextWidget(
                            bottomSheet ? "Place Order" : "View Order",
                            size: 19.sp,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
        ClipPath(
          clipper: MultipleRoundedCurveClipper(),
          child: Container(
            color: Colors.white,
            height: 10,
          ),
        ),
      ],
    );
  }

  void bottomsheetWidget(List<CartItems> itemList)async {
   await showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setstate) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.w),
                            child: const TextWidget(
                              "Your order summary",
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                    ),
                    Container(
                      height: 10,
                      margin: EdgeInsets.only(bottom: 10.w),
                      child: const Divider(
                        thickness: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: Divider(
                      height: 2,
                      thickness: 0.5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                    child: Card(
                      elevation: 1,
                      child: TextFormField(
                        minLines: 3,
                        maxLines: null,
                        controller: notesController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelStyle: const TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade500, width: 0.4)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 0.009)),
                          labelText:
                              'Enter any additional information about your order.',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.w,
                  ),
                  bottomCurvewidget(
                      checkoutBloc.checkoutDone.cartItems.fold("0",
                          (previousValue, element) {
                        return (double.parse(previousValue) +
                                ((element.quantity ?? 0) *
                                    double.parse(element.price ?? "0.0")))
                            .toString();
                      }),
                      bottomSheet: true)
                ],
              ),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    children: [
                      if (checkoutBloc.checkoutDone.cartItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: TextWidget("No items found"),
                        )
                      else
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 10),
                            shrinkWrap: true,
                            itemCount:
                                checkoutBloc.checkoutDone.cartItems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  minLeadingWidth: 10,
                                  leading: Image.asset(
                                    "assets/vegLogo.png",
                                    height: 20,
                                  ),
                                  title: TextWidget(
                                    checkoutBloc.checkoutDone.cartItems[index]
                                            .name ??
                                        "--",
                                    size: 21.sp,
                                  ),
                                  trailing: SizedBox(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7.w),
                                          child: TextWidget(
                                            "₹ ${checkoutBloc.checkoutDone.cartItems[index].price ?? "--"}",
                                            size: 22.sp,
                                          ),
                                        ),
                                        quantityCounter(
                                            checkoutBloc
                                                .checkoutDone.cartItems[index],
                                            setstate: setstate)
                                      ],
                                    ),
                                  ));
                            }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
    setState(() {
      
    });
  }

  Container quantityCounter(CartItems item, {setstate}) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.w),
        color: HexColor("#d4ac2c"),
      ),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                if ((checkoutBloc
                            .checkoutDone
                            .cartItems[checkoutBloc.checkoutDone.cartItems
                                .indexWhere((element) => item == element)]
                            .quantity ??
                        0) >
                    1) {
                  checkoutBloc
                      .checkoutDone
                      .cartItems[checkoutBloc.checkoutDone.cartItems
                          .indexWhere((element) => item == element)]
                      .quantity = (checkoutBloc
                              .checkoutDone
                              .cartItems[checkoutBloc.checkoutDone.cartItems
                                  .indexWhere((element) => item == element)]
                              .quantity ??
                          0) -
                      1;
                } else {
                  checkoutBloc.checkoutDone.cartItems.remove(item);
                }
                if (setstate != null) {
                  setstate(() {});
                } else {
                  setState(() {});
                }
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
              (checkoutBloc
                          .checkoutDone
                          .cartItems[checkoutBloc.checkoutDone.cartItems
                              .indexWhere((element) => item == element)]
                          .quantity ??
                      0)
                  .toString(),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          InkWell(
              onTap: () {
                checkoutBloc
                    .checkoutDone
                    .cartItems[checkoutBloc.checkoutDone.cartItems
                        .indexWhere((element) => item == element)]
                    .quantity = (checkoutBloc
                            .checkoutDone
                            .cartItems[checkoutBloc.checkoutDone.cartItems
                                .indexWhere((element) => item == element)]
                            .quantity ??
                        0) +
                    1;

                if (setstate != null) {
                  setstate(() {});
                } else {
                  setState(() {});
                }
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
