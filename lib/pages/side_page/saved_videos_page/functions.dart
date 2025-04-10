import '../../../models/reel.dart';
import 'globals.dart';

Future<void> addReel(Reel reel) async {
  manageReels.value = List.from(manageReels.value)..add(reel);
  reelIds.value = List.from(reelIds.value)..add(reel.id ?? "1");
}

Future<void> removeReel(Reel reel) async {
  manageReels.value = List.from(manageReels.value)..remove(reel);
  reelIds.value = List.from(reelIds.value)..remove(reel.id ?? "1");
}

Future<void> emptyList() async {
  manageReels.value = [];
  reelIds.value = [];
}