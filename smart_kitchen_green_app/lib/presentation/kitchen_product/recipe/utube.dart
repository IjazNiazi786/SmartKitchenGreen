import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kitchen_green_app/PRIVATE_KEYS.dart';
import 'package:smart_kitchen_green_app/widgets/custom_appbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeRecommender extends StatefulWidget {
  final String query;
  const RecipeRecommender({super.key, required this.query});

  @override
  State<RecipeRecommender> createState() => _RecipeRecommenderState();
}

class _RecipeRecommenderState extends State<RecipeRecommender> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        appBar: AppBar(title: Text("Recipes Recommended for ${widget.query}")),
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 4),
                child: YouTubeVideoPage(
                    query: "Different Recipes For ${widget.query}"))
          ],
        ),
      ),
    );
  }
}

class YouTubeVideoPage extends StatefulWidget {
  final String query;

  YouTubeVideoPage({required this.query});

  @override
  _YouTubeVideoPageState createState() => _YouTubeVideoPageState();
}

class _YouTubeVideoPageState extends State<YouTubeVideoPage> {
  List<String> videoIds = [];

  @override
  void initState() {
    super.initState();
    fetchYouTubeVideos(widget.query);
  }

  Future<void> fetchYouTubeVideos(String query) async {
    const apiKey = googleApiKey;
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=$query&type=video&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videoIds = (data['items'] as List)
            .map((item) => item['id']['videoId'] as String)
            .toList();
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: videoIds.length,
        itemBuilder: (context, index) {
          return YouTubeVideoPlayer(videoId: videoIds[index]);
        },
      ),
    );
  }
}

class YouTubeVideoPlayer extends StatelessWidget {
  final String videoId;

  YouTubeVideoPlayer({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
      ),
    );
  }
}
