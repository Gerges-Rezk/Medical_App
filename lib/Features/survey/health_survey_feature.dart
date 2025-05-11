import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'survey_provider.dart';
import 'survey_form.dart';
import 'survey_summary_screen.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SurveySummaryScreen(
                    surveys: context.read<SurveyProvider>().surveys,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: const SurveyForm(),
    );
  }
}
