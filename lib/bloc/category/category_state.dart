part of 'category_bloc.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class SubCategoryLoad extends CategoryState {}

class SubCategoryDone extends CategoryState {
  final List<CategoryModel> subcategory;

  SubCategoryDone(this.subcategory);
}

class SubCategoryError extends CategoryState {}

class CategoryLoad extends CategoryState {}

class CategoryDone extends CategoryState {
  final List<MainCategoryModel> category;

  CategoryDone(this.category);
}



class CategoryError extends CategoryState {}
