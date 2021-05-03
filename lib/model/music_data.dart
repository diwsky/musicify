class MusicData {
  int id;
  String title;
  String artist;
  String album;
  String albumUrl;
  String songUrl;

  MusicData(
      {this.id,
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

    return MusicData(
        id: id,
        title: title,
        artist: artist,
        album: album,
        songUrl: songUrl,
        albumUrl: albumImg);
  }
}
