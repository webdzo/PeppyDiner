import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/editItemconfig_request.dart';
import 'package:hotelpro_mobile/models/itemconfig_model.dart';

import '../../models/items_model.dart';
import '../../repository/items_repo.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  ItemsBloc() : super(ItemsInitial()) {
    on<FetchItems>((event, emit) async {
      emit(ItemsLoad());
      try {
        final items = await ItemsRepository().data(event.id);

        emit(ItemsDone(items));
      } catch (e) {
        emit(ItemsError());
        throw ("error");
      }
    });

    on<FetchItemConfig>((event, emit) async {
      emit(ItemsLoad());
      try {
        final contacts = await ItemsRepository().items();

        emit(ItemconfigDone(contacts));
      } catch (e) {
        emit(ItemsError());
        throw ("error");
      }
    });

    on<EnableItems>((event, emit) async {
      emit(EnableItemsLoad());
      try {
        final contacts =
            await ItemsRepository().enable(event.enable, event.itemIds);

        emit(EnableItemsDone());
      } catch (e) {
        emit(EnableItemsError());
        throw ("error");
      }
    });

    on<EditItemconfigEvent>((event, emit) async {
      emit(ItemsLoad());
      try {
        final contacts = await ItemsRepository().edit(event.request, event.id);

        emit(EditItemsconfigDone());
      } catch (e) {
        emit(ItemsError());
        throw ("error");
      }
    });

    on<DeleteItems>((event, emit) async {
      emit(EnableItemsLoad());
      try {
        final contacts = await ItemsRepository().delete(event.itemId);

        emit(EnableItemsDone());
      } catch (e) {
        emit(EnableItemsError());
        throw ("error");
      }
    });
  }
}
