class ProviderModel {
  final String id;
  final String name;
  final String category;
  final String location;
  final String contact;

  ProviderModel({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.contact,
  });

  /// Convert model to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'contact': contact,
    };
  }

  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'category': category,
      'location': location,
      'contact': contact,
    };
  }

  /// Create model from Map
  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id']?.toString() ?? "",
      name: map['name']?.toString() ?? "",
      category: map['category']?.toString() ?? "",
      location: map['location']?.toString() ?? "",
      contact: map['contact']?.toString() ?? "",
    );
  }

  /// Convert model to JSON string
  String toJson() => toMap().toString();

  /// Create model from JSON map
  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel.fromMap(json);
  }

  /// Clone with new values
  ProviderModel copyWith({
    String? id,
    String? name,
    String? category,
    String? location,
    String? contact,
  }) {
    return ProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      contact: contact ?? this.contact,
    );
  }

  @override
  String toString() {
    return 'ProviderModel(id: $id, name: $name, category: $category, location: $location, contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProviderModel &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        other.location == location &&
        other.contact == contact;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        category.hashCode ^
        location.hashCode ^
        contact.hashCode;
  }
}
