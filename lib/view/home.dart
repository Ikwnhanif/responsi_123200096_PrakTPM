import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsi_123200096/view/meals.dart';

class MealCategory {
  final String idCategory;
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  MealCategory({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MealCategory>> _mealCategories;
  String? text;

  @override
  void initState() {
    super.initState();
    _mealCategories = fetchMealCategories();
  }

  Future<List<MealCategory>> fetchMealCategories() async {
    final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> categories = data['categories'];

      return categories
          .map((category) => MealCategory(
                idCategory: category['idCategory'],
                strCategory: category['strCategory'],
                strCategoryThumb: category['strCategoryThumb'],
                strCategoryDescription: category['strCategoryDescription'],
              ))
          .toList();
    } else {
      throw Exception('Failed to load meal categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder<List<MealCategory>>(
        future: _mealCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final mealCategories = snapshot.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: mealCategories!.length,
              itemBuilder: (context, index) {
                final category = mealCategories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MealsView(text: category.strCategory);
                    }));
                  },
                  child: Card(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            category.strCategoryThumb,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.strCategory,
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load meal categories'),
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
