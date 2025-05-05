
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Registerpatient extends StatefulWidget {
  const Registerpatient({super.key});

  @override
  _RegisterpatientState createState() => _RegisterpatientState();
}

class _RegisterpatientState extends State<Registerpatient> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _chronicDisease;
  String? _allergy;
  String? _medication;
  String? _familyHistory;

  final List<String> chronicDiseases = [
    'None',
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Arthritis',
  ];
  final List<String> allergies = [
    'None',
    'Peanuts',
    'Pollen',
    'Dust Mites',
    'Penicillin',
    'Shellfish',
  ];
  final List<String> medications = [
    'None',
    'Insulin',
    'Aspirin',
    'Albuterol',
    'Lisinopril',
    'Metformin',
  ];
  final List<String> familyHistory = [
    'None',
    'Cancer',
    'Diabetes',
    'Heart Disease',
    'Hypertension',
    'Stroke',
  ];

  static const double _formPadding = 16.0;
  static const double _formSpacing = 20.0;

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

  void _submitForm() {
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
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Survey Summary'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${surveyData.name}'),
                    Text('National ID: ${surveyData.nationalId}'),
                    Text(
                      'Date of Birth: ${DateFormat('yyyy-MM-dd').format(surveyData.dateOfBirth)}',
                    ),
                    Text('Phone: ${surveyData.phone}'),
                    Text('Chronic Disease: ${surveyData.chronicDisease}'),
                    Text('Allergy: ${surveyData.allergy}'),
                    Text('Medication: ${surveyData.medication}'),
                    Text('Family History: ${surveyData.familyHistory}'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Survey submitted successfully!')),
      );
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
        padding: const EdgeInsets.all(_formPadding),
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
              const SizedBox(height: _formSpacing),
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
        if (!RegExp(r'^\d{16}$').hasMatch(value))
          return 'National ID must be 16 digits';
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    final hasError =
        _selectedDate == null &&
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
        if (!RegExp(r'^\d{11}$').hasMatch(value))
          return 'Phone number must be 11 digits';
        return null;
      },
    );
  }

  Widget _buildChronicDiseaseField() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Chronic Diseases'),
      value: _chronicDisease,
      items:
          chronicDiseases.map((String disease) {
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
      items:
          allergies.map((String allergy) {
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
      items:
          medications.map((String medication) {
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
      items:
          familyHistory.map((String history) {
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

// Add model class for survey data
class SurveyData {
  final String name;
  final String nationalId;
  final DateTime dateOfBirth;
  final String phone;
  final String chronicDisease;
  final String allergy;
  final String medication;
  final String familyHistory;

  SurveyData({
    required this.name,
    required this.nationalId,
    required this.dateOfBirth,
    required this.phone,
    required this.chronicDisease,
    required this.allergy,
    required this.medication,
    required this.familyHistory,
  });
}