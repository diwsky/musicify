import 'dart:async';

import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  SearchBox({this.onSearched});

  final Function onSearched;

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final _searchQuery = new TextEditingController();
  String _query;
  Timer _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      Duration(
        milliseconds: 200,
      ),
      () {
        print('hit api!!!');
        widget.onSearched(_query);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _query = "";
    _searchQuery.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchQuery.removeListener(() {
      _onSearchChanged();
    });
    _searchQuery.dispose();
    super.dispose();
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
              controller: _searchQuery,
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
