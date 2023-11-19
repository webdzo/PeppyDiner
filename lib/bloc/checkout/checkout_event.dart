part of 'checkout_bloc.dart';

abstract class CheckoutEvent {}

class AddCartitem extends CheckoutEvent {
  final List<CartItems> items;

  AddCartitem(this.items);
}
