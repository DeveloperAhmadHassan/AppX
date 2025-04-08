import 'dart:ffi';

import 'package:loopyfeed/models/reel.dart';

class SavedCollection {
  final int id;
  final String thumbnailUrl;
  final String collectionName;
  final int? isPublic;

  SavedCollection({
    required this.id,
    required this.thumbnailUrl,
    required this.collectionName,
    this.isPublic = 0,
  });

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{
  //     'reel_url': reel.reelUrl,
  //     'title': reel.title,
  //     'views': reel.views,
  //     'likes': reel.likes,
  //     'db_id': reel.id,
  //     'thumbnail_url': reel.thumbnailUrl,
  //     'is_saved' : 1,
  //     'collection_name': collectionName,
  //     'is_public': isPublic
  //   };
  //
  //   return map;
  // }

  factory SavedCollection.fromMap(Map<String, dynamic> map) {
    return SavedCollection(
      id: map['id'],
      thumbnailUrl: map['thumbnail_url'],
      collectionName: map['title'],
      isPublic: map['is_public']
    );
  }
}
