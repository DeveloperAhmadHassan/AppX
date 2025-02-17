import 'package:dio/dio.dart';
import 'package:heroapp/models/reel.dart';

class CarouselReelController {
  final Dio _dio;
  final String _baseUrl = 'http://192.168.0.119:3000/api/reels';
  List<Reel> reels = [];

  CarouselReelController(this._dio);

  Future<List<Reel>> fetchReelsData() async {
    try {
      final response = await _dio.get('$_baseUrl/carousel');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        reels = jsonData.map((data) {
          return Reel(
            data['reel_url'],
            title: data['reel_title'],
            views: data['views'].toString(),
            likes: data['likes'].toString(),
            id: data['id'].toString(),
            thumbnailUrl: data['reel_thumbnail_url'],
          );
        }).toList();

        return reels;
      } else {
        throw Exception('Failed to load reel data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> likeVideo(String id) async {
    try {
      final response = await _dio.put('$_baseUrl/$id');

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
      final response = await _dio.put('$_baseUrl/$id?increment=-1');

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

  void dispose() {
    for (var reel in reels) {
      reel.dispose();
    }
  }
}
