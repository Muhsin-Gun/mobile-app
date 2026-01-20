import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  static const routName = "/EmployeeDashboardScreen";

  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = [
      {'title': 'Complete onboarding', 'status': 'In Progress'},
      {'title': 'Update client report', 'status': 'Pending'},
      {'title': 'Team standup', 'status': 'Done'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.notification),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _buildInfoCard(theme, 'Hours', '32', Icons.schedule)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoCard(theme, 'Tasks', '12', Icons.check_circle)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInfoCard(theme, 'Meetings', '4', Icons.video_call)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoCard(theme, 'Clients', '3', Icons.people)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Today',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...tasks.map((task) => _buildTaskTile(task)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.15),
              theme.colorScheme.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                Text(
                  value,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(Map<String, String> task) {
    final status = task['status'] ?? '';
    final color = status == 'Done'
        ? Colors.green
        : status == 'In Progress'
            ? Colors.orange
            : Colors.blueGrey;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.task_alt, color: color),
        ),
        title: Text(task['title'] ?? ''),
        subtitle: Text(status),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

