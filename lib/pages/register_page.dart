import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/blocs/register_bloc.dart';
import 'package:social_media/resources/dimens.dart';
import 'package:social_media/resources/strings.dart';
import 'package:social_media/utils/extensions.dart';
import 'package:social_media/widgets/button_view.dart';
import 'package:social_media/widgets/label_and_text_field_view.dart';
import 'package:social_media/widgets/loading_view.dart';
import 'package:social_media/widgets/or_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterBloc(),
      child: Scaffold(
        body: Selector(
          selector: (
            BuildContext context,
            RegisterBloc bloc,
          ) =>
              bloc.isLoading,
          builder: (
            BuildContext context,
            bool isLoading,
            Widget? child,
          ) =>
              Stack(
            children: [
              SingleChildScrollView(
                child: Container(
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
                        LABEL_REGISTER,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TEXT_BIG,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),
                      Consumer(
                        builder: (BuildContext context, RegisterBloc bloc,
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
                        builder: (BuildContext context, RegisterBloc bloc,
                                Widget? child) =>
                            LabelAndTextFieldView(
                          label: LABEL_USER_NAME,
                          hint: HINT_USER_NAME,
                          onChanged: (value) => bloc.onUserNameChanged(value),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),
                      Consumer(
                        builder: (BuildContext context, RegisterBloc bloc,
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
                        builder: (BuildContext context, RegisterBloc bloc,
                                Widget? child) =>
                            ButtonView(
                          onTap: () {
                            bloc
                                .onTapRegister()
                                .then(
                                  (value) => Navigator.of(context).pop(),
                                )
                                .catchError(
                                  (error) => showSnackBarWithMessage(
                                    context,
                                    error.toString(),
                                  ),
                                );
                          },
                          text: LABEL_REGISTER,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const ORView(),
                      const SizedBox(
                        height: MARGIN_LARGE,
                      ),
                      const LoginTriggerView()
                    ],
                  ),
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

class LoginTriggerView extends StatelessWidget {
  const LoginTriggerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          LABEL_ALREADY_HAVE_AN_ACCOUNT,
        ),
        const SizedBox(width: MARGIN_SMALL),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            LABEL_LOGIN,
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
