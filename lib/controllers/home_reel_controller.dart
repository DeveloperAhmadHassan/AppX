import 'package:dio/dio.dart';
import '../models/reel.dart';

class HomeReelController {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://192.168.0.119:3000/api/reels';

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
}
