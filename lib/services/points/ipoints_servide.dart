import 'package:forms_project/models/points/points_model.dart';

abstract class IPointsService {
  Future<List<PointModel>> getPoints(String? clientID, int? eventID);
}