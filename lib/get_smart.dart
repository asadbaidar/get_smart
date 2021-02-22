library get_smart;

import "package:auto_size_text/auto_size_text.dart";
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';

//packages
export "package:auto_size_text/auto_size_text.dart";
export "package:dots_indicator/dots_indicator.dart";
export "package:get/get.dart";
export "package:intl/intl.dart";
export "package:object_mapper/object_mapper.dart";
export "package:responsive_ui/responsive_ui.dart";
export "package:shared_preferences/shared_preferences.dart";
export "package:shimmer/shimmer.dart";
export "package:sprintf/sprintf.dart";
export "package:url_launcher/url_launcher.dart";

// res
export "src/res/colors.dart";
export "src/res/localizations.dart";
export "src/res/texts.dart";
export "src/res/themes.dart";
// utils
export "src/utils/base_controllers.dart";
export "src/utils/controller.dart";
export 'src/utils/route_observer.dart';
export "src/utils/utils.dart";
//widgets
export "src/widgets/autocomplete_textfield.dart";
export "src/widgets/button.dart";
export "src/widgets/scaffold.dart";
export "src/widgets/widgets.dart";

/// Dummy
// ignore: unused_element
class _Dummy {
  _Dummy() {
    if ("".isNotEmpty) {
      AutoSizeText(
        DateFormat.EEEE().format(DateTime.now()),
        style: Get.textTheme.caption,
      );
      Shimmer.fromColors(
        child: Div(child: DotsIndicator(dotsCount: 0)),
        baseColor: null,
        highlightColor: null,
      );
      sprintf("", "");
      launch("");
      SharedPreferences.getInstance();
      Mapper();
    }
  }
}
