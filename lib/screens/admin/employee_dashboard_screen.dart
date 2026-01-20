import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../constants/app_colors.dart';
import '../../widgets/animated_section.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';

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
  int _selectedChip = 0;

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
    final chips = const ["Today", "This week", "This month"];
    final tasks = [
      {'title': 'Complete onboarding', 'status': 'In Progress', 'eta': '2h'},
      {'title': 'Update client report', 'status': 'Pending', 'eta': 'Today'},
      {'title': 'Team standup', 'status': 'Done', 'eta': '10:00'},
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            title: const Text('Employee'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(IconlyLight.notification),
              ),
              const SizedBox(width: 6),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 54, 16, 18),
                    child: AnimatedSection(
                      dy: 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitlesTextWidget(
                            label: "Your workday",
                            fontSize: 22,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Stay on top of tasks, meetings and performance",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  AnimatedSection(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(chips.length, (i) {
                        final selected = _selectedChip == i;
                        return ChoiceChip(
                          label: Text(chips[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedChip = i),
                          labelStyle: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.black : null,
                          ),
                          selectedColor: AppColors.primary,
                          backgroundColor: theme.cardColor.withValues(alpha: 0.6),
                          side: BorderSide(
                            color: theme.colorScheme.primary.withValues(alpha: 0.25),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSection(
                    dy: 0.08,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                theme,
                                'Hours',
                                '32',
                                Icons.schedule,
                                color: const Color(0xFF22D3EE),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                theme,
                                'Tasks',
                                '12',
                                Icons.check_circle,
                                color: const Color(0xFF4ADE80),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                theme,
                                'Meetings',
                                '4',
                                Icons.video_call,
                                color: const Color(0xFF6366F1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                theme,
                                'Clients',
                                '3',
                                Icons.people,
                                color: const Color(0xFFEC4899),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const TitlesTextWidget(label: "Tasks", fontSize: 18),
                  const SizedBox(height: 12),
                  ...tasks.map((task) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildTaskTile(task),
                      )),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    {required Color color,}
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.35),
                    color.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTile(Map<String, String> task) {
    final theme = Theme.of(context);
    final status = task['status'] ?? '';
    final eta = task['eta'] ?? '';
    final color = status == 'Done'
        ? AppColors.success
        : status == 'In Progress'
            ? AppColors.warning
            : AppColors.neutral;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withValues(alpha: 0.14),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Icon(Icons.task_alt, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'] ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: color.withValues(alpha: 0.14),
                        border: Border.all(color: color.withValues(alpha: 0.25)),
                      ),
                      child: Text(
                        status,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (eta.isNotEmpty)
                      SubtitleTextWidget(
                        label: "ETA: $eta",
                        fontSize: 12,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}

