import 'package:dio/dio.dart';
import '../models/reel.dart';

class HomeReelController {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://appx-api.vercel.app/api/reels';

  HomeReelController(Dio dio);

  Future<Map<String, dynamic>> fetchReels(int page) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<Reel> reels = data.map((e) => Reel.fromJson(e)).toList();

        Map<String, dynamic> pagination = response.data['pagination'];

        return {'reels': reels, 'pagination': pagination};
      } else {
        throw Exception('Failed to load reels');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> likeVideo(String id) async {
    try {
      final response = await _dio.put('$_baseUrl/likes/$id');

      if (response.statusCode == 200) {
        print("liked");
        return true;
      } else {
        throw Exception('Failed to load reel data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> unlikeVideo(String id) async {
    try {
      final response = await _dio.put('$_baseUrl/likes/$id?increment=-1');

      if (response.statusCode == 200) {
        print("unliked");
        return true;
      } else {
        throw Exception('Failed to load reel data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
