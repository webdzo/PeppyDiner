part of 'space_bloc.dart';


abstract class SpaceState {}

class SpaceInitial extends SpaceState {}





class SpaceLoad extends SpaceState {}

class SpaceDone extends SpaceState {
  final List<SpaceModel> space;

  SpaceDone(this.space);
}

class SpaceError extends SpaceState {}

