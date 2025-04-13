import 'package:flutter/material.dart';
import 'package:app_dev/auth/eval.dart';
import 'package:app_dev/models/business_profile.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class MilestonesPage extends StatefulWidget {
  final BusinessProfile? businessProfile;

  const MilestonesPage({super.key, required this.businessProfile});

  @override
  State<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addMilestone() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      context.showSnackBar('Please fill all fields', isError: true);
      return;
    }

    try {
      final userId = supabase.auth.currentUser!.id;
      final id = const Uuid().v4();

      final milestone = Milestone(
        id: id,
        title: _titleController.text,
        description: _descriptionController.text,
        targetDate: _selectedDate,
      );

      await supabase.from('milestones').insert({
        'id': milestone.id,
        'user_id': userId,
        'title': milestone.title,
        'description': milestone.description,
        'target_date': milestone.targetDate.toIso8601String(),
        'is_completed': milestone.isCompleted,
      });

      setState(() {
        widget.businessProfile!.milestones.add(milestone);
      });

      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDate = DateTime.now().add(const Duration(days: 30));
      });

      if (mounted) {
        context.showSnackBar('Milestone added successfully');
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error adding milestone: $error', isError: true);
      }
    }
  }

  Future<void> _toggleMilestoneStatus(Milestone milestone) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('milestones').update({
        'is_completed': !milestone.isCompleted,
      }).eq('id', milestone.id).eq('user_id', userId);

      setState(() {
        milestone.isCompleted = !milestone.isCompleted;
      });

      if (mounted) {
        context.showSnackBar(
            milestone.isCompleted
                ? 'Milestone marked as completed'
                : 'Milestone marked as pending'
        );
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Error updating milestone: $error', isError: true);
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
          const Text(
            'Business Milestones',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Add Milestone Form
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Milestone',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Target Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Change Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addMilestone,
                      child: const Text('Add Milestone'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Milestones List
          const Text(
            'Your Milestones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: widget.businessProfile!.milestones.isEmpty
                ? const Center(child: Text('No milestones yet'))
                : ListView.builder(
              itemCount: widget.businessProfile!.milestones.length,
              itemBuilder: (context, index) {
                final milestone = widget.businessProfile!.milestones[index];
                final isOverdue = !milestone.isCompleted &&
                    milestone.targetDate.isBefore(DateTime.now());

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: milestone.isCompleted
                      ? Colors.green.shade50
                      : isOverdue
                      ? Colors.red.shade50
                      : null,
                  child: ListTile(
                    title: Text(
                      milestone.title,
                      style: TextStyle(
                        decoration: milestone.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(milestone.description),
                        const SizedBox(height: 4),
                        Text(
                          'Target: ${DateFormat('MMM dd, yyyy').format(milestone.targetDate)}',
                          style: TextStyle(
                            color: isOverdue ? Colors.red : Colors.grey.shade700,
                            fontWeight: isOverdue ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        milestone.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: milestone.isCompleted
                            ? Colors.green
                            : isOverdue
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () => _toggleMilestoneStatus(milestone),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
