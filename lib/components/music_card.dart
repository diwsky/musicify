import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MusicCard extends StatefulWidget {
  final int id;
  final bool isCardSelected;
  final String albumImg;
  final String songName;
  final String artist;
  final String album;
  final Function onPress;

  const MusicCard(
      {@required this.id,
      @required this.isCardSelected,
      @required this.albumImg,
      @required this.songName,
      @required this.artist,
      @required this.album,
      @required this.onPress});

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Container(
        decoration: BoxDecoration(
            color: widget.isCardSelected ? Colors.black : Colors.grey[600]),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    "${widget.albumImg}",
                    width: 75.0,
                  ),
                  widget.isCardSelected
                      ? Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            size: 50.0,
                          ),
                        )
                      : Container()
                ],
              ),
              SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${widget.songName}',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${widget.artist}',
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${widget.album}',
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
