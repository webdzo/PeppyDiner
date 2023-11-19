import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/bloc/finance/finance_bloc.dart';
import 'package:hotelpro_mobile/main_qa.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';
import 'package:hotelpro_mobile/ui/screens/finance.dart';
import 'package:hotelpro_mobile/ui/screens/my_tables.dart';
import 'package:hotelpro_mobile/ui/screens/non_dining.dart';
import 'package:hotelpro_mobile/ui/screens/profile.dart';
import 'package:hotelpro_mobile/ui/screens/reservations_list.dart';
import 'package:hotelpro_mobile/ui/screens/stepper_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/table/table_bloc.dart';

class ScaffoldWidget extends StatefulWidget {
  final int inititalIndex;
  const ScaffoldWidget({super.key, this.inititalIndex = 0});

  @override
  State<ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState extends State<ScaffoldWidget> {
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: widget.inititalIndex);
    getRole();
    super.initState();
  }

  String role = "";

  getRole() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    role = pref.getString("role") ?? "";
    setState(() {});
  }

  late final PersistentTabController _controller;
  List<Widget> _buildScreens() {
    return [
      if (role == "ROLE_ADMIN" || role == "ROLE_MANAGER")
        const ReservationList(),
      const Nondining(),
      const MyTables(),
      BlocProvider(
        create: (context) => TableBloc(),
        child: const StepperScreen(),
      ),
      if (role == "ROLE_ADMIN")
        BlocProvider(
          create: (context) => FinanceBloc(),
          child: const FinanceScreen(),
        ),
      const MyProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      if (role == "ROLE_ADMIN" || role == "ROLE_MANAGER")
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.room_service),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          title: ("Reservation"),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.white,
        ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.delivery_dining_rounded),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        title: ("Non-Diner"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.table_restaurant,
          //color: Colors.white,
        ),
        title: ("Tables"),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      /*  PersistentBottomNavBarItem(
        icon: const Icon(Icons.restaurant),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        title: ("Unassigned"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ), */

      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dining),
        title: ("Dining"),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
      if (role == "ROLE_ADMIN")
        PersistentBottomNavBarItem(
          icon: const Icon(
            Icons.attach_money_sharp,
            //color: Colors.white,
          ),
          title: ("Finance"),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          activeColorPrimary: CupertinoColors.black,
          inactiveColorPrimary: CupertinoColors.white,
        ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person_fill),
        title: ("Profile"),
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: PersistentTabView(
        context,
        onItemSelected: (value) {
          bottomIndex = value;
          setState(() {});
        },
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: HexColor("#d4ac2c"), // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: false, // Default is true.

        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style1, // Choose the nav bar style with this property.
      ),
    );
  }
}
