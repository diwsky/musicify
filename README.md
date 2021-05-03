# Musicify

A simple music player using Flutter!

## Features

1. Search your favourite artist/song in iTunes!
2. Enjoy your 30s preview song.
3. Pause or seek the duration of your song.
4. Search other song while you listening to the current song.

## Supported Device

- Android device with minimum API 23 **(Marshmallow)**

## Build App requirements

- Recommended using Flutter 2.0 in this [Stable channel](https://github.com/flutter/flutter.git)
- Using Dart v2.12.2

## Instructions

1. Clone from this repository
   - Copy repository url
   - Open your fav code editor _(Recommended using Android Studio)_
   - New -> Project from Version Control..
   - Paste the url, click OK
2. Run "flutter pub get" in the project directory or click the highlighted instruction in Android Studio
3. Prepare the Android Virtual Device or real device 
4. Run main.dart

## Code Design & Structure

This project directory consist of 4 directories:
1. **Components**: _consists widgets that build the main screen (homepage) and do it's function_
   - `bottom_player`: _widget that provide the player controller, which are play/pause button and seek bar (see the green part in screenshot)_
   - `music_card`: _widget that provide list of the songs after query. If there's no list, it will show default container (see the yellow part in screenshot)_
   - `search_box`: _widget that receive user's keywords for songs. Query can be done either by pressing side search button or enter button on keyboard (see the red part in screenshot)_
2. **Model**: _consists models or data structure that being used in the project_
   - `music_data`: _provide the detail of each song's data, which are: title, artist, album, url of album image, and url of the m4a preview song_
3. **Screens**: _consists page that shown to the user_
   - `homepage`: _provide the main screen for the components and declare the basic functional_
4. **Utilities**: _consists tools that support the component's function_
   - `api_caller`: _function to do API command_
   - `constants`: _provide constants and styles to the project_
   - `itunes_handler`: _provide the MediaData list from iTunes Affiliate API_

Library that used to play the audio file: [AudioPlayers](https://pub.dev/packages/audioplayers) v0.18.3

## Screenshots
![No playlist](https://imgur.com/gK2wez4)
![After searching](https://imgur.com/x4r8QkW)
 
   
