import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../repository/reel_repository.dart';
import '../models/reel.dart';

class BaseController {
  final Dio _dio;
  final String baseUrl = 'https://appx-api.vercel.app/api';
  BaseController(this._dio);

  Future<bool> likeVideo(Reel reel) async {
    try {
      final response = await _dio.put('$baseUrl/reels/likes/${reel.id}');

      if (response.statusCode == 200) {
        reel.isLiked = true;
        await ReelRepository().addLikedVideo(reel);
        if (kDebugMode) {
          print("liked");
        }
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
      final response = await _dio.put('$baseUrl/reels/likes/${reel.id}?increment=-1');

      if (response.statusCode == 200) {
        reel.isLiked = false;
        await ReelRepository().removeLikedVideo(int.parse(reel.id ?? "1"));
        if (kDebugMode) {
          print("unliked");
        }
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
      final response = await _dio.put('$baseUrl/reels/views/${reel.id}');

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Views incremented');
        }
        await ReelRepository().addWatchHistory(reel);
        return true;
      } else {
        throw Exception('Failed to increase views of reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteFromWatchHistory(Reel reel) async {
    try {
      await ReelRepository().removeWatchHistory(int.parse(reel.id ?? '1'));
      return true;
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}