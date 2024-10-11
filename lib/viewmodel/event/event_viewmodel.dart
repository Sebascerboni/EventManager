import 'package:forms_project/models/category/category_model.dart';
import 'package:forms_project/models/event/active_events_model.dart';
import 'package:forms_project/models/event/event_model.dart';
import 'package:forms_project/services/event/ievent_service.dart';
import 'package:forms_project/viewmodel/event/ievent_viewmodel.dart';

import '../../models/event/event_info_model.dart';

class EventViewModel extends IEventViewModel {
  final IEventService _eventService;
  String _errorMessage = '';
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  EventInfoModel? _eventInfo;
  List<EventInfoModel> _eventsSearched = [];

  EventViewModel(
    this._eventService,
  ) {
    getActiveEvents();
  }

  List<String> paymentTypeNames = [];
  List<String> activeEventsNames = [];
  List<ActiveEventModel> activeEvensObjects = [];
  List<String> categoriesNames = [];

  @override
  bool get isLoading => _isLoading;

  @override
  Future<void> getCategories() async {
    try {
      var categories = await _eventService.fetchCategories();
      _categories = categories;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching active events: $e';
      throw Exception(e);
    }
  }

  @override
  Future<void> getActiveEvents() async {
    try {
      var activeEvents = await _eventService.getActiveEvents();
      activeEvensObjects = activeEvents;
      activeEventsNames = activeEvents.map((e) => e.name).toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error fetching active events: $e';
      throw Exception(e);
    }
  }

  @override
  List<ActiveEventModel> getActiveEventsObjects() {
    return activeEvensObjects;
  }

  @override
  List<CategoryModel> get categories => _categories;

  @override
  String get errorMessage => _errorMessage;

  @override
  Future<void> createEvent(EventModel event) async {
    _errorMessage = '';
    _isLoading = true;
    try {
      await _eventService.createEvent(event);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> createEventKit(EventModel event) async {
    _errorMessage = '';
    _isLoading = true;
    // notifyListeners();
    try {
      await _eventService.createEventKit(event);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> loadEventInfo(int id) async {
    try {
      _eventInfo = await _eventService.getEventInfo(id);
      notifyListeners();
    } catch (e) {
      _eventInfo = null;
    }
  }

  @override
  double? get minAmount => _eventInfo?.minAmount;

  @override
  double? get maxAmount => _eventInfo?.maxAmount;

  @override
  String? get deliveryType => _eventInfo?.deliveryType;

  @override
  bool? get vipStatus => _eventInfo!.paymentTypeVip.isNotEmpty ? _eventInfo?.paymentTypeVip[0].vip : null;

  @override
  Future<void> reloadActiveEvents() async {
    await getActiveEvents();
  }

  @override
  EventInfoModel? get eventInfo => _eventInfo;

  @override
  Future<void> updateEvent(EventModel event) async {
    _isLoading = true;
    try {
      await _eventService.updateEvent(event);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  Future<void> loadSearchedEvents(String eventName, String startDate, String endDate, String status) async {
    try {
      _eventsSearched = await _eventService.searchEvents(eventName, startDate, endDate, status);
      notifyListeners();
    } catch (e) {
      _eventInfo = null;
    }
  }

  @override
  List<EventInfoModel> get eventsSearched => _eventsSearched;
}
