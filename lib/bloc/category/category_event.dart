part of 'category_bloc.dart';

abstract class CategoryEvent {}

class FetchSubCategory extends CategoryEvent {
  final int id;
  final bool all;
  FetchSubCategory(this.id, {this.all=false});
}

class FetchCategory extends CategoryEvent {
  FetchCategory();
}


