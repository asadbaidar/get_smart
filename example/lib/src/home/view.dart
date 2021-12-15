import 'dart:io';

import 'package:example/src/camera/view.dart';
import 'package:example/src/home/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_smart/get_smart.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<HomeModel>(
        init: HomeModel(),
        builder: (model) {
          final dataSet = model.alphabets;
          return ThemeBuilder(
            (context) => GetScaffold(
              title: "Get Smart Home",
              appBarActions: [
                GetButton.icon(
                  child: const RiveAnimation.asset("assets/rive/cancer.riv"),
                  onPressed: () {},
                ),
                GetButton.icon(
                  child: SvgPicture.asset(
                    GetIconAsset.apple_filled.svg,
                    package: GetAsset.package,
                    color: context.secondaryColor,
                  ),
                  onPressed: () {},
                ),
              ],
              progress: LinearProgress.standard(
                visible: model.isBusy,
              ),
              child: SwipeRefresh(
                onRefresh: model.refreshData,
                child: ListView.separated(
                  itemCount: dataSet.length,
                  separatorBuilder: (_, __) => const GetTileDivider(),
                  itemBuilder: (_, index) {
                    final data = dataSet[index];
                    return GetTile.simple(
                      leading: Text(data.id),
                      title: data.description,
                      color: data.color,
                      accessory: data.attachment?.mapIt(
                        (icon) => GetPopupMenu<GetFile>(
                          cornerRadius: 0,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          items: [data.file!],
                          childBuilder: (onPopup) => GetButton.icon(
                            child: Icon(icon),
                            onPressed:
                                data.file?.isVideo == true ? () {} : onPopup,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
            ),
            theme: GetTheme.sky(context),
          );
        },
      );
}
