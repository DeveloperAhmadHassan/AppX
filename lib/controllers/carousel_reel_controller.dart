import 'package:dio/dio.dart';

import 'base_controller.dart';
import '../models/reel.dart';

class CarouselReelController extends BaseController {
  final Dio _dio;
  List<Reel> reels = [];

  CarouselReelController(this._dio) : super(_dio);

  Future<List<Reel>> fetchReelsData() async {
    try {
      final response = await _dio.get('$baseUrl/reels/carousel');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        List<Reel> reels = await Future.wait(jsonData.map((e) async {
          Reel reel = Reel.fromJson(e);
          await reel.initializeDynamicFields();
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
}
