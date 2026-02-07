class PetModel {
  final String id;
  final String name;
  final String description;
  final String type; // 'mouse', 'stone', 'ice', 'todo', 'rabbit', 'custom'
  bool isActive;
  bool isUnlocked;
  Map<String, dynamic> data;
  
  // Custom pet fields
  final bool isCustom;
  final String? imagePath;
  final String? birthday; // Format: "MM-DD"
  final String? personality; // AI-generated personality prompt
  final String? marqueeText; // Custom marquee text for pet display

  PetModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isActive = false,
    this.isUnlocked = false,
    this.data = const {},
    this.isCustom = false,
    this.imagePath,
    this.birthday,
    this.personality,
    this.marqueeText,
  });

  PetModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    bool? isActive,
    bool? isUnlocked,
    Map<String, dynamic>? data,
    bool? isCustom,
    String? imagePath,
    String? birthday,
    String? personality,
    String? marqueeText,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      data: data ?? this.data,
      isCustom: isCustom ?? this.isCustom,
      imagePath: imagePath ?? this.imagePath,
      birthday: birthday ?? this.birthday,
      personality: personality ?? this.personality,
      marqueeText: marqueeText ?? this.marqueeText,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type,
    'isActive': isActive,
    'isUnlocked': isUnlocked,
    'data': data,
    'isCustom': isCustom,
    'imagePath': imagePath,
    'birthday': birthday,
    'personality': personality,
    'marqueeText': marqueeText,
  };

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      isActive: json['isActive'] ?? false,
      isUnlocked: json['isUnlocked'] ?? false,
      data: json['data'] ?? {},
      isCustom: json['isCustom'] ?? false,
      imagePath: json['imagePath'],
      birthday: json['birthday'],
      personality: json['personality'],
      marqueeText: json['marqueeText'],
    );
  }
}
