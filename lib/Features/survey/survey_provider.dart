import 'package:flutter/foundation.dart';
import 'survey_data.dart';
import 'database_helper.dart';

class SurveyProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<SurveyData> _surveys = [];

  List<SurveyData> get surveys => List.unmodifiable(_surveys);

  Future<void> loadSurveys() async {
    _surveys = await _dbHelper.getSurveys();
    notifyListeners();
  }

  Future<void> addSurvey(SurveyData survey) async {
    await _dbHelper.insertSurvey(survey);
    _surveys.add(survey);
    notifyListeners();
  }

  Future<void> deleteSurvey(String nationalId) async {
    await _dbHelper.deleteSurvey(nationalId);
    _surveys.removeWhere((survey) => survey.nationalId == nationalId);
    notifyListeners();
  }
}
