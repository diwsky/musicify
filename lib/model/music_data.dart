class MusicData {
  String title;
  String artist;
  String album;
  String albumUrl;
  String songUrl;
  bool isSelected;

  MusicData(
      {this.isSelected,
      this.title,
      this.artist,
      this.album,
      this.songUrl,
      this.albumUrl});

  factory MusicData.fromJson(dynamic json) {
    String title = json['trackName'];
    String albumImg = json['artworkUrl100'];
    String artist = json['artistName'];
    String album = json['collectionName'];
    String songUrl = json['previewUrl'];

    print('title: $title, aritst: $artist, songUrl: $songUrl');

    return MusicData(
        isSelected: false,
        title: title,
        artist: artist,
        album: album,
        songUrl: songUrl,
        albumUrl: albumImg);
  }
}
