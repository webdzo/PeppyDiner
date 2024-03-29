import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/cakes_model.dart';
import 'package:hotelpro_mobile/models/occasion_model.dart';
import 'package:hotelpro_mobile/models/user_model.dart';

import '../../models/packages_model.dart';
import '../../repository/addResrvation_repo.dart';
import 'add_reservation_event.dart';
import 'add_reservation_state.dart';

class AddResevationBloc extends Bloc<AddreservationEvent, AddReservationState> {
  AddResevationBloc() : super(AddReservationInitial()) {
    on<Addreservation>((event, emit) async {
      emit(AddReservationLoad());
      try {
        final response = await AddReservationRepository().data(event.request,
            edit: event.edit ?? false,
            addGuest: event.addGuest ?? false,
            id: event.id ?? "",
            guestId: event.guestId ?? "");

        emit(AddReservationDone());
      } catch (e) {
        emit(AddReservationError());
        throw ("error");
      }
    });

    on<UpdateGuest>((event, emit) async {
      emit(AddReservationLoad());
      try {
        final response = await AddReservationRepository()
            .updateGuest(event.request, event.id);

        emit(AddReservationDone());
      } catch (e) {
        emit(AddReservationError());
        throw ("error");
      }
    });

     on<UpdateGuestcount>((event, emit) async {
      emit(AddReservationLoad());
      try {
        final response = await AddReservationRepository()
            .updateGuestcount(event.count, event.id);

        emit(AddReservationDone());
      } catch (e) {
        emit(AddReservationError());
        throw ("error");
      }
    });

    on<Updatereservation>((event, emit) async {
      emit(AddReservationLoad());
      try {
        final response = await AddReservationRepository()
            .updateData(event.request, event.id);

        emit(AddReservationDone());
      } catch (e) {
        emit(AddReservationError());
        throw ("error");
      }
    });

    on<GetoccasionsEvent>((event, emit) async {
      emit(OccasionLoad());
      try {
        List<OccasionsModel> resp =
            await AddReservationRepository().getOccasions();

        emit(OccasionDone(resp));
      } catch (e) {
        emit(OccasionError());
        throw ("error");
      }
    });

    on<GetpackagesEvent>((event, emit) async {
      emit(PackagesLoad());
      try {
        List<PackagesModel> resp =
            await AddReservationRepository().getPackages();

        emit(PackagesDone(resp));
      } catch (e) {
        emit(PackagesError());
        throw ("error");
      }
    });

    on<GetcakesEvent>((event, emit) async {
      emit(CakesLoad());
      try {
        List<CakesModel> resp = await AddReservationRepository().getCakes();

        emit(CakesDone(resp));
      } catch (e) {
        emit(CakesError());
        throw ("error");
      }
    });

    on<GetusersEvent>((event, emit) async {
      emit(UsersLoad());
      try {
        List<UsersModel> resp = await AddReservationRepository().getUsers();

        emit(UsersDone(resp));
      } catch (e) {
        emit(UsersError());
        throw ("error");
      }
    });
  }
}
