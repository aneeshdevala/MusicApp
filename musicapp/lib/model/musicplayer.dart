import 'package:hive/hive.dart';
part 'musicplayer.g.dart';

@HiveType(typeId: 1)
class MusicPlayer extends HiveObject {
  //box creation

  int? id;
  @HiveField(0)
  String name;
  MusicPlayer({required this.name, this.id});
}
