import '../repository/reel_repository.dart';

class Reel {
  final String reelUrl;
  final String? title;
  final String? id;
  final String? views;
  final String? likes;
  final String? thumbnailUrl;
  bool? isLiked = false;
  DateTime? dateWatched;
  int? x;
  int? y;
  final List<String>? timestamps;

  Reel(
    this.reelUrl,
    {
      this.title,
      this.views,
      this.likes,
      this.id,
      this.thumbnailUrl,
      this.isLiked = false,
      this.dateWatched,
      this.x,
      this.y,
      this.timestamps,
    });

  Future<void> initializeIsLiked() async {
    if (id != null) {
      isLiked = await ReelRepository().isReelLiked(int.parse(id!));
    }
  }

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      json['reel_url'],
      title: json['reel_title'],
      views: json['views'].toString(),
      likes: json['likes'].toString(),
      id: json['id'].toString(),
      thumbnailUrl: json['reel_thumbnail_url'],
      timestamps: List<String>.from(json['timestamps'])
    );
  }

  Map<String, dynamic> toMap({bool forLikedVideos = false}) {
    var map = <String, dynamic>{
      'reel_url': reelUrl,
      'title': title,
      'views': views,
      'likes': likes,
      'db_id': id,
      'thumbnail_url': thumbnailUrl,
    };

    if (forLikedVideos && isLiked != null) {
      map['is_liked'] = isLiked! ? 1 : 0;
    }

    if (!forLikedVideos && dateWatched != null) {
      map['date_watched'] = dateWatched?.toIso8601String();
    }

    return map;
  }

  factory Reel.fromMap(Map<String, dynamic> map) {
    return Reel(
      map['reel_url'],
      title: map['title'].toString(),
      views: map['views'].toString(),
      likes: map['likes'].toString(),
      id: map['db_id'].toString(),
      thumbnailUrl: map['thumbnail_url'],
      isLiked: map['is_liked'] == 1,
      dateWatched: map['date_watched'] != null ? DateTime.parse(map['date_watched']) : null,
    );
  }
}
