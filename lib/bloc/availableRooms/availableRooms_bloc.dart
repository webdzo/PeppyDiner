import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/availableRoom_repo.dart';
import 'availableRooms_event.dart';
import 'availableRooms_state.dart';

class AvailableRoomsBloc
    extends Bloc<AvailableRoomsEvent, AvailableRoomsState> {
  AvailableRoomsBloc() : super(AvailableRoomsInitial()) {
    on<FetchAvailableRooms>((event, emit) async {
      emit(AvailableRoomsLoad());
      try {
        final response = await AvailableRoomRepository()
            .data(event.startDate, event.endDate);

        emit(AvailableRoomsDone(response));
      } catch (e) {
        emit(AvailableRoomsError());
        throw ("error");
      }
    });

    on<FetchRooms>((event, emit) async {
      emit(AvailableRoomsLoad());
      try {
        final response = await AvailableRoomRepository().fetch();

        emit(FetchRoomsDone(response));
      } catch (e) {
        emit(AvailableRoomsError());
        throw ("error");
      }
    });
  }
}
