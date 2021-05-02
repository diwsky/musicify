import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicify/components/bottom_player.dart';
import 'package:musicify/components/music_card.dart';
import 'package:musicify/components/search_box.dart';
import 'package:musicify/model/music_data.dart';
import 'package:musicify/utilities/constants.dart';
import 'package:musicify/utilities/itunes_handler.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isPlaying;
  bool _isBottomBarShowingUp;
  int _currentId;

  // List of songs
  List<MusicData> _playList;

  // Music player
  AudioPlayer _player;
  Duration _position = new Duration();
  Duration _musicLength = new Duration();

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isBottomBarShowingUp = false;

    _playList = [];
    _player = AudioPlayer();
    // AudioPlayer.logEnabled = true;

    _player.setVolume(1.0);
    _player.onPlayerCompletion.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });

    _player.onDurationChanged.listen((Duration p) {
      setState(() {
        _musicLength = p;
      });
    });

    _player.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
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
              child: SearchBox(
                onSearched: (query) {
                  searchSongOrArtist(query);
                },
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
                            await _player.resume();
                          } else {
                            await _player.pause();
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      onSeekBar: (value) {
                        seekToSec(value.toInt());
                      },
                      position: _position,
                      musicLength: _musicLength,
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
    return playList.isEmpty
        ? showEmptyList()
        : ListView(
            children: playList.map((eachData) {
              return new MusicCard(
                  id: eachData.id,
                  isCardSelected: _currentId == eachData.id,
                  albumImg: eachData.albumUrl,
                  songName: eachData.title,
                  artist: eachData.artist,
                  album: eachData.album,
                  onPress: () {
                    playTheMusic(eachData);
                  });
            }).toList(),
          );
  }

  void playTheMusic(MusicData data) async {
    int result = await _player.play(data.songUrl, isLocal: false);
    print('Result play music: $result');

    setState(() {
      _currentId = data.id;
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
    _player.seek(newPos);
  }

  Widget showEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/search.png",
            width: 150.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Let's search some songs!",
            textAlign: TextAlign.center,
            style: kTextMedium,
          )
        ],
      ),
    );
  }
}
