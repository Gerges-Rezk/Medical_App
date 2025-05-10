import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'survey_form.dart';
import 'survey_summary_screen.dart';
import 'survey_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SurveyProvider(),
      child: const SurveyApp(),
    ),
  );
}

class SurveyApp extends StatelessWidget {
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Survey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey history'),
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
