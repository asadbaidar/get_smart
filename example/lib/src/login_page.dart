import 'package:example/src/home/view.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class LoginPage extends StatelessWidget {
  const LoginPage();

  GlobalKey<FormState> get form => use(GlobalKey<FormState>());

  bool get isValid => true; // ?? form.state?.validate() == true;

  @override
  Widget build(BuildContext context) => GetScaffold(
        hideAppBarLeading: true,
        centerTitle: true,
        title: "Log In",
        children: [
          Padding(
            padding: EdgeInsets.all(26),
            child: GetForm(
              key: form,
              child: Column(children: [
                GetTextField(
                  label: "Email",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  filled: true,
                ),
                SizedBox(height: 8),
                GetTextField(
                  label: "Password",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  obscureText: true,
                  showCounter: false,
                  filled: true,
                ),
                SizedBox(height: 12),
                GetButton.roundElevated(
                  horizontalPadding: 48,
                  verticalPadding: 14,
                  child: Text("Log In"),
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
