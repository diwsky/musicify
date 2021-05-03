import 'package:flutter/material.dart';
import 'package:musicify/utilities/constants.dart';

class BottomPlayer extends StatelessWidget {
  BottomPlayer({
    this.isPlaying,
    this.onPlayPressed,
    this.onNextPressed,
    this.onPrevPressed,
    this.onSeekBar,
    this.position,
    this.musicLength,
  });
  final bool isPlaying;
  final Function onPlayPressed;
  final Function onNextPressed;
  final Function onPrevPressed;
  final Function onSeekBar;
  final Duration position;
  final Duration musicLength;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: 100.0,
        decoration: kBottomBoxDecoration,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    iconSize: 45.0,
                    icon: Icon(
                      Icons.skip_previous,
                    ),
                    onPressed: onPrevPressed,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey.withOpacity(0.1),
                    child: IconButton(
                        iconSize: 52.0,
                        icon: getIcons(isPlaying),
                        onPressed: onPlayPressed),
                  ),
                  IconButton(
                    iconSize: 45.0,
                    icon: Icon(Icons.skip_next),
                    onPressed: onNextPressed,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "${position.inMinutes}:${getPaddedTime(position.inSeconds.remainder(60).toString())}",
                      style: kTextTime,
                    ),
                    Expanded(
                      child: Slider.adaptive(
                        activeColor: Colors.cyanAccent,
                        inactiveColor: Colors.white,
                        max: musicLength.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) {
                          onSeekBar(value);
                        },
                      ),
                    ),
                    Text(
                      "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                      style: kTextTime,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getPaddedTime(String input) {
    return input.padLeft(2, '0');
  }

  Icon getIcons(bool isPlaying) {
    return isPlaying
        ? Icon(
            Icons.pause,
          )
        : Icon(
            Icons.play_arrow,
          );
  }
}
