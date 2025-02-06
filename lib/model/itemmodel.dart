class ItemModel {
  final String id;
  final String name;
  final String price;
  final String categoryId;
  final String categoryRef;

  ItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.categoryRef,
  });

  // Factory constructor to create an ItemModel from JSON
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['_id']['\$oid'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      categoryId: json['category']['_id']['\$oid'] ?? '',
      categoryRef: json['category']['_ref'] ?? '',
    );
  }

  // Method to convert ItemModel to a map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      '_id': {
        '\$oid': id,
      },
      'name': name,
      'price': price,
      'category': {
        '_id': {
          '\$oid': categoryId,
        },
        '_ref': categoryRef,
      },
    };
  }
}
