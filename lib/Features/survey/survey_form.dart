import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'survey_data.dart';
import 'survey_provider.dart';

class SurveyForm extends StatefulWidget {
  const SurveyForm({super.key});

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _chronicDisease;
  String? _allergy;
  String? _medication;
  String? _familyHistory;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final surveyData = SurveyData(
        name: _nameController.text,
        nationalId: _nationalIdController.text,
        dateOfBirth: _selectedDate!,
        phone: _phoneController.text,
        chronicDisease: _chronicDisease ?? 'Not selected',
        allergy: _allergy ?? 'Not selected',
        medication: _medication ?? 'Not selected',
        familyHistory: _familyHistory ?? 'Not selected',
      );

      try {
        // Save the survey data
        await context.read<SurveyProvider>().addSurvey(surveyData);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Survey submitted successfully!')),
          );
        }

        // Clear the form
        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = null;
          _chronicDisease = null;
          _allergy = null;
          _medication = null;
          _familyHistory = null;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving survey: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Survey')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.formPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildNameField(),
              _buildNationalIdField(),
              _buildDateOfBirthField(),
              _buildPhoneField(),
              _buildChronicDiseaseField(),
              _buildAllergyField(),
              _buildMedicationField(),
              _buildFamilyHistoryField(),
              const SizedBox(height: AppConstants.formSpacing),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(labelText: 'Name'),
      textInputAction: TextInputAction.next,
      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
    );
  }

  Widget _buildNationalIdField() {
    return TextFormField(
      controller: _nationalIdController,
      decoration: const InputDecoration(labelText: 'National ID'),
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your National ID';
        if (!RegExp(r'^\d{16}$').hasMatch(value)) {
          return 'National ID must be 16 digits';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    final hasError = _selectedDate == null &&
        _formKey.currentState != null &&
        !_formKey.currentState!.validate();
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          errorText: hasError ? 'Please select your date of birth' : null,
        ),
        child: Text(
          _selectedDate == null
              ? 'Select Date'
              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(labelText: 'Phone'),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your phone number';
        if (!RegExp(r'^\d{11}$').hasMatch(value)) {
          return 'Phone number must be 11 digits';
        }
        return null;
      },
    );
  }

  Widget _buildChronicDiseaseField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Chronic Diseases'),
      value: _chronicDisease,
      items: AppConstants.chronicDiseases.map((String disease) {
        return DropdownMenuItem<String>(
          value: disease,
          child: Text(disease),
        );
      }).toList(),
      onChanged: (value) => setState(() => _chronicDisease = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildAllergyField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Allergies'),
      value: _allergy,
      items: AppConstants.allergies.map((String allergy) {
        return DropdownMenuItem<String>(
          value: allergy,
          child: Text(allergy),
        );
      }).toList(),
      onChanged: (value) => setState(() => _allergy = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildMedicationField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Medications'),
      value: _medication,
      items: AppConstants.medications.map((String medication) {
        return DropdownMenuItem<String>(
          value: medication,
          child: Text(medication),
        );
      }).toList(),
      onChanged: (value) => setState(() => _medication = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  Widget _buildFamilyHistoryField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Family History'),
      value: _familyHistory,
      items: AppConstants.familyHistory.map((String history) {
        return DropdownMenuItem<String>(
          value: history,
          child: Text(history),
        );
      }).toList(),
      onChanged: (value) => setState(() => _familyHistory = value),
      validator: (value) => value == null ? 'Please select an option' : null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
