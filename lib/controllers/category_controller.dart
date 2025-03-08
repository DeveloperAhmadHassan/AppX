import 'package:dio/dio.dart';
import 'package:heroapp/models/category.dart';
import '../models/reel.dart';

class CategoryController {
  final Dio _dio = Dio();
  final String _categoriesUrl = 'https://appx-api.vercel.app/api/categories';
  final String _reelsByCategoriesUrl = 'https://appx-api.vercel.app/api/reels/category';


  CategoryController(Dio dio);

  Future<Map<String, dynamic>> fetchCategories(int page) async {
    try {
      final response = await _dio.get(
        _categoriesUrl,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Category> categories = await Future.wait(data.map((e) async {
          Category category = Category.fromJson(e);
          return category;
        }).toList());

        Map<String, dynamic> pagination = response.data['pagination'];

        return {'categories': categories, 'pagination': pagination};
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchReelsByCategory(int page, String category) async {
    try {
      final response = await _dio.get(
        "$_reelsByCategoriesUrl/$category",
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Reel> reels = await Future.wait(data.map((e) async {
          Reel reel = Reel.fromJson(e);
          return reel;
        }).toList());

        Map<String, dynamic> pagination = response.data['pagination'];

        return {'reels': reels, 'pagination': pagination};
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

