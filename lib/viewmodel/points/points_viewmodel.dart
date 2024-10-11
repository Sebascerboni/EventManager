import 'package:forms_project/models/points/points_model.dart';
import 'package:forms_project/services/points/ipoints_servide.dart';
import 'package:forms_project/viewmodel/points/ipoints_viewmodel.dart';

class PointsViewModel extends IPointsViewModel {
  final IPointsService _pointsService;

  PointsViewModel(this._pointsService);

  List<PointModel> _points = [];

  @override
  List<PointModel> get points => _points;

  @override
  Future<bool> loadPoints(String? clientId, int? eventId) async {
    try {
      _points = await _pointsService.getPoints(clientId, eventId);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
