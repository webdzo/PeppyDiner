part of 'checkout_bloc.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutDone extends CheckoutState {
  List<CartItems> cartItems = [];

  CheckoutDone();
}
