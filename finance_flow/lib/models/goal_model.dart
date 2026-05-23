class GoalModel {
  final String id;
  final String name;
  final String subtitle;
  final double targetAmount;
  final double savedAmount;
  final String iconId;
  final int colorValue;

  GoalModel({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.targetAmount,
    required this.savedAmount,
    this.iconId = 'savings',
    this.colorValue = 0xFF98DA27,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'target_amount': targetAmount,
      'saved_amount': savedAmount,
      'icon_id': iconId,
      'color_value': colorValue,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      name: map['name'],
      subtitle: map['subtitle'] ?? '',
      targetAmount: map['target_amount'],
      savedAmount: map['saved_amount'],
      iconId: map['icon_id'] ?? 'savings',
      colorValue: map['color_value'] ?? 0xFF98DA27,
    );
  }

  double get progress {
    if (targetAmount == 0) return 0;
    return (savedAmount / targetAmount).clamp(0.0, 1.0);
  }

  int get progressPercent => (progress * 100).round();
  double get remaining => (targetAmount - savedAmount).clamp(0, double.infinity);

  GoalModel copyWith({
    String? id, String? name, String? subtitle,
    double? targetAmount, double? savedAmount,
    String? iconId, int? colorValue,
  }) {
    return GoalModel(
      id: id ?? this.id, name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      iconId: iconId ?? this.iconId,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
