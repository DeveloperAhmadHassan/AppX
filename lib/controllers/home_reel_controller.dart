import 'package:dio/dio.dart';
import '../database/database_helper.dart';
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
        List<Reel> reels = await Future.wait(data.map((e) async {
          Reel reel = Reel.fromJson(e);
          await reel.initializeIsLiked();
          return reel;
        }).toList());

        Map<String, dynamic> pagination = response.data['pagination'];

        return {'reels': reels, 'pagination': pagination};
      } else {
        throw Exception('Failed to load reels');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> likeVideo(Reel reel) async {
    try {
      final response = await _dio.put('$_baseUrl/likes/${reel.id}');

      if (response.statusCode == 200) {
        reel.isLiked = true;
        await DatabaseHelper.instance.insertLikedVideo(reel);
        print("liked");
        return true;
      } else {
        throw Exception('Failed to like reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> unlikeVideo(Reel reel) async {
    try {
      final response = await _dio.put('$_baseUrl/likes/${reel.id}?increment=-1');

      if (response.statusCode == 200) {
        reel.isLiked = false;
        await DatabaseHelper.instance.deleteLikedVideo(int.parse(reel.id ?? "1"));
        print("unliked");
        return true;
      } else {
        throw Exception('Failed to unlike reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> incrementViews(Reel reel) async {
    try {
      final response = await _dio.put('$_baseUrl/views/${reel.id}');

      if (response.statusCode == 200) {
        print('Views incremented');
        // reel.dateWatched = true;
        await DatabaseHelper.instance.insertWatchHistory(reel);
        return true;
      } else {
        throw Exception('Failed to increase views of reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

