import 'dart:io';

import 'package:example/src/camera/view.dart';
import 'package:example/src/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          final dataSet = controller.alphabets;
          return ThemeBuilder(
            (context) => GetScaffold(
              sliver: GetListView.builder(
                topSliverBuilder: (context) => GetAppBar.sliver(
                  title: "Get Smart Home",
                  progress: LinearProgress.standard(
                    visible: controller.isBusy,
                  ),
                  onRefresh: controller.refreshData,
                  actions: [
                    GetButton.icon(
                      child:
                          const RiveAnimation.asset("assets/rive/cancer.riv"),
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
                ),
                itemCount: dataSet.length,
                divider: DividerStyle.leading,
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
                      controller.update();
                    }),
                  );
                },
              ),
            ),
            theme: GetTheme.sky(context),
          );
        },
      );
}
