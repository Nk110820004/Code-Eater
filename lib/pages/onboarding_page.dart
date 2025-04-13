import 'package:flutter/material.dart';
import 'package:app_dev/forms/company_info_form.dart';
import 'package:app_dev/forms/company_nature_form.dart';
import 'package:app_dev/forms/business_type_form.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:app_dev/pages/dashboard_page.dart';
import 'package:app_dev/auth/eval.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final BusinessProfile _businessProfile = BusinessProfile();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _saveBusinessProfile();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _saveBusinessProfile() async {
    try {
      // Create a user account if not already logged in
      if (supabase.auth.currentSession == null) {
        final email = '${_businessProfile.companyName.replaceAll(' ', '_').toLowerCase()}@example.com';
        final password = 'password123'; // In a real app, you'd generate this or ask the user

        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user == null) {
          if (mounted) {
            context.showSnackBar('Failed to create account', isError: true);
          }
          return;
        }
      }

      final userId = supabase.auth.currentUser!.id;

      // Save business profile to Supabase
      await supabase.from('business_profiles').upsert({
        'user_id': userId,
        'company_name': _businessProfile.companyName,
        'address': _businessProfile.address,
        'company_nature': _businessProfile.companyNature,
        'company_domain': _businessProfile.companyDomain,
        'target_audience': _businessProfile.targetAudience,
        'business_type': _businessProfile.businessType,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error saving profile: $error', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Setup'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: Colors.grey.shade200,
            color: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CompanyInfoForm(
                  businessProfile: _businessProfile,
                  onNext: _nextPage,
                ),
                CompanyNatureForm(
                  businessProfile: _businessProfile,
                  onNext: _nextPage,
                  onPrevious: _previousPage,
                ),
                BusinessTypeForm(
                  businessProfile: _businessProfile,
                  onNext: _nextPage,
                  onPrevious: _previousPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
