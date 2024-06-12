import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_services.dart';
import 'package:toonflix/widget/favorite_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScrennState();
}

class _FavoriteScrennState extends State<FavoriteScreen> {
  late SharedPreferences pref;
  late List<String>? allLikedToons;
  Future<List<WebtoonModel>> allWebtoons = ApiServices.getTodaysToons();
  Future<List<WebtoonModel>>? likedList;
  bool isLoading = true;

  Future InitPref() async {
    pref = await SharedPreferences.getInstance();
    allLikedToons = pref.getStringList('likedToons');
    if (allLikedToons != null) {
      likedList = ApiServices.likeToons(allLikedToons!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    InitPref();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '당신이 좋아하는 콘텐츠',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Oswald",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        if (isLoading == false && likedList != null)
          Expanded(
            child: FutureBuilder(
              future: likedList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return makeList(snapshot);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
      ],
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return FavoriteWidget(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }
}
