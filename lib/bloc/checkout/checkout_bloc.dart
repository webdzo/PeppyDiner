import 'package:bloc/bloc.dart';


import '../../models/addOrders_request.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutDone checkoutDone = CheckoutDone();
  CheckoutBloc() : super(CheckoutInitial()) {
    on<AddCartitem>((event, emit) {
      emit(checkoutDone..cartItems = event.items);
    });
  }
}
