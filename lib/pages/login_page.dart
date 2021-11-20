import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/login_bloc.dart';
import 'package:social_media/pages/register_page.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/utils/extensions.dart';
import 'package:social_media/widgets/button_view.dart';
import 'package:social_media/widgets/label_and_text_field_view.dart';
import 'package:social_media/widgets/loading_view.dart';
import 'package:social_media/widgets/or_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginBloc(),
      child: Scaffold(
        body: Selector(
          selector: (
            BuildContext context,
            LoginBloc bloc,
          ) =>
              bloc.isLoading,
          builder: (
            BuildContext context,
            bool isLoading,
            Widget? child,
          ) =>
              Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: LOGIN_TOP_PADDING,
                  bottom: MARGIN_LARGE,
                  left: MARGIN_XLARGE,
                  right: MARGIN_XLARGE,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      LABEL_LOGIN,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: TEXT_BIG,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XXLARGE,
                    ),
                    Consumer(
                      builder: (BuildContext context, LoginBloc bloc,
                              Widget? child) =>
                          LabelAndTextFieldView(
                        label: LABEL_EMAIL,
                        hint: HINT_EMAIL,
                        onChanged: (value) => bloc.onEmailChanged(value),
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    Consumer(
                      builder: (BuildContext context, LoginBloc bloc,
                              Widget? child) =>
                          LabelAndTextFieldView(
                        label: LABEL_PASSWORD,
                        hint: HINT_PASSWORD,
                        onChanged: (value) => bloc.onPasswordChanged(value),
                        isSecure: true,
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_XXLARGE,
                    ),
                    Consumer(
                      builder: (BuildContext context, LoginBloc bloc,
                              Widget? child) =>
                          ButtonView(
                        text: LABEL_LOGIN, onTap: () => bloc.onTapLogin(),
                        //     navigateToScreen(
                        //   context,
                        //   NewFeedPage(),
                        // ),
                      ),
                    ),
                    const SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    const ORView(),
                    const SizedBox(
                      height: MARGIN_LARGE,
                    ),
                    const RegisterTriggerView()
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
                child: LoadingView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterTriggerView extends StatelessWidget {
  const RegisterTriggerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LABEL_DO_NOT_HAVE_AN_ACCOUNT,
        ),
        const SizedBox(width: MARGIN_SMALL),
        GestureDetector(
          onTap: () => navigateToScreen(
            context,
            const RegisterPage(),
          ),
          child: const Text(
            LABEL_REGISTER,
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}
