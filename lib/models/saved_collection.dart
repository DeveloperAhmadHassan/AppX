import 'dart:ffi';

import 'package:loopyfeed/models/reel.dart';

class SavedCollection {
  final Reel reel;
  final String? collectionName;
  final int? isPublic;

  SavedCollection({
    required this.reel,
    this.collectionName,
    this.isPublic = 0,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'reel_url': reel.reelUrl,
      'title': reel.title,
      'views': reel.views,
      'likes': reel.likes,
      'db_id': reel.id,
      'thumbnail_url': reel.thumbnailUrl,
      'is_saved' : 1,
      'collection_name': collectionName,
      'is_public': isPublic
    };

    return map;
  }

}
