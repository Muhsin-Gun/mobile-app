enum CourseCategory { ict, smc, smt, quant, fundamental, priceAction, orderFlow, psychology, riskManagement }
enum ContentType { video, article, quiz, interactive }
enum DifficultyLevel { beginner, intermediate, advanced, expert }

class Course {
  final String id;
  final String title;
  final String description;
  final CourseCategory category;
  final DifficultyLevel difficulty;
  final List<Lesson> lessons;
  final String? thumbnail;
  final int durationMinutes;
  final double rating;
  final int enrolledCount;
  final bool isPremium;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.lessons,
    this.thumbnail,
    required this.durationMinutes,
    required this.rating,
    required this.enrolledCount,
    required this.isPremium,
  });

  String get categoryText {
    switch (category) {
      case CourseCategory.ict: return 'ICT - Inner Circle Trader';
      case CourseCategory.smc: return 'Smart Money Concepts';
      case CourseCategory.smt: return 'SMT Divergence';
      case CourseCategory.quant: return 'Quantitative Trading';
      case CourseCategory.fundamental: return 'Fundamental Analysis';
      case CourseCategory.priceAction: return 'Price Action';
      case CourseCategory.orderFlow: return 'Order Flow';
      case CourseCategory.psychology: return 'Trading Psychology';
      case CourseCategory.riskManagement: return 'Risk Management';
    }
  }

  String get difficultyText {
    switch (difficulty) {
      case DifficultyLevel.beginner: return 'Beginner';
      case DifficultyLevel.intermediate: return 'Intermediate';
      case DifficultyLevel.advanced: return 'Advanced';
      case DifficultyLevel.expert: return 'Expert';
    }
  }
}

class Lesson {
  final String id;
  final String title;
  final String content;
  final ContentType type;
  final int durationMinutes;
  final int orderIndex;
  final List<String> keyPoints;
  final String? videoUrl;
  final bool isCompleted;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.durationMinutes,
    required this.orderIndex,
    required this.keyPoints,
    this.videoUrl,
    this.isCompleted = false,
  });
}

class TradingConcept {
  final String id;
  final String name;
  final String category;
  final String definition;
  final String explanation;
  final List<String> examples;
  final List<String> tradingRules;
  final String? imageUrl;

  TradingConcept({
    required this.id,
    required this.name,
    required this.category,
    required this.definition,
    required this.explanation,
    required this.examples,
    required this.tradingRules,
    this.imageUrl,
  });
}
