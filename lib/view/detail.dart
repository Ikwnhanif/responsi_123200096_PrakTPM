import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final String? mealId;

  DetailPage({required this.mealId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> mealDetails;

  @override
  void initState() {
    super.initState();
    mealDetails = fetchMealDetail();
  }

  Future<Map<String, dynamic>> fetchMealDetail() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  void _launchYoutubeVideo(String youtubeUrl) async {
    if (await canLaunch(youtubeUrl)) {
      await launch(youtubeUrl);
    } else {
      throw Exception('Could not launch $youtubeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: mealDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data['meals'][0]['strMealThumb'] != null)
                      Image.network(
                        data['meals'][0]['strMealThumb'],
                        height: 200,
                      ),
                    SizedBox(height: 16),
                    Text(
                      data['meals'][0]['strMeal'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Category: ${data['meals'][0]['strCategory']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Area: ${data['meals'][0]['strArea']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Instructions: ${data['meals'][0]['strInstructions']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        String youtubeUrl = data['meals'][0]['strYoutube'];
                        _launchYoutubeVideo(youtubeUrl);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Change button color
                      ),
                      child: Text(
                        'Watch on YouTube',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load meal details'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
