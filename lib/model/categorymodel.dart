class CategoryModel {
  final String id;
  final String name;
  final String description;
  final List<dynamic> items;
  final DateTime createdDate;
  final DateTime lastModifiedDate;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  // Factory constructor to create a CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']['\$oid'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      items: json['item'] ?? [],
      createdDate: DateTime.fromMillisecondsSinceEpoch(json['createInfo']['created_date']['\$date']),
      lastModifiedDate: DateTime.fromMillisecondsSinceEpoch(json['updateInfo']['last_modified_date']['\$date']),
    );
  }

  // Method to convert CategoryModel to a map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      '_id': {
        '\$oid': id,
      },
      'name': name,
      'description': description,
      'item': items,
      'createInfo': {
        'created_date': {'\$date': createdDate.millisecondsSinceEpoch},
      },
      'updateInfo': {
        'last_modified_date': {'\$date': lastModifiedDate.millisecondsSinceEpoch},
      },
    };
  }
}
