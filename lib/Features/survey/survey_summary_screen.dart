import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'survey_data.dart';
import 'survey_provider.dart';

class SurveySummaryScreen extends StatefulWidget {
  final List<SurveyData> surveys;

  const SurveySummaryScreen({super.key, required this.surveys});

  @override
  State<SurveySummaryScreen> createState() => _SurveySummaryScreenState();
}

class _SurveySummaryScreenState extends State<SurveySummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Load surveys when the screen is opened
    Future.microtask(() => context.read<SurveyProvider>().loadSurveys());
  }

  Future<void> _deleteSurvey(BuildContext context, SurveyData survey) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Survey'),
        content: Text(
            'Are you sure you want to delete the survey for ${survey.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await context.read<SurveyProvider>().deleteSurvey(survey.nationalId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Survey deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting survey: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Survey Summaries')),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          final surveys = provider.surveys;
          if (surveys.isEmpty) {
            return const Center(
              child: Text('No surveys submitted yet'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final survey = surveys[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _showSurveyDetails(context, survey),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                survey.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSurvey(context, survey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('National ID: ${survey.nationalId}'),
                        Text(
                          'Date of Birth: ${DateFormat('yyyy-MM-dd').format(survey.dateOfBirth)}',
                        ),
                        Text('Phone: ${survey.phone}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSurveyDetails(BuildContext context, SurveyData survey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(survey.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('National ID: ${survey.nationalId}'),
              Text(
                'Date of Birth: ${DateFormat('yyyy-MM-dd').format(survey.dateOfBirth)}',
              ),
              Text('Phone: ${survey.phone}'),
              Text('Chronic Disease: ${survey.chronicDisease}'),
              Text('Allergy: ${survey.allergy}'),
              Text('Medication: ${survey.medication}'),
              Text('Family History: ${survey.familyHistory}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
