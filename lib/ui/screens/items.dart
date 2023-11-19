import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/models/items_model.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/checkout/checkout_bloc.dart';
import '../../bloc/items/items_bloc.dart';
import '../../bloc/orders/orders_bloc.dart';
import '../../models/addOrders_request.dart';
import '../../models/additem_model.dart' as addItem;
import '../../route_generator.dart';
import '../widgets/rounded_button.dart';
import '../widgets/text_widget.dart';

class ItemsScreen extends StatefulWidget {
  final dynamic categoryArgs;

  const ItemsScreen({super.key, required this.categoryArgs});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  late ItemsBloc itemsBloc;
  late OrdersBloc ordersBloc;
  late CheckoutBloc checkoutBloc;

  // List<CartItems> checkoutBloc.checkoutDone.cartItems = [];

  AddOrdersRequest addOrdersRequest = AddOrdersRequest();
  TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    itemsBloc = BlocProvider.of<ItemsBloc>(context);
    checkoutBloc = widget.categoryArgs["bloc"];
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
            if (widget.categoryArgs["roomDetail"] == "0") {
              navigatorKey.currentState
                  ?.pushReplacementNamed("/home", arguments: 1);
            } else if (widget.categoryArgs["tableId"] == "") {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/viewReservation',
                  arguments: {
                    "rId": int.parse(widget.categoryArgs["roomDetail"]),
                    "nonDiner": true
                  },
                  (Route<dynamic> route) => false);
            } else {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                "/details",
                arguments: {
                  "rId": int.parse(widget.categoryArgs["roomDetail"]),
                  "tId":
                      int.tryParse(widget.categoryArgs["tableId"].toString()) ??
                          0,
                  "type": widget.categoryArgs["type"],
                  "identifier": widget.categoryArgs["identifier"],
                  "waiter": widget.categoryArgs["waiter"],
                  "fromtable": widget.categoryArgs["fromtable"]
                },
                (route) {
                  return false;
                },
              );
            }
          }
        },
      );
    itemsBloc.add(FetchItems(widget.categoryArgs["categoryId"] ?? ""));
    getUsername();
    getfilter();
    super.initState();
  }

  String filter = "";

  getfilter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    filter = pref.getString(
          widget.categoryArgs["identifier"],
        ) ??
        "";
  }

  String username = "";
  String userId = "";

  getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username") ?? "";
    userId = pref.getString("userId") ?? "";
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

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
      appBar: appbarWidget(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
                  child: TextWidget(
                    widget.categoryArgs["suCat"] ?? "--",
                    fontweight: FontWeight.w500,
                    size: 23.sp,
                  ),
                ),
                const RoundedBackButton()
              ],
            ),
          ),
          BlocBuilder<ItemsBloc, ItemsState>(
            builder: (context, state) {
              if (state is ItemsLoad) {
                const Center(child: CircularProgressIndicator());
              }

              if (state is ItemsDone) {
                List<ItemsModel> searchData = searchController.text.isEmpty
                    ? state.items
                    : state.items
                        .where((element) => (element.name
                            .toLowerCase()
                            .toString()
                            .startsWith(searchController.text.toLowerCase())))
                        .toList();
                print("length ${searchData.length}");
                if (filter == "veg") {
                  searchData = searchData
                      .where((element) => element.type == "veg")
                      .toList();
                }
                if (filter == "nonveg") {
                  searchData = searchData
                      .where((element) => element.type == "nonveg")
                      .toList();
                }
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.w),
                        child: searchBox(
                            searchController, "Search", "Search here", () {
                          setState(() {});
                        }),
                      ),
                      Expanded(
                        child: (searchData.isNotEmpty)
                            ? ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.w, horizontal: 15.w),
                                itemCount: searchData.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      listviewContent(
                                          searchData, index, context),
                                    ],
                                  );
                                },
                              )
                            : const Center(
                                child: TextWidget("No Items"),
                              ),
                      ),
                    ],
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  Container listviewContent(
      List<ItemsModel> items, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15.w),
          color: Colors.grey.shade200),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 5.w, bottom: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/vegLogo.png",
                    height: 35.w,
                    width: 35.w,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextWidget(
                      items[index].name,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
              TextWidget(
                "₹ ${items[index].price}",
                size: 22.sp,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /* SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextWidget(
                state.items[index].description ?? "--",
                color: Colors.grey,
              ),
            ), */
            if (checkoutBloc.checkoutDone.cartItems.indexWhere(
                    (element) => element.name == items[index].name) <
                0)
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      side: const BorderSide(color: Colors.black54, width: 0.7),
                      backgroundColor: Colors.grey.shade300.withOpacity(0.8)),
                  onPressed: () {
                    checkoutBloc.checkoutDone.cartItems.add(CartItems(
                        category: "Food",
                        eta: "00:30",
                        itemId: items[index].id,
                        name: items[index].name,
                        price: items[index].price,
                        quantity: 1,
                        subCategory: widget.categoryArgs["suCat"],
                        split: false,
                        modifiedEta: "2023-06-30T06:28:10.758Z",
                        key: items[index].name));
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.add,
                    size: 23.sp,
                    color: Colors.black54,
                  ),
                  label: const TextWidget("Add"),
                ),
              )
            else
              quantityCounter(checkoutBloc.checkoutDone.cartItems
                  .firstWhere((element) => element.itemId == items[index].id)),
          ],
        ),
      ]),
    );
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

  AppBar appbarWidget() {
    return AppBar(
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
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              if (widget.categoryArgs["tableId"] != "" &&
                  widget.categoryArgs["tableId"] != null)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                child: Row(
                    mainAxisAlignment: widget.categoryArgs["tableId"] == ""
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.categoryArgs["tableId"] != "")
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              child: Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black38),
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
                                  widget.categoryArgs["tableId"].toString(),
                                  color: Colors.black54,
                                )
                              ]),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.w, horizontal: 15.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.grey.shade900, width: 0.8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                  width: 10,
                                  child: Checkbox(
                                    shape: const CircleBorder(),
                                    tristate: true,
                                    checkColor: Colors.white,
                                    activeColor: Colors.grey.shade800,
                                    value: filter == "veg" ? true : false,
                                    onChanged: (bool? newValue) async {
                                      if (widget.categoryArgs["tableId"] !=
                                          "") {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setString(
                                            widget.categoryArgs["identifier"],
                                            (newValue ?? false) ? "veg" : "");
                                        getfilter();
                                      } else {
                                        filter =
                                            (newValue ?? false) ? "veg" : "";
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextWidget(
                                    "Veg",
                                    fontweight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.grey.shade900, width: 0.8)),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 15,
                                  width: 10,
                                  child: Checkbox(
                                    shape: const CircleBorder(),
                                    tristate: true,
                                    checkColor: Colors.white,
                                    activeColor: Colors.grey.shade800,
                                    value: filter == "nonveg" ? true : false,
                                    onChanged: (bool? newValue) async {
                                      if (widget.categoryArgs["tableId"] !=
                                          "") {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        pref.setString(
                                            widget.categoryArgs["identifier"],
                                            (newValue ?? false)
                                                ? "nonveg"
                                                : "");
                                        getfilter();
                                      } else {
                                        filter =
                                            (newValue ?? false) ? "nonveg" : "";
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.w),
                                  child: const TextWidget(
                                    "Non Veg",
                                    fontweight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }

  Stack bottomCurvewidget(String amount, {bool bottomSheet = false}) {
    return Stack(
      children: [
        Container(
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
                      onPressed: checkoutBloc.checkoutDone.cartItems.isNotEmpty
                          ? () {
                              if (widget.categoryArgs["update"]) {
                                if (bottomSheet) Navigator.pop(context);

                                addItem.AddItemsRequest addItemsRequest =
                                    addItem.AddItemsRequest(
                                        data: List.from(checkoutBloc
                                            .checkoutDone.cartItems
                                            .map((e) => addItem.Data.fromJson(
                                                e.toJson()))),
                                        reservationId: int.parse(
                                            widget.categoryArgs["roomDetail"]),
                                        notes: notesController.text);

                                bottomSheet
                                    ? ordersBloc.add(AddItems(addItemsRequest,
                                        widget.categoryArgs["orderId"]))
                                    : bottomsheetWidget(
                                        checkoutBloc.checkoutDone.cartItems);
                              } else {
                                if (bottomSheet) Navigator.pop(context);
                                addOrdersRequest = AddOrdersRequest(
                                    data: Data(
                                        tableDetails: TableDetails(
                                            tableId: int.tryParse(widget
                                                    .categoryArgs["tableId"]
                                                    .toString()) ??
                                                0,
                                            reservationIdentifier: widget
                                                .categoryArgs["identifier"],
                                            diningType: widget.categoryArgs["tableId"] == ""
                                                ? widget.categoryArgs["type"]
                                                : "dining",
                                            deliveryPartner: "",
                                            isDraft: false,
                                            waiterId: int.tryParse(widget
                                                    .categoryArgs["waiter"]
                                                    .toString()) ??
                                                0,
                                            notes: notesController.text),
                                        orders: checkoutBloc.checkoutDone.cartItems));
                                bottomSheet
                                    ? ordersBloc
                                        .add(AddOrders(addOrdersRequest))
                                    : bottomsheetWidget(
                                        checkoutBloc.checkoutDone.cartItems);
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

  void bottomsheetWidget(List<CartItems> itemList) async {
    await showModalBottomSheet(
      //showDragHandle: true,
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
                child: Container(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    //   scrollDirection: Axis.vertical,
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
    setState(() {});
  }
}

class WavingClipper extends CustomClipper<Path> {
  final int curveCount;
  final double clipPosition;

  WavingClipper({this.curveCount = 22, this.clipPosition = 0.9});

  @override
  Path getClip(Size size) {
    final path = Path();
    final curveWidth = size.width / curveCount;

    path.lineTo(0, size.height);

    for (int i = 0; i < curveCount; i++) {
      final controlPoint1 = Offset(
        (i * curveWidth) + (curveWidth / 2),
        size.height - 20 - (size.height * clipPosition),
      );
      final controlPoint2 = Offset(
        (i * curveWidth) + curveWidth,
        size.height - (size.height * clipPosition),
      );
      path.quadraticBezierTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
      );
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
