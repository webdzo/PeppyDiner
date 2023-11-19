import 'package:bloc/bloc.dart';
import 'package:hotelpro_mobile/models/billpayment_model.dart';
import 'package:hotelpro_mobile/models/billupdate_request.dart';
import 'package:hotelpro_mobile/models/discount_model.dart';
import 'package:hotelpro_mobile/models/payments_model.dart';
import 'package:hotelpro_mobile/models/servicecharge_model.dart';
import 'package:hotelpro_mobile/repository/billpayment_repo.dart';

part 'billpayment_event.dart';
part 'billpayment_state.dart';

class BillpaymentBloc extends Bloc<BillpaymentEvent, BillpaymentState> {
  BillpaymentBloc() : super(BillpaymentInitial()) {
    on<FetchService>((event, emit) async {
      emit(ServiceLoad());
      try {
        final contacts = await BillRepo().charges();

        emit(ServiceDone(contacts));
      } catch (e) {
        emit(ServiceError());
        throw ("error");
      }
      try {
        final contacts = await BillRepo().discounts();

        emit(DiscountDone(contacts));
      } catch (e) {
        emit(DiscountError());
      }
      try {
        final contacts = await BillRepo().payments();

        emit(PaymentsDone(contacts));
      } catch (e) {
        emit(PaymentsError());
        throw ("error");
      }
      try {
        final contacts = await BillRepo().billDetail(event.id);

        emit(BillDone(contacts));
      } catch (e) {
        emit(BillError());
        throw ("error");
      }
    });

    on<FetchDiscount>((event, emit) async {
      emit(DiscountLoad());
      try {
        final contacts = await BillRepo().discounts();

        emit(DiscountDone(contacts));
      } catch (e) {
        emit(DiscountError());
      }
    });
    on<FetchPayments>((event, emit) async {
      emit(PaymentsLoad());
      try {
        final contacts = await BillRepo().payments();

        emit(PaymentsDone(contacts));
      } catch (e) {
        emit(PaymentsError());
        throw ("error");
      }
    });

    on<FetchBill>((event, emit) async {
      emit(BillLoad());
      try {
        final contacts = await BillRepo().billDetail(event.id);

        emit(BillDone(contacts));
      } catch (e) {
        emit(BillError());
        throw ("error");
      }
    });

    on<UpdateBill>((event, emit) async {
      emit(UpdateLoad());
      try {
        final contacts = await BillRepo().update(event.request, event.id);

        emit(UpdateDone());
      } catch (e) {
        emit(UpdateError());
      }
    });
  }
}
