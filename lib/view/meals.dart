import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsi_123200096/controller/meals_data_source.dart';
import 'package:responsi_123200096/models/meals.dart';

import 'detail.dart';

class MealsView extends StatefulWidget {
  final String text;

  const MealsView({Key? key, required this.text}) : super(key: key);

  @override
  _MealsViewState createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.text),
      ),
      body: Container(
        child: FutureBuilder(
          future: MealsDataSource.instance.loadMeals(widget.text),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError || widget.text.isEmpty) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              Makanan maem = Makanan.fromJson(snapshot.data);
              return _buildSuccessSection(maem);
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    if (widget.text.isEmpty) {
      return const Center(child: Text("Search bar cannot be empty"));
    } else {
      return const Center(child: Text("Error"));
    }
  }

  Widget _buildSuccessSection(Makanan data) {
    return ListView.builder(
      itemCount: data.meals?.length,
      itemBuilder: (BuildContext context, int index) {
        final maem = data.meals![index];
        return Card(
          elevation: 2,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(mealId: maem.idMeal),
                ),
              );
            },
            leading: Image.network(
              maem.strMealThumb as String,
              fit: BoxFit.cover,
              width: 80,
            ),
            title: Text(
              maem.strMeal as String,
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
