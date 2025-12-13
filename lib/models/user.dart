enum UserRole { client, employee, admin }
enum SubscriptionTier { free, basic, premium, enterprise }

class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final UserRole role;
  final SubscriptionTier tier;
  final double balance;
  final double totalProfit;
  final double totalLoss;
  final int totalTrades;
  final int winningTrades;
  final List<String> watchlist;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.tier,
    required this.balance,
    required this.totalProfit,
    required this.totalLoss,
    required this.totalTrades,
    required this.winningTrades,
    required this.watchlist,
    required this.createdAt,
    this.lastLogin,
    required this.isActive,
  });

  double get winRate => totalTrades > 0 ? (winningTrades / totalTrades) * 100 : 0;
  double get netProfit => totalProfit - totalLoss;

  String get roleText {
    switch (role) {
      case UserRole.client: return 'Client';
      case UserRole.employee: return 'Employee';
      case UserRole.admin: return 'Administrator';
    }
  }

  String get tierText {
    switch (tier) {
      case SubscriptionTier.free: return 'Free';
      case SubscriptionTier.basic: return 'Basic';
      case SubscriptionTier.premium: return 'Premium';
      case SubscriptionTier.enterprise: return 'Enterprise';
    }
  }
}

class Transaction {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String? mpesaCode;
  final DateTime createdAt;
  final String? description;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    this.mpesaCode,
    required this.createdAt,
    this.description,
  });
}
