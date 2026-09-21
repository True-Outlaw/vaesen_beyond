class Facility {
  final String id;
  final String name;
  final String description;
  final String benefit;
  final bool isBuilt;
  final int devCost;

  const Facility({
    required this.id,
    required this.name,
    required this.description,
    required this.benefit,
    this.isBuilt = false,
    this.devCost = 2,
  });

  Facility copyWith({bool? isBuilt}) => Facility(
        id: id,
        name: name,
        description: description,
        benefit: benefit,
        isBuilt: isBuilt ?? this.isBuilt,
        devCost: devCost,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'benefit': benefit,
        'isBuilt': isBuilt,
        'devCost': devCost,
      };

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        benefit: json['benefit'] as String,
        isBuilt: json['isBuilt'] as bool? ?? false,
        devCost: json['devCost'] as int? ?? 2,
      );
}

class StaffMember {
  final String id;
  final String role;
  final String name;
  final String benefit;
  final bool isHired;

  const StaffMember({
    required this.id,
    required this.role,
    required this.name,
    required this.benefit,
    this.isHired = false,
  });

  StaffMember copyWith({bool? isHired, String? name}) => StaffMember(
        id: id,
        role: role,
        name: name ?? this.name,
        benefit: benefit,
        isHired: isHired ?? this.isHired,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role,
        'name': name,
        'benefit': benefit,
        'isHired': isHired,
      };

  factory StaffMember.fromJson(Map<String, dynamic> json) => StaffMember(
        id: json['id'] as String,
        role: json['role'] as String,
        name: json['name'] as String,
        benefit: json['benefit'] as String,
        isHired: json['isHired'] as bool? ?? false,
      );
}

class MysteryLog {
  final String id;
  final String title;
  final String date;
  final String summary;
  final int xpAwarded;

  const MysteryLog({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    this.xpAwarded = 3,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'summary': summary,
        'xpAwarded': xpAwarded,
      };

  factory MysteryLog.fromJson(Map<String, dynamic> json) => MysteryLog(
        id: json['id'] as String,
        title: json['title'] as String,
        date: json['date'] as String,
        summary: json['summary'] as String,
        xpAwarded: json['xpAwarded'] as int? ?? 3,
      );
}

class CastleState {
  final String name;
  final int developmentPoints;
  final List<Facility> facilities;
  final List<StaffMember> staff;
  final List<MysteryLog> mysteryLogs;

  const CastleState({
    this.name = 'Castle Gyllencreutz (Upsala)',
    this.developmentPoints = 2,
    this.facilities = const [],
    this.staff = const [],
    this.mysteryLogs = const [],
  });

  CastleState copyWith({
    String? name,
    int? developmentPoints,
    List<Facility>? facilities,
    List<StaffMember>? staff,
    List<MysteryLog>? mysteryLogs,
  }) =>
      CastleState(
        name: name ?? this.name,
        developmentPoints: developmentPoints ?? this.developmentPoints,
        facilities: facilities ?? this.facilities,
        staff: staff ?? this.staff,
        mysteryLogs: mysteryLogs ?? this.mysteryLogs,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'developmentPoints': developmentPoints,
        'facilities': facilities.map((f) => f.toJson()).toList(),
        'staff': staff.map((s) => s.toJson()).toList(),
        'mysteryLogs': mysteryLogs.map((m) => m.toJson()).toList(),
      };

  factory CastleState.fromJson(Map<String, dynamic> json) => CastleState(
        name: json['name'] as String? ?? 'Castle Gyllencreutz (Upsala)',
        developmentPoints: json['developmentPoints'] as int? ?? 2,
        facilities: (json['facilities'] as List<dynamic>? ?? [])
            .map((f) => Facility.fromJson(f as Map<String, dynamic>))
            .toList(),
        staff: (json['staff'] as List<dynamic>? ?? [])
            .map((s) => StaffMember.fromJson(s as Map<String, dynamic>))
            .toList(),
        mysteryLogs: (json['mysteryLogs'] as List<dynamic>? ?? [])
            .map((m) => MysteryLog.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}
