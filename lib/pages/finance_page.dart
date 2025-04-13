import 'package:flutter/material.dart';
import 'package:app_dev/auth/eval.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class FinancePage extends StatefulWidget {
  final BusinessProfile? businessProfile;

  const FinancePage({super.key, required this.businessProfile});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _itemNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _sourceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  String _selectedInvestmentType = 'bootstrap';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _itemNameController.dispose();
    _amountController.dispose();
    _sourceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addFinancialEntry() async {
    if (_itemNameController.text.isEmpty || _amountController.text.isEmpty) {
      context.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    try {
      final amount = double.parse(_amountController.text);
      final userId = supabase.auth.currentUser!.id;
      final id = const Uuid().v4();

      final entry = FinancialEntry(
        id: id,
        itemName: _itemNameController.text,
        amount: amount,
        date: DateTime.now(),
      );

      await supabase.from('financial_entries').insert({
        'id': entry.id,
        'user_id': userId,
        'item_name': entry.itemName,
        'amount': entry.amount,
        'date': entry.date.toIso8601String(),
      });

      setState(() {
        widget.businessProfile!.financialEntries.add(entry);
      });

      _itemNameController.clear();
      _amountController.clear();

      if (mounted) {
        context.showSnackBar('Entry added successfully');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error adding entry: $error', isError: true);
      }
    }
  }

  Future<void> _addInvestment() async {
    if (_sourceController.text.isEmpty || _amountController.text.isEmpty) {
      context.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    try {
      final amount = double.parse(_amountController.text);
      final userId = supabase.auth.currentUser!.id;
      final id = const Uuid().v4();

      final investment = Investment(
        id: id,
        source: _sourceController.text,
        amount: amount,
        date: DateTime.now(),
        type: _selectedInvestmentType,
      );

      await supabase.from('investments').insert({
        'id': investment.id,
        'user_id': userId,
        'source': investment.source,
        'amount': investment.amount,
        'date': investment.date.toIso8601String(),
        'type': investment.type,
      });

      setState(() {
        widget.businessProfile!.investments.add(investment);
      });

      _sourceController.clear();
      _amountController.clear();

      if (mounted) {
        context.showSnackBar('Investment added successfully');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error adding investment: $error', isError: true);
      }
    }
  }

  Future<void> _addExpense() async {
    if (_descriptionController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      context.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    try {
      final amount = double.parse(_amountController.text);
      final userId = supabase.auth.currentUser!.id;
      final id = const Uuid().v4();

      final expense = Expense(
        id: id,
        description: _descriptionController.text,
        amount: amount,
        date: DateTime.now(),
        category: _categoryController.text,
      );

      await supabase.from('expenses').insert({
        'id': expense.id,
        'user_id': userId,
        'description': expense.description,
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category,
      });

      setState(() {
        widget.businessProfile!.expenses.add(expense);
      });

      _descriptionController.clear();
      _amountController.clear();
      _categoryController.clear();

      if (mounted) {
        context.showSnackBar('Expense added successfully');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error adding expense: $error', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.businessProfile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial Summary Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Financial Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _SummaryItem(
                        title: 'Cash Flow',
                        value: '\$${widget.businessProfile!.cashFlow.toStringAsFixed(2)}',
                        icon: Icons.account_balance_wallet,
                        color: widget.businessProfile!.cashFlow >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      _SummaryItem(
                        title: 'Investments',
                        value: '\$${widget.businessProfile!.totalInvestment.toStringAsFixed(2)}',
                        icon: Icons.trending_up,
                        color: Colors.blue,
                      ),
                      _SummaryItem(
                        title: 'ROI',
                        value: '${widget.businessProfile!.roi.toStringAsFixed(2)}%',
                        icon: Icons.show_chart,
                        color: widget.businessProfile!.roi >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tabs for different financial entries
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Income'),
              Tab(text: 'Investments'),
              Tab(text: 'Expenses'),
            ],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Income Tab
                _buildIncomeTab(),

                // Investments Tab
                _buildInvestmentsTab(),

                // Expenses Tab
                _buildExpensesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addFinancialEntry,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.businessProfile!.financialEntries.isEmpty
              ? const Center(child: Text('No income entries yet'))
              : ListView.builder(
            itemCount: widget.businessProfile!.financialEntries.length,
            itemBuilder: (context, index) {
              final entry = widget.businessProfile!.financialEntries[index];
              return ListTile(
                title: Text(entry.itemName),
                subtitle: Text(DateFormat('MMM dd, yyyy').format(entry.date)),
                trailing: Text(
                  '\$${entry.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _sourceController,
                      decoration: const InputDecoration(
                        labelText: 'Source',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Investment Type',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedInvestmentType,
                      items: const [
                        DropdownMenuItem(value: 'bootstrap', child: Text('Bootstrap')),
                        DropdownMenuItem(value: 'loan', child: Text('Loan')),
                        DropdownMenuItem(value: 'external', child: Text('External Investment')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedInvestmentType = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addInvestment,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.businessProfile!.investments.isEmpty
              ? const Center(child: Text('No investments yet'))
              : ListView.builder(
            itemCount: widget.businessProfile!.investments.length,
            itemBuilder: (context, index) {
              final investment = widget.businessProfile!.investments[index];
              return ListTile(
                title: Text(investment.source),
                subtitle: Text(
                    '${DateFormat('MMM dd, yyyy').format(investment.date)} • ${investment.type.toUpperCase()}'
                ),
                trailing: Text(
                  '\$${investment.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount (\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addExpense,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.businessProfile!.expenses.isEmpty
              ? const Center(child: Text('No expenses yet'))
              : ListView.builder(
            itemCount: widget.businessProfile!.expenses.length,
            itemBuilder: (context, index) {
              final expense = widget.businessProfile!.expenses[index];
              return ListTile(
                title: Text(expense.description),
                subtitle: Text(
                    '${DateFormat('MMM dd, yyyy').format(expense.date)} • ${expense.category}'
                ),
                trailing: Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ],
    );
  }
}
