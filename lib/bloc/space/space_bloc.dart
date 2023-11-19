import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelpro_mobile/repository/space_repo.dart';

import '../../models/space_model.dart';

part 'space_event.dart';
part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  SpaceBloc() : super(SpaceInitial()) {
    on<FetchSpace>((event, emit) async {
      emit(SpaceLoad());
      try {
        final res = await SpaceRepository().data();

        emit(SpaceDone(res));
      } catch (e) {
        emit(SpaceError());
        throw ("error");
      }
    });
  }
}
