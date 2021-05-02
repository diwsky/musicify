import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicify/components/bottom_player.dart';
import 'package:musicify/components/music_card.dart';
import 'package:musicify/model/music_data.dart';
import 'package:musicify/utilities/itunes_handler.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _query;
  bool _isPlaying;
  bool _isBottomBarShowingUp;
  int idx;
  List<MusicData> _playList;

  // Player
  AudioPlayer _player;
  Duration position = new Duration();
  Duration musicLength = new Duration();

  var _isCardSelected = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isBottomBarShowingUp = false;
    idx = 0;

    _playList = [];
    _player = AudioPlayer();
    AudioPlayer.logEnabled = true;

    _player.setVolume(100.0);
    _player.onPlayerCompletion.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });

    _player.onDurationChanged.listen((Duration p) {
      setState(() {
        musicLength = p;
      });
    });

    _player.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Musicify"),
        elevation: 10.0,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Search artists or songs",
                          border: OutlineInputBorder()),
                      onChanged: (value) {
                        _query = value;
                      },
                      onSubmitted: (value) async {
                        searchSongOrArtist(value);
                      },
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      iconSize: 30.0,
                      onPressed: () async {
                        searchSongOrArtist(_query);
                      })
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Stack(
                children: <Widget>[
                  // List song
                  showMusicList(_playList),

                  // Bottom player
                  Visibility(
                    visible: _isBottomBarShowingUp,
                    child: BottomPlayer(
                      isPlaying: _isPlaying,
                      onPlayPressed: () async {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        try {
                          if (_isPlaying) {
                            int result = await _player.resume();
                            print('Result resume: $result');
                          } else {
                            int result = await _player.pause();
                            print('Result pause: $result');
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      onSeekBar: (value) {
                        seekToSec(value.toInt());
                      },
                      position: position,
                      musicLength: musicLength,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showMusicList(List<MusicData> playList) {
    return ListView(
      children: playList.map((eachData) {
        return new MusicCard(
            isCardSelected: eachData.isSelected,
            albumImg: eachData.albumUrl,
            songName: eachData.title,
            artist: eachData.artist,
            album: eachData.album,
            onPress: () {
              setState(() {
                eachData.isSelected = true;
              });
              playTheMusic(eachData);
            });
      }).toList(),
    );
  }

  void playTheMusic(MusicData data) async {
    int result = await _player.play(data.songUrl, isLocal: false);
    print('Result play music: $result');

    setState(() {
      _isPlaying = true;
      _isBottomBarShowingUp = true;
    });
  }

  Future<void> searchSongOrArtist(String _query) async {
    List<MusicData> current =
        await ItunesHandler().getPlayListFromQuery(_query);
    setState(() {
      _playList = current;
    });
  }

  void seekToSec(int value) async {
    Duration newPos = Duration(seconds: value);
    int resultSeek = await _player.seek(newPos);
    print('Result seek: $resultSeek');
  }
}
