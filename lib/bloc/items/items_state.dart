part of 'items_bloc.dart';

abstract class ItemsState {}

class ItemsInitial extends ItemsState {}

class ItemsLoad extends ItemsState {}

class ItemsDone extends ItemsState {
   List<ItemsModel> items = [];

  List<ItemsModel> filterItemsList = [];
   List<ItemsModel> allItems = [];

   String searchText = "";


  ItemsDone();
}

class ItemsError extends ItemsState {}

class ItemconfigDone extends ItemsState {
  final List<ItemConfigModel> items;

  ItemconfigDone(this.items);
}

class EnableItemsLoad extends ItemsState {}

class EnableItemsDone extends ItemsState {}

class EnableItemsError extends ItemsState {}
class EditItemsconfigDone extends ItemsState {}
