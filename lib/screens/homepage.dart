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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = new ScrollController();
  bool _isPlaying;
  bool _isBottomBarShowingUp;
  int _currentId;

  // List of songs
  List<Widget> _playListWidget;

  // Music player
  AudioPlayer _player;
  Duration _position = new Duration();
  Duration _musicLength = new Duration();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _searchSongOrArtist(_query);
    // });

    _scrollController.addListener(() {});

    _isPlaying = false;
    _isBottomBarShowingUp = false;

    _playListWidget = [];
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
  void dispose() {
    _player.dispose();
    super.dispose();
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
                  _searchSongOrArtist(query);
                },
              ),
            ),
            Expanded(
              flex: 8,
              child: Stack(
                children: <Widget>[
                  // List song
                  _showMusicList(_playListWidget),

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
                        _seekToSec(value.toInt());
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

  Tween<Offset> _offset = Tween(begin: const Offset(1, 0), end: Offset(0, 0));

  Widget showListCards(List<Widget> playList) {
    return ListView.builder(
      itemCount: playList.length,
      controller: _scrollController,
      itemBuilder: (context, idx) {
        print('in playlist: $idx');
        return playList[idx];
      },
    );
  }

  _showMusicList(List<Widget> playList) {
    return playList.isEmpty ? _showEmptyList() : showListCards(playList);
  }

  void _playTheMusic(MusicData data, int idx) async {
    int result = await _player.play(data.songUrl, isLocal: false);
    print('Result play music: $result');

    print('idx: $idx, data id: ${data.id}, currentID: $_currentId');
    setState(() {
      _currentId = idx;
      print('_currentID after setState: $_currentId');
      _isPlaying = true;
      _isBottomBarShowingUp = true;
    });
  }

  Future<void> _searchSongOrArtist(String _queryParam) async {
    List<MusicData> current =
        await ItunesHandler().getPlayListFromQuery(_queryParam);
    setState(() {
      // _query = _queryParam;
      _playListWidget = current.asMap().entries.map((data) {
        int idx = data.key;
        MusicData eachData = data.value;
        return new MusicCard(
            id: eachData.id,
            isCardSelected: _currentId == idx,
            albumImg: eachData.albumUrl,
            songName: eachData.title,
            artist: eachData.artist,
            album: eachData.album,
            onPress: () {
              print('di onpressed, idx: $idx, and _currentId: $_currentId');
              _playTheMusic(eachData, idx);
            });
      }).toList();
    });
  }

  void _seekToSec(int value) async {
    Duration newPos = Duration(seconds: value);
    _player.seek(newPos);
  }

  Widget _showEmptyList() {
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
