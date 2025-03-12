import 'package:dio/dio.dart';

import 'base_controller.dart';
import '../models/reel.dart';

class DiscoverReelController extends BaseController {
  final Dio _dio;

  DiscoverReelController(this._dio) : super(_dio);

  Future<Map<String, dynamic>> fetchReels(int page) async {
    try {
      final response = await _dio.get(
        '$baseUrl/reels/discover',
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
}
