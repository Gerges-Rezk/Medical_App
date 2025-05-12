import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'survey_provider.dart';
import 'survey_form.dart';

class HealthSurveyFeature extends StatelessWidget {
  const HealthSurveyFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: const SurveyHomeScreen(),
    );
  }
}

class SurveyHomeScreen extends StatelessWidget {
  const SurveyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Survey'),
      ),
      body: const SurveyForm(),
    );
  }
}
