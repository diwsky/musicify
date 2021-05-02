import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  SearchBox({this.onSearched});

  final Function onSearched;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  String _query;

  @override
  void initState() {
    super.initState();
    _query = "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: "Search artists or songs",
                  border: OutlineInputBorder()),
              onChanged: (value) {
                _query = value;
              },
              onSubmitted: (value) {
                widget.onSearched(value);
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          IconButton(
              icon: Icon(Icons.search),
              iconSize: 30.0,
              onPressed: () {
                widget.onSearched(_query);
              })
        ],
      ),
    );
  }
}
