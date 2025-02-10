import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ImageSearchPage extends StatefulWidget {
  final String query;
  final bool isFullPage;

  ImageSearchPage({required this.query, required this.isFullPage});

  @override
  _ImageSearchPageState createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchImageUrl(widget.query);
  }

  Future<void> fetchImageUrl(String query) async {
    final apiKey = "AIzaSyDRMtWE7SNna6eH1yoqdghqZUwdaxccUhU";

    final cx = 'd1c7be19190ee4c9c';
    final url =
        'https://www.googleapis.com/customsearch/v1?q=$query&cx=$cx&key=$apiKey&searchType=image&num=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['items'][0]['link'];
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFullPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Image Search"),
          backgroundColor: Colors.green[700],
        ),
        body: Center(
          child: imageUrl != null
              ? Image.network(imageUrl!)
              : CircularProgressIndicator(),
        ),
      );
    } else {
      return imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
              radius: 45.0,
            )
          : CircularProgressIndicator();
    }
  }
}
