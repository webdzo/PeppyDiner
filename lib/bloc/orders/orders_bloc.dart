import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/ongoing_model.dart';

import '../../models/addOrders_request.dart';
import '../../models/additem_model.dart';
import '../../models/orderlist_model.dart';
import '../../models/username_model.dart';
import '../../repository/orders_repo.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<FetchOrders>((FetchOrders event, emit) async {
      emit(OrdersLoad());
      try {
        final resp = await OrdersRepository()
            .data(event.id.toString(), event.tableId.toString());

        List<OrderlistModel> response = resp;

        emit(OrdersDone(response));
      } catch (e) {
        emit(OrdersError());
        throw ("error");
      }
    });

    on<AddOrders>((AddOrders event, emit) async {
      emit(AddOrdersLoad());
      try {
        print(event.addOrdersRequest.toJson());
        final resp = await OrdersRepository().addOrders(event.addOrdersRequest);

        emit(AddOrdersDone());
      } catch (e) {
        emit(AddOrdersError());
        throw ("error");
      }
    });
    on<AddItems>((AddItems event, emit) async {
      emit(AddOrdersLoad());
      try {
        final resp = await OrdersRepository()
            .addItems(event.additemsRequest, event.orderId);

        emit(AddOrdersDone());
      } catch (e) {
        emit(AddOrdersError());
        throw ("error");
      }
    });

    on<EditOrders>((EditOrders event, emit) async {
      emit(EditOrdersLoad());
      try {
        final resp = await OrdersRepository().editOrders(
            event.orderId, event.itemId, event.quanity, event.notes);

        emit(EditOrdersDone());
      } catch (e) {
        emit(EditOrdersError());
      }
    });

    on<DeleteItem>((event, emit) async {
      emit(EditOrdersLoad());
      try {
        final resp = await OrdersRepository()
            .deleteItem(event.orderId, event.itemId, event.reason);

        emit(EditOrdersDone());
      } catch (e) {
        if (e == "204") {
          emit(EditOrdersNodata());
        } else {
          emit(EditOrdersError());
        }
      }
    });
    on<DeleteOrder>((event, emit) async {
      emit(EditOrdersLoad());
      try {
        final resp = await OrdersRepository().deleteOrder(event.orderId);

        emit(EditOrdersDone());
      } catch (e) {
        if (e == "204") {
          emit(EditOrdersNodata());
        } else {
          emit(EditOrdersError());
        }
      }
    });

    on<GetUsername>((GetUsername event, emit) async {
      emit(GetnameLoad());
      try {
        final resp = await OrdersRepository().getName(event.id.toString());

        UsernameModel response =
            resp.where((element) => element.id == event.id).toList().first;

        emit(GetnameDone(response));
      } catch (e) {
        emit(GetnameError());
      }
    });

    on<CurrentOrders>((event, emit) async {
      emit(OrdersLoad());
      try {
        final resp = await OrdersRepository().current();

        List<OrderlistModel> response = resp;

        emit(OrdersDone(response));
      } catch (e) {
        if (e == "204") {
          emit(OrdersNodata());
        } else {
          emit(OrdersError());
        }
      }
    });

    on<OngoingOrders>((event, emit) async {
      emit(OrdersLoad());
      try {
        final resp = await OrdersRepository().ongoing();

        List<OngoingOrdermodel> response = resp;

        emit(OngoingDone(response));
      } catch (e) {
        if (e == "204") {
          emit(OrdersNodata());
        } else {
          emit(OrdersError());
        }
      }
    });

    on<KotEdit>((event, emit) async {
      emit(EditOrdersLoad());
      try {
        final resp = await OrdersRepository().kotEdit(event.orderId,
            itemId: event.itemId,
            status: event.status,
            reason: event.reason,
            close: event.close);

        emit(EditOrdersDone());
      } catch (e) {
        emit(EditOrdersError());
      }
    });

    on<CompleteOrder>((event, emit) async {
      emit(EditOrdersLoad());
      try {
        final resp =
            await OrdersRepository().completeOrder(event.orderId, event.resId);

        emit(EditOrdersDone());
      } catch (e) {
        emit(EditOrdersError());
      }
    });
  }
}
