import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicify/components/bottom_player.dart';
import 'package:musicify/components/search_box.dart';
import 'package:musicify/model/music_data.dart';
import 'package:musicify/utilities/constants.dart';
import 'package:musicify/utilities/itunes_handler.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ScrollController _scrollController = new ScrollController();
  bool _isPlaying;
  bool _isBottomBarShowingUp;
  int _currentId;

  // List of songs
  List<MusicData> _playListData;

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

    _scrollController.addListener(() {
      print('add listenerrrr');
    });

    _isPlaying = false;
    _isBottomBarShowingUp = false;
    
    _playListData = [];
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
                  // _showMusicList(_playListData),
                  showListCards(_playListData),

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

  Widget showListCards(List<MusicData> playList) {
    print('onShowListCards...');
    return playList.isEmpty
        ? _showEmptyList()
        : ListView.builder(
            itemCount: playList.length,
            controller: _scrollController,
            itemBuilder: (context, idx) {
              return ListTile(
                leading: Image.network(playList[idx].albumUrl),
                title: Text(playList[idx].title),
                subtitle:
                    Text('${playList[idx].artist} - ${playList[idx].album}'),
                onTap: () {
                  _playTheMusic(playList[idx]);
                },
                tileColor: playList[idx].id == _currentId
                    ? Colors.black
                    : Colors.grey[800],
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                trailing: playList[idx].id == _currentId
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.play_circle_fill, size: 35.0),
                      )
                    : null,
              );
            },
          );
  }

  void _playTheMusic(MusicData data) async {
    int result = await _player.play(data.songUrl, isLocal: false);
    print('Result play music: $result');
    print('_playTheMusic...');

    setState(() {
      _currentId = data.id;
      _isPlaying = true;
      _isBottomBarShowingUp = true;
    });
  }

  Future<void> _searchSongOrArtist(String _queryParam) async {
    print('search song or artist....');
    List<MusicData> current =
        await ItunesHandler().getPlayListFromQuery(_queryParam);
    setState(() {
      // _query = _queryParam;
      _playListData = current;
    });
  }

  void _seekToSec(int value) async {
    Duration newPos = Duration(seconds: value);
    _player.seek(newPos);
  }

  Widget _showEmptyList() {
    print('SHOW EMPTY!!!!!');
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
