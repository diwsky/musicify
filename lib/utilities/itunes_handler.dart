import 'package:musicify/utilities/api_caller.dart';
import 'package:musicify/utilities/constants.dart';

import '../model/music_data.dart';

class ItunesHandler {
  Future<List<MusicData>> getPlayListFromQuery(String search) async {
    String searchUrl = '$apiUrl?term=$search';

    var data = await ApiCall(url: searchUrl).getData();
    var allResults = data['results'] as List;
    var songResults = allResults.where((key) => key['kind'] == 'song').toList();

    List<MusicData> output = [];

    output = songResults.map((eachData) {
      return MusicData.fromJson(eachData);
    }).toList();

    return output;
  }
}
