import 'package:flutter/material.dart';

import '../models/business_profile.dart';


class CompanyNatureForm extends StatefulWidget {
  final BusinessProfile businessProfile;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CompanyNatureForm({
    super.key,
    required this.businessProfile,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<CompanyNatureForm> createState() => _CompanyNatureFormState();
}

class _CompanyNatureFormState extends State<CompanyNatureForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedNature = '';
  String _selectedDomain = '';
  final _targetAudienceController = TextEditingController();

  // Maps for company nature and domains
  final Map<String, List<String>> _domainsByNature = {
    'Primary': ['Agriculture', 'Mining', 'Forestry', 'Fishing', 'Hunting'],
    'Secondary': ['Manufacturing', 'Construction', 'Utilities'],
    'Tertiary': ['Retail', 'Transportation', 'Entertainment', 'Restaurants', 'Insurance', 'Banking', 'Healthcare', 'Education'],
    'Quaternary': ['Research', 'IT', 'Consulting', 'Information Services'],
    'Quinary': ['Government', 'Policy Making', 'Healthcare Management', 'Education Management'],
  };

  @override
  void initState() {
    super.initState();
    _selectedNature = widget.businessProfile.companyNature.isNotEmpty
        ? widget.businessProfile.companyNature
        : '';
    _selectedDomain = widget.businessProfile.companyDomain.isNotEmpty
        ? widget.businessProfile.companyDomain
        : '';
    _targetAudienceController.text = widget.businessProfile.targetAudience;
  }

  @override
  void dispose() {
    _targetAudienceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.businessProfile.companyNature = _selectedNature;
      widget.businessProfile.companyDomain = _selectedDomain;
      widget.businessProfile.targetAudience = _targetAudienceController.text;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Company Nature & Domain',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Company Nature Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Company Nature',
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedNature.isNotEmpty ? _selectedNature : null,
                hint: const Text('Select company nature'),
                items: _domainsByNature.keys.map((String nature) {
                  return DropdownMenuItem<String>(
                    value: nature,
                    child: Text(nature),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNature = newValue!;
                    // Reset domain when nature changes
                    _selectedDomain = '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select company nature';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Company Domain Dropdown (dependent on Nature)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Company Domain',
                  prefixIcon: Icon(Icons.domain),
                ),
                value: _selectedDomain.isNotEmpty ? _selectedDomain : null,
                hint: const Text('Select company domain'),
                items: _selectedNature.isNotEmpty
                    ? _domainsByNature[_selectedNature]!.map((String domain) {
                  return DropdownMenuItem<String>(
                    value: domain,
                    child: Text(domain),
                  );
                }).toList()
                    : [],
                onChanged: _selectedNature.isNotEmpty
                    ? (String? newValue) {
                  setState(() {
                    _selectedDomain = newValue!;
                  });
                }
                    : null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select company domain';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Target Audience
              TextFormField(
                controller: _targetAudienceController,
                decoration: const InputDecoration(
                  labelText: 'Target Audience',
                  prefixIcon: Icon(Icons.people),
                  hintText: 'Age, gender, location, etc.',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your target audience';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: widget.onPrevious,
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
