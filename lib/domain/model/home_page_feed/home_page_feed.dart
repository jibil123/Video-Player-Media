// home_response_model.dart

class HomeResponse {
  final User? user;
  final List<BannerItem>? banners;
  final List<CategoryDict>? categoryDict;
  final List<Result>? results;
  final bool? status;
  final bool? next;

  HomeResponse({
    this.user,
    this.banners,
    this.categoryDict,
    this.results,
    this.status,
    this.next,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    try {
      return HomeResponse(
        user: json['user'] != null ? _parseUser(json['user']) : null,
        banners: json['banners'] != null ? _parseBanners(json['banners']) : null,
        categoryDict: json['category_dict'] != null 
            ? _parseCategoryDict(json['category_dict']) 
            : null,
        results: json['results'] != null ? _parseResults(json['results']) : null,
        status: json['status'],
        next: json['next'],
      );
    } catch (e) {
      print('HomeResponse parsing error: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  static User? _parseUser(dynamic userData) {
    try {
      if (userData is Map<String, dynamic>) {
        return User.fromJson(userData);
      } else if (userData is List) {
        if (userData.isEmpty) {
          return null;
        }
        // Handle case where user is wrapped in array
        final firstElement = userData[0];
        if (firstElement is Map<String, dynamic>) {
          return User.fromJson(firstElement);
        }
      }
      return null;
    } catch (e) {
      print('Error parsing user: $e');
      return null;
    }
  }

  static List<BannerItem>? _parseBanners(dynamic bannersData) {
    try {
      if (bannersData is! List) {
        print('Banners is not a list: ${bannersData.runtimeType}');
        return null;
      }
      return (bannersData as List)
          .map((e) {
            if (e is Map<String, dynamic>) {
              return BannerItem.fromJson(e);
            }
            print('Banner item is not a Map: ${e.runtimeType}');
            return BannerItem();
          })
          .toList();
    } catch (e) {
      print('Error parsing banners: $e');
      return null;
    }
  }

  static List<CategoryDict>? _parseCategoryDict(dynamic categoryData) {
    try {
      if (categoryData is! List) {
        print('CategoryDict is not a list: ${categoryData.runtimeType}');
        return null;
      }
      return (categoryData as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => CategoryDict.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing category_dict: $e');
      return null;
    }
  }

  static List<Result>? _parseResults(dynamic resultsData) {
    try {
      if (resultsData is! List) {
        print('Results is not a list: ${resultsData.runtimeType}');
        return null;
      }
      return (resultsData as List)
          .where((e) => e is Map<String, dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing results: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'banners': banners?.map((e) => e.toJson()).toList(),
        'category_dict': categoryDict?.map((e) => e.toJson()).toList(),
        'results': results?.map((e) => e.toJson()).toList(),
        'status': status,
        'next': next,
      };
}

class User {
  final int? id;
  final String? uniqueId;
  final String? name;
  final String? phone;
  final String? image;
  final int? coins;
  final dynamic credit;
  final dynamic debit;

  User({
    this.id,
    this.uniqueId,
    this.name,
    this.phone,
    this.image,
    this.coins,
    this.credit,
    this.debit,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'],
        uniqueId: json['unique_id'],
        name: json['name'],
        phone: json['phone'],
        image: json['image'],
        coins: json['coins'],
        credit: json['credit'],
        debit: json['debit'],
      );
    } catch (e) {
      print('User parsing error: $e');
      print('User JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'unique_id': uniqueId,
        'name': name,
        'phone': phone,
        'image': image,
        'coins': coins,
        'credit': credit,
        'debit': debit,
      };
}

class BannerItem {
  BannerItem();

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem();

  Map<String, dynamic> toJson() => {};
}

class CategoryDict {
  final String? id;
  final String? title;

  CategoryDict({this.id, this.title});

  factory CategoryDict.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryDict(
        id: json['id']?.toString(),
        title: json['title']?.toString(),
      );
    } catch (e) {
      print('CategoryDict parsing error: $e');
      print('CategoryDict JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}

class Result {
  final int? id;
  final String? description;
  final String? image;
  final String? video;
  final List<int>? likes;
  final List<int>? dislikes;
  final List<int>? bookmarks;
  final List<int>? hide;
  final String? createdAt;
  final bool? follow;
  final SimpleUser? user;

  Result({
    this.id,
    this.description,
    this.image,
    this.video,
    this.likes,
    this.dislikes,
    this.bookmarks,
    this.hide,
    this.createdAt,
    this.follow,
    this.user,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    try {
      return Result(
        id: json['id'],
        description: json['description'],
        image: json['image'],
        video: json['video'],
        likes: json['likes'] != null ? List<int>.from(json['likes']) : null,
        dislikes: json['dislikes'] != null ? List<int>.from(json['dislikes']) : null,
        bookmarks: json['bookmarks'] != null ? List<int>.from(json['bookmarks']) : null,
        hide: json['hide'] != null ? List<int>.from(json['hide']) : null,
        createdAt: json['created_at'],
        follow: json['follow'],
        user: json['user'] != null ? _parseSimpleUser(json['user']) : null,
      );
    } catch (e) {
      print('Result parsing error: $e');
      print('Result JSON: $json');
      rethrow;
    }
  }

  static SimpleUser? _parseSimpleUser(dynamic userData) {
    try {
      if (userData is Map<String, dynamic>) {
        return SimpleUser.fromJson(userData);
      } else if (userData is List && userData.isNotEmpty) {
        return SimpleUser.fromJson(userData[0] as Map<String, dynamic>);
      }
      print('Unexpected SimpleUser data type: ${userData.runtimeType}');
      return null;
    } catch (e) {
      print('Error parsing SimpleUser: $e');
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'image': image,
        'video': video,
        'likes': likes,
        'dislikes': dislikes,
        'bookmarks': bookmarks,
        'hide': hide,
        'created_at': createdAt,
        'follow': follow,
        'user': user?.toJson(),
      };
}

class SimpleUser {
  final int? id;
  final String? name;
  final String? image;

  SimpleUser({this.id, this.name, this.image});

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    try {
      return SimpleUser(
        id: json['id'],
        name: json['name'],
        image: json['image'],
      );
    } catch (e) {
      print('SimpleUser parsing error: $e');
      print('SimpleUser JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
      };
}