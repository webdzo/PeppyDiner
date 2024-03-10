import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/models/reservation_details_model.dart';
import 'package:hotelpro_mobile/models/updatemode_request.dart';
import 'package:hotelpro_mobile/repository/reservation_repo.dart';

import '../../repository/addResrvation_repo.dart';

part 'reservations_event.dart';
part 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  ReservationsBloc() : super(ReservationsInitial()) {
    /*   on<FetchReservation>((event, emit) async {
      emit(ReservationsLoad());
      try {
        final res = await ReservationsRepository().data();

        emit(ReservationsDone(res));
      } catch (e) {
        emit(ReservationsError());
        throw ("error");
      }
    }); */

    on<ReservationDetailsEvent>((event, emit) async {
      emit(ReservationsLoad());
      try {
        final reservationList =
            await ReservationsRepository().details(event.id);

        emit(ReservationDetailsDone(reservationList));
      } catch (e) {
        if (e == "204") {
          emit(ReservationNodata());
        } else {
          emit(ReservationsError(e.toString()));
          throw ("error");
        }
      }
    });

    on<ReservationActions>((event, emit) async {
      emit(ReservationActionLoad());
      try {
        final response = await AddReservationRepository()
            .action(event.reservationId, event.statusId);

        emit(ReservationActionDone());
      } catch (e) {
        emit(ReservationActionError(e.toString()));
      }
    });

    on<PaynowEvent>((event, emit) async {
      emit(PaynowLoad());
      try {
        final response =
            await AddReservationRepository().paynow(event.id, event.amount);

        emit(PaynowDone());
      } catch (e) {
        emit(PaynowError());
        throw ("error");
      }
    });

    on<ResendmailEvent>((event, emit) async {
      emit(PaynowLoad());
      try {
        final response = await AddReservationRepository().resendMail(event.id);

        emit(PaynowDone());
      } catch (e) {
        emit(PaynowError());
        throw ("error");
      }
    });

    on<EditdiscountEvent>((event, emit) async {
      emit(PaynowLoad());
      try {
        final response = await AddReservationRepository()
            .editDiscount(event.id, event.discount);

        emit(PaynowDone());
      } catch (e) {
        emit(PaynowError());
        throw ("error");
      }
    });

    on<DeleteroomEvent>((event, emit) async {
      emit(PaynowLoad());
      try {
        final response =
            await AddReservationRepository().deleteRoom(event.id, event.room);

        emit(PaynowDone());
      } catch (e) {
        emit(PaynowError());
        throw ("error");
      }
    });

    on<EditCountEvent>((event, emit) async {
      emit(PaynowLoad());
      try {
        final response =
            await AddReservationRepository().editCount(event.id, event.count);

        emit(PaynowDone());
      } catch (e) {
        emit(PaynowError());
        throw ("error");
      }
    });

    on<SplitEvent>((event, emit) async {
      emit(SplitLoad());
      try {
        final response =
            await AddReservationRepository().split(event.id, event.splitdata);

        emit(SplitDone());
      } catch (e) {
        emit(SplitError());
        throw ("error");
      }
    });

    on<PrintEvent>((event, emit) async {
      emit(PrintLoad());
      try {
        final response = await AddReservationRepository().printBill(event.id);

        emit(PrintDone());
      } catch (e) {
        emit(PrintError());
        throw ("error");
      }
    });

    on<MarkUpdate>((event, emit) async {
      emit(MarkLoad());
      try {
        final response =
            await AddReservationRepository().mark(event.id, event.status);

        emit(MarkDone());
      } catch (e) {
        emit(MarkError());
        throw ("error");
      }
    });

    on<SwapEvent>((event, emit) async {
      emit(SwapLoad());
      try {
        final response = await AddReservationRepository()
            .swap(event.id, event.oldid, event.newid);

        emit(SwapDone());
      } catch (e) {
        emit(SwapError());
        throw ("error");
      }
    });

        on<BackdateEvent>((event, emit) async {
      emit(MarkLoad());
      try {
        final response = await AddReservationRepository().backdate(event.date);

        emit(MarkDone());
      } catch (e) {
        emit(MarkError());
        throw ("error");
      }
    });
  }
}
