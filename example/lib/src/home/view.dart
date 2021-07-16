import 'dart:io';

import 'package:example/src/camera/view.dart';
import 'package:example/src/home/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class HomePage extends StatelessWidget {
  const HomePage();

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
                separatorBuilder: (_, __) => GetTileSeparator(),
                itemBuilder: (_, index) {
                  final data = dataSet[index];
                  return GetTile.simple(
                    leading: Text(data.id),
                    title: data.description,
                    color: data.color,
                    accessory: data.attachment?.mapIt(
                      (icon) => PopupMenu<GetFile>(
                        cornerRadius: 0,
                        items: [data.file!],
                        childBuilder: (onPopup) => GetButton.icon(
                          icon: Icon(icon),
                          onPressed:
                              data.file?.isVideo == true ? () => null : onPopup,
                        ),
                        itemBuilder: (value, data) => Image(
                          image: $cast(Get.isWeb
                              ? NetworkImage(data.path)
                              : FileImage(File(data.path))),
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          width: 207,
                          height: 330,
                        ).popupMenuItem(
                          value: value,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    tintAccessory: true,
                    padAccessory: true,
                    onTap: () => Get.to(
                      () => const CameraPage(),
                    )?.then((file) {
                      data.file = file;
                      model.update();
                    }),
                  );
                },
              ),
            ),
          );
        },
      );
}
