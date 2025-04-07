import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../repository/reel_repository.dart';
import '../models/reel.dart';
import '../models/saved_collection.dart';

class BaseController {
  final Dio _dio;
  final String baseUrl = 'https://appx-dashboard.vercel.app/api';
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
    print('incrementing views');

    try {
      final response = await _dio.put('$baseUrl/reels/view/${reel.id}');

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

  Future<bool> saveVideo(SavedCollection collection) async {
    try {
      final response = await _dio.put('$baseUrl/reels/saves/${collection.reel.id}?collection_name=${collection.collectionName}&is_public=${collection.isPublic}');

      if (response.statusCode == 200) {
        collection.reel.isSaved = true;
        await ReelRepository().addSavedVideo(collection);
        if (kDebugMode) {
          print("saved");
        }
        return true;
      } else {
        throw Exception('Failed to save reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> unSaveVideo(SavedCollection collection) async {
    try {
      final response = await _dio.put('$baseUrl/reels/saves/${collection.reel.id}?increment=-1');

      if (response.statusCode == 200) {
        collection.reel.isSaved = false;
        await ReelRepository().removeSavedVideo(int.parse(collection.reel.id ?? "1"));
        if (kDebugMode) {
          print("unsaved");
        }
        return true;
      } else {
        throw Exception('Failed to unSave reel');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}