import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeEmbed extends StatefulWidget {
  final String videoID;

  YoutubeEmbed(this.videoID);

  @override
  _YoutubeEmbedState createState() => _YoutubeEmbedState(videoID);
}

class _YoutubeEmbedState extends State<YoutubeEmbed> {
  String videoID;
  YoutubePlayerController _controller;

  _YoutubeEmbedState(this.videoID) {
    _controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        mute: false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayer(
        width: MediaQuery.of(context).size.width,
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        onReady: () {
          // _controller.cue(videoID);

          // _controller.addListener(listener);
        },
      ),
    );
    return Container(
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          width: MediaQuery.of(context).size.width,
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            // _controller.cue(videoID);

            // _controller.addListener(listener);
          },
        ),
        builder: (context, player) {
          return Container(
            child: player,
          );
        },
      ),
    );
  }
}
