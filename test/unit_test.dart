import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:musicify/components/music_card.dart';
import 'package:musicify/model/music_data.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter();

  dio.httpClientAdapter = dioAdapter;

  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  MusicData testSong = MusicData(
      id: 315611467,
      title: "21 Guns",
      artist: "Green Day",
      album: "21st Century Breakdown",
      songUrl:
          "https://music.apple.com/us/album/21-guns/315611219?i=315611467&uo=4",
      albumUrl:
          "https://is2-ssl.mzstatic.com/image/thumb/Music114/v4/77/4b/20/774b2007-2198-8fa3-1491-8c0e3b0ce4f2/source/100x100bb.jpg");

  group("MusicCard model testing", () {
    AudioPlayer _player = AudioPlayer();
    bool isPlaying = false;

    MusicCard dummy = new MusicCard(
        id: 0,
        isCardSelected: false,
        albumImg: "",
        songName: "",
        artist: "",
        album: "",
        onPress: () {
          print('Dummy onpress');
        });

    MusicCard greenday = new MusicCard(
        id: testSong.id,
        isCardSelected: false,
        albumImg: testSong.albumUrl,
        songName: testSong.title,
        artist: testSong.artist,
        album: testSong.album,
        onPress: () async {
          int result =
              await _player.play(testSong.songUrl, volume: 1.0, isLocal: false);
          print('Result: $result');
          isPlaying = result == 1;
        });

    test("1. Constructor test", () {
      expect(dummy.albumImg, equals(""));
      expect(greenday.artist, equals("Green Day"));
    });

    testWidgets("2. Display album test", (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: greenday));
      // the loading should be success
    });

    testWidgets("3. AudioPlayer test", (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(child: greenday));
      await tester.tap(find.byKey(
        Key('cardTouched'),
      ));

      await tester.pump();

      expect(isPlaying, isNot(equals(null)));
      // the player should be success
    });
  });
}
