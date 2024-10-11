class CategoryModel {
  final String name;

  CategoryModel({
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commerceCategoryName': name,
    };
  }
}