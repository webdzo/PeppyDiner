part of 'items_bloc.dart';

abstract class ItemsEvent {}

class FetchItems extends ItemsEvent {
  final String id;
  FetchItems(this.id);
}

class FilterItems extends ItemsEvent {
  final String searchString;
  FilterItems(this.searchString);
}

class FetchItemConfig extends ItemsEvent {
  FetchItemConfig();
}

class EnableItems extends ItemsEvent {
  final List<int> itemIds;
  final bool enable;

  EnableItems(this.itemIds, this.enable);
}

class EditItemconfigEvent extends ItemsEvent {
  final EditItemconfigRequest request;
  final int id;
  EditItemconfigEvent(this.request, this.id);
}

class DeleteItems extends ItemsEvent {
  final int itemId;
 

  DeleteItems(this.itemId);
}
