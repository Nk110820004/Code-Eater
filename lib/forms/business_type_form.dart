import 'package:flutter/material.dart';
import 'package:app_dev/models/business_profile.dart';

class BusinessTypeForm extends StatefulWidget {
  final BusinessProfile businessProfile;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const BusinessTypeForm({
    super.key,
    required this.businessProfile,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<BusinessTypeForm> createState() => _BusinessTypeFormState();
}

class _BusinessTypeFormState extends State<BusinessTypeForm> {
  String _selectedBusinessType = '';

  @override
  void initState() {
    super.initState();
    _selectedBusinessType = widget.businessProfile.businessType;
  }

  void _submitForm() {
    if (_selectedBusinessType.isNotEmpty) {
      widget.businessProfile.businessType = _selectedBusinessType;
      widget.onNext();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a business type'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Business Type',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          const Text(
            'Select your business type:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Business Type Selection Cards
          Row(
            children: [
              Expanded(
                child: _BusinessTypeCard(
                  title: 'New Business',
                  icon: Icons.add_business,
                  description: 'Starting a new business venture',
                  isSelected: _selectedBusinessType == 'New Business',
                  onTap: () {
                    setState(() {
                      _selectedBusinessType = 'New Business';
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _BusinessTypeCard(
                  title: 'Upscale Business',
                  icon: Icons.trending_up,
                  description: 'Growing an existing business',
                  isSelected: _selectedBusinessType == 'Upscale Business',
                  onTap: () {
                    setState(() {
                      _selectedBusinessType = 'Upscale Business';
                    });
                  },
                ),
              ),
            ],
          ),

          const Spacer(),

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
                child: const Text('Finish'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BusinessTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _BusinessTypeCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 64,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
