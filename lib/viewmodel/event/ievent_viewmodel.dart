import 'package:flutter/material.dart';
import 'package:forms_project/models/category/category_model.dart';
import 'package:forms_project/models/event/active_events_model.dart';
import 'package:forms_project/models/event/event_info_model.dart';
import 'package:forms_project/models/event/event_model.dart';

abstract class IEventViewModel with ChangeNotifier {
  Future<void> getActiveEvents();
  Future<void> getCategories();
  List<ActiveEventModel> getActiveEventsObjects();
  List<CategoryModel> get categories;
  String get errorMessage;
  double? get minAmount;
  double? get maxAmount;
  bool? get vipStatus;
  String? get deliveryType;
  EventInfoModel? get eventInfo;
  bool get isLoading;
  List<EventInfoModel> get eventsSearched;
  Future<void> createEvent(EventModel event);
  Future<void> createEventKit(EventModel event);
  Future<void> loadEventInfo(int id);
  Future<void> loadSearchedEvents(String eventName, String startDate, String endDate, String status);
  Future<void> reloadActiveEvents();
  Future<void> updateEvent(EventModel event);
}
