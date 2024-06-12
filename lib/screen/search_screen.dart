import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_services.dart';
import 'package:toonflix/widget/search_widget.dart';
import 'package:toonflix/widget/webtoon_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<WebtoonModel>>? searchList;
  Future<List<WebtoonModel>> fullList = ApiServices.getTodaysToons();
  String? inputText;
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          leading: const Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: WidgetStatePropertyAll(
            Colors.grey.withOpacity(0.4),
          ),
          textStyle: WidgetStateProperty.all(const TextStyle(
            color: Colors.white,
            fontFamily: "Oswald",
            fontWeight: FontWeight.w600,
          )),
          hintText: "검색어를 입력하세요.",
          hintStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.white,
            ),
          ),
          onChanged: (value) {
            setState(() {
              inputText = value;
              searchList = ApiServices.searchToons(value);
            });
          },
        ),
        Expanded(
          child: Column(
            children: [
              if (searchList != null)
                Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: searchList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return makeList(snapshot);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: fullList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return makeList(snapshot);
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView makeList(
    AsyncSnapshot<List<WebtoonModel>> snapshot,
  ) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return SearchList(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }
}
