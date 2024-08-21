import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/cats_api.dart';
import '../components/cat_image_widget.dart';
import '../model/cats.dart';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  const CatInfo({super.key, required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  CatList catList = CatList(breeds: List.empty());

  void getCatSpecificData() async {
    final catJson = await CatAPI().getCatBreed(widget.catId);

    final dynamic catMap = json.decode(catJson);

    setState(() {
      catList = CatList.fromJson(catMap);
    });
  }

  @override
  void initState() {
    super.initState();
    getCatSpecificData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.catBreed),
      ),
      body: getCat(),
    );
  }

  Widget getCat() {
    if (catList.breeds.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Center(
        child: CatImage(
          imageUrl: catList.breeds[0].url,
          breed: widget.catBreed,
        ),
      );
    }
  }
}
