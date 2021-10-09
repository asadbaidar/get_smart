import 'package:example/src/home/view.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  GlobalKey<FormState> get form => use(GlobalKey<FormState>());

  bool get isValid => true; // ?? form.state?.validate() == true;

  @override
  Widget build(BuildContext context) => GetScaffold(
        showAppBarLeading: false,
        centerTitle: true,
        title: "Log In",
        children: [
          Padding(
            padding: const EdgeInsets.all(26),
            child: GetForm(
              key: form,
              child: Column(children: [
                GetTextField(
                  label: "Email",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  filled: true,
                ),
                8.spaceY,
                GetTextField(
                  label: "Password",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  obscureText: true,
                  showCounter: false,
                  filled: true,
                ),
                12.spaceY,
                GetButton.roundElevated(
                  horizontalPadding: 48,
                  verticalPadding: 14,
                  child: const Text("Log In"),
                  onPressed: () {
                    if (isValid) Get.to(() => const HomePage());
                  },
                ),
              ]),
            ),
          )
        ],
      );
}
