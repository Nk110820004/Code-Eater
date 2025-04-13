class BusinessProfile {
  String companyName = '';
  String address = '';
  String? photoUrl;

  String companyNature = ''; // primary, secondary, tertiary, quaternary, quinary
  String companyDomain = ''; // specific domain based on nature
  String targetAudience = ''; // age, gender, city, etc.

  String businessType = ''; // New business or Upscale business

  // Financial tracking
  List<FinancialEntry> financialEntries = [];
  List<Investment> investments = [];
  List<Expense> expenses = [];
  List<Milestone> milestones = [];

  double get totalInvestment {
    return investments.fold(0, (sum, item) => sum + item.amount);
  }

  double get totalExpenses {
    return expenses.fold(0, (sum, item) => sum + item.amount);
  }

  double get cashFlow {
    final income = financialEntries.fold(0.0, (sum, item) => sum + item.amount);
    return income - totalExpenses;
  }

  double get roi {
    if (totalInvestment == 0) return 0;
    return (cashFlow / totalInvestment) * 100;
  }
}

class FinancialEntry {
  String id;
  String itemName;
  double amount;
  DateTime date;

  FinancialEntry({
    required this.id,
    required this.itemName,
    required this.amount,
    required this.date,
  });

  factory FinancialEntry.fromJson(Map<String, dynamic> json) {
    return FinancialEntry(
      id: json['id'],
      itemName: json['item_name'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

class Investment {
  String id;
  String source;
  double amount;
  DateTime date;
  String type; // bootstrap, loan, external investment

  Investment({
    required this.id,
    required this.source,
    required this.amount,
    required this.date,
    required this.type,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      source: json['source'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}

class Expense {
  String id;
  String description;
  double amount;
  DateTime date;
  String category;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }
}

class Milestone {
  String id;
  String title;
  String description;
  DateTime targetDate;
  bool isCompleted;

  Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    this.isCompleted = false,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      targetDate: DateTime.parse(json['target_date']),
      isCompleted: json['is_completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_date': targetDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }
}
