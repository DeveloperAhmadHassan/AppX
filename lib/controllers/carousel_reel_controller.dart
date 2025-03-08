import 'package:dio/dio.dart';
import 'package:heroapp/models/reel.dart';

import '../database/database_helper.dart';

class CarouselReelController {
  final Dio _dio;
  final String _baseUrl = 'https://appx-api.vercel.app/api/reels';
  List<Reel> reels = [];

  CarouselReelController(this._dio);

  Future<List<Reel>> fetchReelsData() async {
    try {
      final response = await _dio.get('$_baseUrl/carousel');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        List<Reel> reels = await Future.wait(jsonData.map((e) async {
          Reel reel = Reel.fromJson(e);
          await reel.initializeIsLiked();
          return reel;
        }).toList());

        return reels;
      } else {
        throw Exception('Failed to load reel data');
      }
    } catch (e) {
      throw Exception('Error: $e');
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
}
