import '../../../models/reel.dart';
import 'globals.dart';

Future<void> addReel(Reel reel) async {
  manageReels.value = List.from(manageReels.value)..add(reel);
}

Future<void> removeReel(Reel reel) async {
  manageReels.value = List.from(manageReels.value)..remove(reel);
}

Future<void> emptyList() async {
  manageReels.value = [];
}