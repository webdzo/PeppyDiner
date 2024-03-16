import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/bloc/bloc/billpayment_bloc.dart';
import 'package:hotelpro_mobile/bloc/checkout/checkout_bloc.dart';
import 'package:hotelpro_mobile/bloc/finance/finance_bloc.dart';
import 'package:hotelpro_mobile/bloc/items/items_bloc.dart';
import 'package:hotelpro_mobile/bloc/login/login_bloc.dart';
import 'package:hotelpro_mobile/models/itemconfig_model.dart';
import 'package:hotelpro_mobile/ui/screens/add_reservation.dart';
import 'package:hotelpro_mobile/ui/screens/category.dart';
import 'package:hotelpro_mobile/ui/screens/config.dart';
import 'package:hotelpro_mobile/ui/screens/details.dart';
import 'package:hotelpro_mobile/ui/screens/edit_itemconfig.dart';
import 'package:hotelpro_mobile/ui/screens/finance.dart';
import 'package:hotelpro_mobile/ui/screens/item_config.dart';
import 'package:hotelpro_mobile/ui/screens/items.dart';
import 'package:hotelpro_mobile/ui/screens/kds.dart';
import 'package:hotelpro_mobile/ui/screens/login_page.dart';
import 'package:hotelpro_mobile/ui/screens/manage_table.dart';
import 'package:hotelpro_mobile/ui/screens/manage_user.dart';
import 'package:hotelpro_mobile/ui/screens/profile.dart';
import 'package:hotelpro_mobile/ui/screens/reserv_details.dart';
import 'package:hotelpro_mobile/ui/screens/view_reservation.dart';
import 'package:hotelpro_mobile/ui/widgets/scaffold_widget.dart';

import 'bloc/addReservation/add_reservation_bloc.dart';
import 'bloc/availableRooms/availableRooms_bloc.dart';
import 'bloc/category/category_bloc.dart';
import 'bloc/orders/orders_bloc.dart';
import 'bloc/reservations/reservations_bloc.dart';
import 'bloc/space/space_bloc.dart';
import 'bloc/table/table_bloc.dart';
import 'models/addReserv_request.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;

  switch (settings.name) {
    case "/":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LoginBloc(),
                  ),
                ],
                child: const Signin(),
              ));

    case "/home":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SpaceBloc(),
                  ),
                ],
                child: ScaffoldWidget(inititalIndex: (args ?? 0) as int),
              ));

    case "/config":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => CategoryBloc(),
                child: const ConfigScreen(),
              ));

    case "/itemconfig":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => ItemsBloc(),
                child: const ItemConfig(),
              ));

    case "/userConfig":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => AddResevationBloc(),
                child: const ManageUser(),
              ));

    case "/reports":
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => FinanceBloc(),
          child: const FinanceScreen(),
        ),
      );

    case "/tableslist":
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => TableBloc(),
          child: const ManageTable(),
        ),
      );

    case "/profile":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => ItemsBloc(),
                child: const MyProfile(),
              ));
    case "/kdsScreen":
      return MaterialPageRoute(
          builder: (_) => BlocProvider(
                create: (context) => OrdersBloc(),
                child: const KdsScreen(),
              ));
    case "/edititemconfig":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ItemsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => CategoryBloc(),
                  ),
                ],
                child: EditItemconfig(
                    items: args != null ? (args as ItemConfigModel) : null),
              ));

    case "/details":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => OrdersBloc(),
                  ),
                  BlocProvider(
                    create: (context) => TableBloc(),
                  ),
                ],
                child: DetailScreen(data: args as dynamic),
              ));
    case "/categoryScreen":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => CheckoutBloc(),
                  ),
                  BlocProvider(
                    create: (context) => OrdersBloc(),
                  ),
                  BlocProvider(
                    create: (context) => CategoryBloc(),
                  ),
                  BlocProvider(
                    create: (context) => ItemsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => ReservationsBloc(),
                  ),
                ],
                child: CategoryScreen(roomDetails: args as dynamic),
              ));

    case '/addReservation':
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AvailableRoomsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddResevationBloc(),
                  ),
                ],
                child: AddReservation(argue: (args) as dynamic),
              ));

    case '/reservDetails':
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => AddResevationBloc(),
                  ),
                  BlocProvider(
                    create: (context) => BillpaymentBloc(),
                  ),
                ],
                child: ReservationDetails(
                  addReservRequest: args as AddReservRequest,
                ),
              ));

    case "/itemsScreen":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ItemsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => OrdersBloc(),
                  ),
                ],
                child: ItemsScreen(
                  categoryArgs: args as dynamic,
                ),
              ));

    case "/viewReservation":
      return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => BillpaymentBloc(),
                  ),
                  BlocProvider(
                    create: (context) => ReservationsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => OrdersBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AvailableRoomsBloc(),
                  ),
                  BlocProvider(
                    create: (context) => AddResevationBloc(),
                  ),
                ],
                child: ViewResercations(id: args as dynamic),
              ));

    default:
      return MaterialPageRoute(builder: (_) {
        return const Scaffold(
          body: Center(
            child: Text("Page not found"),
          ),
        );
      });
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  Future<dynamic> navigateTo(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }

  Future<dynamic> navigateTopop(String routeName, Object? arg) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arg);
  }
}
