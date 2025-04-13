import 'package:flutter/material.dart';
import 'package:app_dev/auth/eval.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:app_dev/pages/finance_page.dart';
import 'package:app_dev/pages/report_dart.dart';
import 'package:app_dev/pages/milestones_page.dart';
import 'package:app_dev/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  BusinessProfile? _businessProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessProfile();
  }

  Future<void> _loadBusinessProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('business_profiles')
          .select()
          .eq('user_id', userId)
          .single();

      final profile = BusinessProfile()
        ..companyName = data['company_name'] ?? ''
        ..address = data['address'] ?? ''
        ..photoUrl = data['photo_url']
        ..companyNature = data['company_nature'] ?? ''
        ..companyDomain = data['company_domain'] ?? ''
        ..targetAudience = data['target_audience'] ?? ''
        ..businessType = data['business_type'] ?? '';

      // Load financial data
      final financialData = await supabase
          .from('financial_entries')
          .select()
          .eq('user_id', userId);

      profile.financialEntries = financialData
          .map<FinancialEntry>((entry) => FinancialEntry.fromJson(entry))
          .toList();

      // Load investments
      final investmentsData = await supabase
          .from('investments')
          .select()
          .eq('user_id', userId);

      profile.investments = investmentsData
          .map<Investment>((investment) => Investment.fromJson(investment))
          .toList();

      // Load expenses
      final expensesData = await supabase
          .from('expenses')
          .select()
          .eq('user_id', userId);

      profile.expenses = expensesData
          .map<Expense>((expense) => Expense.fromJson(expense))
          .toList();

      // Load milestones
      final milestonesData = await supabase
          .from('milestones')
          .select()
          .eq('user_id', userId);

      profile.milestones = milestonesData
          .map<Milestone>((milestone) => Milestone.fromJson(milestone))
          .toList();

      setState(() {
        _businessProfile = profile;
        _isLoading = false;
      });
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error loading profile: $error', isError: true);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FinancePage(businessProfile: _businessProfile),
      ReportsPage(businessProfile: _businessProfile),
      MilestonesPage(businessProfile: _businessProfile),
      ProfilePage(businessProfile: _businessProfile),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_businessProfile?.companyName ?? 'Business Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBusinessProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Finance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Milestones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
