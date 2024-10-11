import 'package:forms_project/models/category/category_model.dart';
import 'package:forms_project/models/event/active_events_model.dart';
import 'package:forms_project/models/event/event_model.dart';
import 'package:forms_project/models/payment/payment_type_model.dart';

import '../../models/event/event_info_model.dart';

abstract class IEventService {
  Future<List<ActiveEventModel>> getActiveEvents();
  Future<List<PaymentTypeModel>> getPaymentType();
  Future<void> createEvent(EventModel event);
  Future<void> createEventKit(EventModel event);
  Future<List<CategoryModel>> fetchCategories();
  Future<List<PaymentTypeModel>> fetchPaymentTypes();
  Future<EventInfoModel> getEventInfo(int id);
  Future<List<EventInfoModel>> searchEvents(String eventName, String starDate, String endDate, String status);
  Future<void> updateEvent(EventModel event);
}