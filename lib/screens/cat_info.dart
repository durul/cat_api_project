import 'package:flutter/material.dart';
import '../api/cats_api.dart';

class CatInfo extends StatefulWidget {
  final String catBreed;
  final String catId;

  const CatInfo({super.key, required this.catBreed, required this.catId});

  @override
  State<CatInfo> createState() => _CatInfoState();
}

class _CatInfoState extends State<CatInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.catBreed),
        ),
        body: getCat());
  }

  Widget getCat() {
    final mediaSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: mediaSize.width,
        height: mediaSize.height,
      ),
    );
  }
}
