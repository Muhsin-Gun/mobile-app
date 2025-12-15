import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/education.dart';
import 'package:cryptex_trading/services/education_service.dart';

class EducationTab extends StatefulWidget {
  const EducationTab({super.key});

  @override
  State<EducationTab> createState() => _EducationTabState();
}

class _EducationTabState extends State<EducationTab> {
  final EducationService _educationService = EducationService();
  late List<Course> _courses;
  CourseCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _courses = _educationService.getAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCourses = _selectedCategory == null
        ? _courses
        : _courses.where((c) => c.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Text('Trading Education', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.secondaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Master Trading',
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Complete courses on ICT, SMC, SMT, and more professional trading strategies.',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.school, color: Colors.white, size: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip(null, 'All'),
                        _buildCategoryChip(CourseCategory.ict, 'ICT'),
                        _buildCategoryChip(CourseCategory.smc, 'SMC'),
                        _buildCategoryChip(CourseCategory.smt, 'SMT'),
                        _buildCategoryChip(CourseCategory.priceAction, 'Price Action'),
                        _buildCategoryChip(CourseCategory.orderFlow, 'Order Flow'),
                        _buildCategoryChip(CourseCategory.quant, 'Quant'),
                        _buildCategoryChip(CourseCategory.riskManagement, 'Risk'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Available Courses',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= filteredCourses.length) return null;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CourseCard(
                      course: filteredCourses[index],
                      onTap: () => _openCourse(filteredCourses[index]),
                    ),
                  );
                },
                childCount: filteredCourses.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(CourseCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.darkBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _openCourse(Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _CourseCard({required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(course.category).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_getCategoryIcon(course.category), color: _getCategoryColor(course.category)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.categoryText,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (course.isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('PRO', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              course.description,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  '${(course.durationMinutes / 60).round()}h',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.menu_book, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  '${course.lessons.length} lessons',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  course.rating.toStringAsFixed(1),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                ),
                const Spacer(),
                Text(
                  course.difficultyText,
                  style: TextStyle(color: _getDifficultyColor(course.difficulty), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(CourseCategory category) {
    switch (category) {
      case CourseCategory.ict: return AppColors.primary;
      case CourseCategory.smc: return AppColors.secondary;
      case CourseCategory.smt: return AppColors.accent;
      case CourseCategory.orderFlow: return AppColors.warning;
      case CourseCategory.priceAction: return AppColors.info;
      case CourseCategory.quant: return Colors.purple;
      case CourseCategory.fundamental: return Colors.orange;
      case CourseCategory.psychology: return Colors.pink;
      case CourseCategory.riskManagement: return Colors.teal;
      case CourseCategory.msnr: return Colors.cyan;
      case CourseCategory.crt: return Colors.amber;
      case CourseCategory.domFootprint: return Colors.indigo;
      case CourseCategory.sniperEntry: return Colors.red;
      case CourseCategory.exitStrategies: return Colors.lime;
    }
  }

  IconData _getCategoryIcon(CourseCategory category) {
    switch (category) {
      case CourseCategory.ict: return Icons.insights;
      case CourseCategory.smc: return Icons.trending_up;
      case CourseCategory.smt: return Icons.compare_arrows;
      case CourseCategory.orderFlow: return Icons.waterfall_chart;
      case CourseCategory.priceAction: return Icons.candlestick_chart;
      case CourseCategory.quant: return Icons.calculate;
      case CourseCategory.fundamental: return Icons.analytics;
      case CourseCategory.psychology: return Icons.psychology;
      case CourseCategory.riskManagement: return Icons.shield;
      case CourseCategory.msnr: return Icons.account_tree;
      case CourseCategory.crt: return Icons.layers;
      case CourseCategory.domFootprint: return Icons.bar_chart;
      case CourseCategory.sniperEntry: return Icons.my_location;
      case CourseCategory.exitStrategies: return Icons.exit_to_app;
    }
  }

  Color _getDifficultyColor(DifficultyLevel level) {
    switch (level) {
      case DifficultyLevel.beginner: return AppColors.bullish;
      case DifficultyLevel.intermediate: return AppColors.warning;
      case DifficultyLevel.advanced: return AppColors.secondary;
      case DifficultyLevel.expert: return AppColors.bearish;
    }
  }
}

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Text(course.title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: course.lessons.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(course.description, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 18),
                      const SizedBox(width: 4),
                      Text('${course.rating}', style: const TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      Text('${course.enrolledCount} students', style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                    ],
                  ),
                ],
              ),
            );
          }

          final lesson = course.lessons[index - 1];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              childrenPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${lesson.orderIndex}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              title: Text(lesson.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${lesson.durationMinutes} min',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white.withValues(alpha: 0.5),
              children: [
                Text(
                  lesson.content,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), height: 1.6),
                ),
                if (lesson.keyPoints.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Key Points:', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...lesson.keyPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(point, style: TextStyle(color: Colors.white.withValues(alpha: 0.7)))),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
