import '../database/database_helper.dart';
import '../models/reel.dart';

class ReelRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addLikedVideo(Reel reel) async {
    return await dbHelper.insertLikedVideo(reel);
  }

  Future<int> addWatchHistory(Reel reel) async {
    // reel.isLiked = null;
    return await dbHelper.insertWatchHistory(reel);
  }

  Future<List<Reel>> getLikedVideos() async {
    return await dbHelper.getLikedVideos();
  }

  Future<List<Reel>> getWatchHistory() async {
    return await dbHelper.getWatchHistory();
  }

  Future<int> removeLikedVideo(int id) async {
    return await dbHelper.deleteLikedVideo(id);
  }

  Future<int> removeWatchHistory(int id) async {
    return await dbHelper.deleteWatchHistory(id);
  }
}
