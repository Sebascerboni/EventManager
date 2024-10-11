import 'package:flutter/material.dart';
import 'package:forms_project/models/points/points_model.dart';

abstract class IPointsViewModel extends ChangeNotifier{
  Future<bool> loadPoints(String? clientId, int? eventId);
  List<PointModel> get points;
}