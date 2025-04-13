import 'package:flutter/material.dart';
import 'package:app_dev/auth/eval.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:app_dev/pages/onboarding_page.dart';

class ProfilePage extends StatefulWidget {
  final BusinessProfile? businessProfile;

  const ProfilePage({super.key, required this.businessProfile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  String _selectedNature = '';
  String _selectedDomain = '';
  String _selectedBusinessType = '';
  bool _isLoading = false;

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
    _loadProfileData();
  }

  void _loadProfileData() {
    if (widget.businessProfile != null) {
      _companyNameController.text = widget.businessProfile!.companyName;
      _addressController.text = widget.businessProfile!.address;
      _targetAudienceController.text = widget.businessProfile!.targetAudience;
      _selectedNature = widget.businessProfile!.companyNature;
      _selectedDomain = widget.businessProfile!.companyDomain;
      _selectedBusinessType = widget.businessProfile!.businessType;
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _targetAudienceController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_companyNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _targetAudienceController.text.isEmpty ||
        _selectedNature.isEmpty ||
        _selectedDomain.isEmpty ||
        _selectedBusinessType.isEmpty) {
      context.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('business_profiles').update({
        'company_name': _companyNameController.text,
        'address': _addressController.text,
        'company_nature': _selectedNature,
        'company_domain': _selectedDomain,
        'target_audience': _targetAudienceController.text,
        'business_type': _selectedBusinessType,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);

      if (widget.businessProfile != null) {
        setState(() {
          widget.businessProfile!.companyName = _companyNameController.text;
          widget.businessProfile!.address = _addressController.text;
          widget.businessProfile!.companyNature = _selectedNature;
          widget.businessProfile!.companyDomain = _selectedDomain;
          widget.businessProfile!.targetAudience = _targetAudienceController.text;
          widget.businessProfile!.businessType = _selectedBusinessType;
        });
      }

      if (mounted) {
        context.showSnackBar('Profile updated successfully');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error updating profile: $error', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error signing out: $error', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.businessProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Company Information
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Company Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _companyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Business Classification
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Business Classification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Company Nature',
                      border: OutlineInputBorder(),
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
                        if (!_domainsByNature[_selectedNature]!.contains(_selectedDomain)) {
                          _selectedDomain = '';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Company Domain',
                      border: OutlineInputBorder(),
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
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _targetAudienceController,
                    decoration: const InputDecoration(
                      labelText: 'Target Audience',
                      border: OutlineInputBorder(),
                      hintText: 'Age, gender, location, etc.',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Business Type
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Business Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Business Type',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedBusinessType.isNotEmpty ? _selectedBusinessType : null,
                    hint: const Text('Select business type'),
                    items: const [
                      DropdownMenuItem(value: 'New Business', child: Text('New Business')),
                      DropdownMenuItem(value: 'Upscale Business', child: Text('Upscale Business')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBusinessType = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Update Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Update Profile'),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sign Out Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _signOut,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Sign Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
