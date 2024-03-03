import 'package:hotelpro_mobile/models/occasion_model.dart';
import 'package:hotelpro_mobile/models/user_model.dart';

import '../../models/cakes_model.dart';
import '../../models/packages_model.dart';

abstract class AddReservationState {}

class AddReservationInitial extends AddReservationState {}

class AddReservationLoad extends AddReservationState {}

class AddReservationDone extends AddReservationState {
  AddReservationDone();
}

class AddReservationError extends AddReservationState {}

class ReservationActionLoad extends AddReservationState {}

class ReservationActionDone extends AddReservationState {
  ReservationActionDone();
}

class ReservationActionError extends AddReservationState {}

class OccasionLoad extends AddReservationState {}

class OccasionDone extends AddReservationState {
  final List<OccasionsModel> occasions;

  OccasionDone(this.occasions);
}

class OccasionError extends AddReservationState {}

class PackagesLoad extends AddReservationState {}

class PackagesDone extends AddReservationState {
  final List<PackagesModel> packages;

  PackagesDone(this.packages);
}

class PackagesError extends AddReservationState {}

class CakesLoad extends AddReservationState {}

class CakesDone extends AddReservationState {
  final List<CakesModel> cakes;

  CakesDone(this.cakes);
}

class CakesError extends AddReservationState {}

class UsersLoad extends AddReservationState {}

class UsersDone extends AddReservationState {
  final List<UsersModel> users;

  UsersDone(this.users);
}

class UsersError extends AddReservationState {}
