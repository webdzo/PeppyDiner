import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_model.dart';
import '../../models/main_category_model.dart';
import '../../repository/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<FetchCategory>((event, emit) async {
      emit(CategoryLoad());
      try {
        final contacts = await CategoryRepository().category();

        emit(CategoryDone(contacts));
      } catch (e) {
        emit(CategoryError());
        throw ("error");
      }
    });

    on<FetchSubCategory>((event, emit) async {
      emit(SubCategoryLoad());
      try {
        final contacts = await CategoryRepository().data(event.id);

        emit(SubCategoryDone(contacts));
      } catch (e) {
        emit(SubCategoryError());
        throw ("error");
      }
    });

  
  }
}
