class MusicData {
  int id;
  String title;
  String artist;
  String album;
  String albumUrl;
  String songUrl;
  bool isSelected;

  MusicData(
      {this.id,
      this.isSelected,
      this.title,
      this.artist,
      this.album,
      this.songUrl,
      this.albumUrl});

  factory MusicData.fromJson(dynamic json) {
    int id = json['trackId'];
    String title = json['trackName'];
    String albumImg = json['artworkUrl100'];
    String artist = json['artistName'];
    String album = json['collectionName'];
    String songUrl = json['previewUrl'];

    print('title: $title, aritst: $artist, songUrl: $songUrl');

    return MusicData(
        id: id,
        isSelected: false,
        title: title,
        artist: artist,
        album: album,
        songUrl: songUrl,
        albumUrl: albumImg);
  }
}
