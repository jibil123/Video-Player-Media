// category_model.dart
class CategoryResponse {
  final bool? status;
  final List<Category>? categories;

  CategoryResponse({this.status, this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    var categoriesList = json['categories'] as List?;
    List<Category>? categories = categoriesList?.map((e) => Category.fromJson(e)).toList();

    return CategoryResponse(
      status: json['status'],
      categories: categories,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}

class Category {
  final int? id;
  final String? title;
  final String? image;

  Category({this.id, this.title, this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
      };
}
