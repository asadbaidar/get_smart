import 'package:example/src/api.dart';
import 'package:example/src/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class HomePage extends StatelessWidget {
  static const items = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
  ];

  @override
  Widget build(BuildContext context) => GetBuilder<HomeModel>(
        init: HomeModel(),
        builder: (model) {
          final dataSet = model.alphabets;
          return GetScaffold(
            title: "Get Smart Home",
            progressBar: LinearProgress.standard(
              color: Colors.blue,
              visible: model.isBusy,
            ),
            child: SwipeRefresh(
              onRefresh: model.refreshData,
              child: ListView.separated(
                itemCount: dataSet.length,
                separatorBuilder: (_, __) => AppTileSeparator(),
                itemBuilder: (_, index) {
                  var data = dataSet[index];
                  return AppTile.simple(
                    leading: Text(data.id),
                    title: data.description,
                    color: data.color,
                    onTap: () => null,
                  );
                },
              ),
            ),
          );
        },
      );
}

class HomeModel extends GetController {
  final api = Api();

  @override
  Future futureToRun() => getAlphabets();

  List<Alphabet> get alphabets => modelData?.data ?? [];

  Future getAlphabets() => runBusyFuture(api.getAlphabets());
}
